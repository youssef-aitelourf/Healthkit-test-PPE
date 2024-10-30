//
//  GameViewController.swift
//  PPE-TEST-SPRITEKIT
//
//  Created by Youssef Ait Elourf on 10/30/24.
//
import UIKit
import SpriteKit
import HealthKit

class GameViewController: UIViewController {
    
    let healthStore = HKHealthStore()
    var gameScene: GameScene?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if HealthKit is available
        if HKHealthStore.isHealthDataAvailable() {
            requestHealthAuthorization()
        } else {
            print("HealthKit is not available on this device.")
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.swift'
            gameScene = GameScene(size: view.bounds.size)
            if let scene = gameScene {
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
                
                view.ignoresSiblingOrder = true
            }
        }
    }
    
    func requestHealthAuthorization() {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let dataTypes = Set([stepType])
        
        healthStore.requestAuthorization(toShare: nil, read: dataTypes) { (success, error) in
            if success {
                // Fetch step counts after authorization
                self.fetchStepCounts { stepsData in
                    // Pass the step counts to the GameScene
                    DispatchQueue.main.async {
                        self.gameScene?.updateStepCounts(stepsData)
                    }
                }
            } else {
                // Handle the error here
                print("HealthKit authorization failed: \(String(describing: error))")
                DispatchQueue.main.async {
                    self.gameScene?.updateStepCounts([:])
                }
            }
        }
    }
    
    func fetchStepCounts(completion: @escaping ([Date: Double]) -> Void) {
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calendar = Calendar.current
        let now = Date()
        
        // Get the start of the day two days ago
        guard let startDate = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: now)) else {
            DispatchQueue.main.async {
                completion([:])
            }
            return
        }
        
        // Set the predicate for the last two days
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: [])
        
        // Create the query
        let query = HKStatisticsCollectionQuery(
            quantityType: stepType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum,
            anchorDate: calendar.startOfDay(for: now),
            intervalComponents: DateComponents(day: 1)
        )
        
        query.initialResultsHandler = { query, results, error in
            var stepsData: [Date: Double] = [:]
            
            if let statsCollection = results {
                statsCollection.enumerateStatistics(from: startDate, to: now) { (statistics, stop) in
                    if let sum = statistics.sumQuantity() {
                        let steps = sum.doubleValue(for: HKUnit.count())
                        let date = statistics.startDate
                        stepsData[date] = steps
                    }
                }
            } else {
                print("Failed to fetch step counts: \(String(describing: error))")
            }
            
            // Ensure the completion handler is called on the main thread
            DispatchQueue.main.async {
                completion(stepsData)
            }
        }
        
        healthStore.execute(query)
    }
    
    // Hide the status bar (optional)
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
