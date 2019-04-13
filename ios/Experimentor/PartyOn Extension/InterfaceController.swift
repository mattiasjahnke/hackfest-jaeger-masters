//
//  InterfaceController.swift
//  PartyOn Extension
//
//  Created by Nataliya Patsovska on 2019-04-13.
//  Copyright © 2019 Mattias Jähnke. All rights reserved.
//

import WatchKit
import Foundation
import HealthKit

class InterfaceController: WKInterfaceController, HKWorkoutSessionDelegate {

    @IBOutlet weak var textLabel: WKInterfaceLabel!

    let healthStore = HKHealthStore()
    var session: HKWorkoutSession!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .indoor

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)

            session.delegate = self
            session.prepare()
        }
        catch let error as NSError {
            // Perform proper error handling here...
            fatalError("*** Unable to create the workout session: \(error.localizedDescription) ***")
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        session.startActivity(with: Date())
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }


    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("workoutSessionDidChangeTo \(toState)")
        textLabel.setText("Connected")
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("workoutSessionDidFailWithError \(error)")
        textLabel.setText("Error")
    }

}
