//
//  PBLocationManager.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 21/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import CoreLocation

protocol PBLocationManagerDelegate {
    func administrativeAreaRetrieved(administrativeArea: String?)
}

class PBLocationManager: NSObject {

    var locationManager:CLLocationManager
    static let instance = PBLocationManager()
    var delegate: PBLocationManagerDelegate?
    var currentPlacemark: CLPlacemark?
    
    class func sharedInstance() -> PBLocationManager{
        return instance
    }
    
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
    }
    
    func requestUserLocation() {
        self.locationManager.requestWhenInUseAuthorization()
    }
    
    func getCLLocationCoordinate2D() -> CLLocationCoordinate2D? {
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
        case .notDetermined:
            print("NotDetermined")
        case .restricted:
            print("Restricted")
        case .denied:
            print("Denied")
        case .authorizedWhenInUse:
            NotificationCenter.default.post(name: NSNotification.Name("userDidAuthorizedWhenInUse"), object: nil)
            self.locationManager.startUpdatingLocation()
        default:
            break
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location {
            CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Reverse geocoder failed with error: " + error.localizedDescription)
                    return
                }
                
                if let placemarks = placemarks {
                    if placemarks.count > 0 {
                        let pm = placemarks[0] as CLPlacemark
                        self.displayLocationInfo(placemark: pm)
                        self.currentPlacemark = pm
                    } else {
                        print("Problem with the data received from geocoder")
                    }
                }
            }
        }
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let placemark = placemark {
            //stop updating location to save battery life
            locationManager.stopUpdatingLocation()
            self.delegate?.administrativeAreaRetrieved(administrativeArea: placemark.administrativeArea)
        }
    }
    
    func placemarksFromString(string: String, filter: ((CLPlacemark) -> Bool)? = nil, completion: @escaping ([CLPlacemark]?) -> Void) {
        CLGeocoder().geocodeAddressString(string) { placemarks, error in
            if var placemarks = placemarks {
                if let filter = filter {
                    placemarks = placemarks.filter(filter)
                }
                completion(placemarks)
                return
            }
            completion(nil)
        }
    }
    
    func placemarkFromString(string: String, completion: @escaping (CLPlacemark?) -> Void) {
        placemarksFromString(string: string) { placemarks in
            if let placemarks = placemarks {
                if placemarks.count == 0 {
                    completion(nil)
                    return
                }
                completion(placemarks[0])
                return
            }
            completion(nil)
        }
    }
    
    func distanceBetween(location1: CLLocationCoordinate2D, and location2: CLLocationCoordinate2D) -> CLLocationDistance? {
        let loc1 = CLLocation(latitude: location1.latitude, longitude: location1.longitude)
        let loc2 = CLLocation(latitude: location2.latitude, longitude: location2.longitude)
        return loc1.distance(from: loc2)
    }
    
}

// MARK: - CLLocationManagerDelegate

extension PBLocationManager: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(newLocation) { placemarks, error in
            if error != nil {
                return
            }
            self.currentPlacemark = placemarks?.last
        }
    }
    
}
