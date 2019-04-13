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

    var hearthRateType: HKSampleType {
        guard let heartRate = HKSampleType.quantityType(forIdentifier: .heartRate) else {
                fatalError("can't create heartRate type")
        }
        return heartRate
    }

    var energyBurnedType: HKSampleType {
        guard let energyBurned = HKSampleType.quantityType(forIdentifier: .activeEnergyBurned) else {
            fatalError("can't create energyBurnedType type")
        }
        return energyBurned
    }

    var healthKitTypes: Set<HKSampleType> {
        return [hearthRateType, energyBurnedType]
    }

    let healthKitStore = HKHealthStore()
    
    func authorizeHealthKit() {
        guard HKHealthStore.isHealthDataAvailable() else {
            fatalError("Health data not available")
        }
        
        healthKitStore.requestAuthorization(toShare: [], read: healthKitTypes) { (granted, error) in
            print("Granted? \n\(granted ? "hell yeah" : "nope")")
            if granted && error == nil {
                self.startMonitoringHearthRate()
            }
        }
    }
    
    func startMonitoringHearthRate() {
        let hearthRateObserverQuery = HKObserverQuery(sampleType: hearthRateType, predicate: nil) { (_, _, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            self.fetchLatestHeartRateSample { (sample) in
                guard let sample = sample else {
                    return
                }

                DispatchQueue.main.async {
                    let heartRate = sample.quantity
                    print("Heart Rate Sample: \(heartRate)")

                    // do something with it
                }
            }
        }

        healthKitStore.execute(hearthRateObserverQuery)
    }

    func fetchLatestHeartRateSample(completionHandler: @escaping (_ sample: HKQuantitySample?) -> Void) {
        guard let sampleType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate) else {
            completionHandler(nil)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: Date.distantPast, end: Date(), options: .strictEndDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: sampleType,
                                  predicate: predicate,
                                  limit: Int(HKObjectQueryNoLimit),
                                  sortDescriptors: [sortDescriptor]) { (_, results, error) in
                                    if let error = error {
                                        print("Error: \(error.localizedDescription)")
                                        return
                                    }

                                    print("Got \(results?.count) results")
                                    completionHandler(results?.first as? HKQuantitySample)
        }

        healthKitStore.execute(query)
    }
}

class ViewController: UIViewController {

    var manager = HealthKitManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func authorizeTapped(_ sender: Any) {
        manager.authorizeHealthKit()
    }
    
}

