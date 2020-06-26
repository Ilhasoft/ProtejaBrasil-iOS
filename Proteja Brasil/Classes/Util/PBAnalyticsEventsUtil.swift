//
//  PBAnalyticsEventsUtil.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 08/03/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import Foundation
import Google

enum PBAnalyticsEventAction: String {
    case start = "Start"
    case finish = "Finish"
    case giveUp = "Give up"
    
    func report() -> String {
        return self.rawValue + " report"
    }
}

func sendAnalyticAction(action: PBAnalyticsEventAction, ofType type: PBComplaintType) {
    let tracker = GAI.sharedInstance().defaultTracker
    let builder = GAIDictionaryBuilder.createEvent(withCategory: type.category(), action: action.report(),
        label: "\(action.rawValue) \(type.trackName().lowercased()) report", value: 1)
    if let tracker = tracker, let builder = builder {
        tracker.send(builder.build() as [NSObject: AnyObject])
    }
}
