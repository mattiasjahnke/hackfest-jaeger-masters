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
        guard let quantityType = HKObjectType.quantityType(forIdentifier: .heartRate) else { fatalError() }
        
        let healthKitTypes: Set<HKSampleType> = [ quantityType ]
        
        healthKitStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (granted, error) in
            
        }
    }
    
    func startMonitoring() {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else { fatalError() }
        
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

