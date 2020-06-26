//
//  PBLocationManager.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 21/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import CoreLocation

class PBLocationManager: NSObject, CLLocationManagerDelegate {

    var locationManager:CLLocationManager!
    static let instance = PBLocationManager()
    
    class func sharedInstance() -> PBLocationManager{
        return instance
    }
    
    func getCLLocationCoordinate2D() -> CLLocationCoordinate2D? {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        if let location = self.locationManager.location {
            let coordinate: CLLocationCoordinate2D = location.coordinate
            self.locationManager.stopUpdatingLocation()
            return coordinate
        }else {
            return nil
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .NotDetermined:
            print("NotDetermined")
            break
        case .Restricted:
            print("Restricted")
            break
        case .Denied:
            print("Denied")
            break
        case .AuthorizedWhenInUse:
            NSNotificationCenter.defaultCenter().postNotificationName("userDidAuthorizedWhenInUse", object: nil)
            break
        default:
            break
        }
        
    }
    
}
