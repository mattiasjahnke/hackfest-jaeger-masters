//
//  ViewController.swift
//  Experimentor
//
//  Created by Mattias Jähnke on 2019-04-11.
//  Copyright © 2019 Mattias Jähnke. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager: NSObject {
    static let healthKitStore = HKHealthStore()
    
    static func authorizeHealthKit() {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("Health data not available")
        }

        guard
            let quantityType = HKSampleType.quantityType(forIdentifier: .heartRate),
            let energyBurned = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned)
        else { fatalError("can't create quantity type") }

        
        let healthKitTypes: Set<HKSampleType> = [ quantityType, energyBurned ]
        
        healthKitStore.requestAuthorization(toShare: [], read: healthKitTypes) { (granted, error) in
            print("Granted? \n\(granted ? "hell yeah" : "nope")")
        }
    }
    
    func startMonitoring() {
        guard let sampleType = HKSampleType.quantityType(forIdentifier: .heartRate) else { fatalError() }
        
        let query = HKObserverQuery(sampleType: sampleType, predicate: nil) { (query, completion, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

class ViewController: UIViewController {

    var manager = HealthKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func authorizeTapped(_ sender: Any) {
        HealthKitManager.authorizeHealthKit()
    }
    
}

