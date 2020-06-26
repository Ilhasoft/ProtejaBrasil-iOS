//
//  PBProtectionNetworkModel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper
import MapKit
import Contacts
import CoreLocation

class PBProtectionNetworkModel: Mappable {
    var id: Int!
    var name: String!
    var protectionNetworkType: PBProtectionNetworkTypeModel!
    var position: PBPositionModel!
    var zipcode: String!
    var neighborhood: String!
    var address: String!
    var city: String!
    var state: PBState!
    var contact: String!
    var phone1: String!
    var phone2: String!
    var email: String!
    var schedule: String!
    var themes: [PBThemeModel]!
    var operatingdays: [String]!

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id            <- map["id"]
        self.name          <- map["name"]
        self.protectionNetworkType <- map["type"]
        self.position      <- map["position"]
        self.zipcode       <- map["zipcode"]
        self.neighborhood  <- map["neighborhood"]
        self.address       <- map["address"]
        self.city          <- map["city"]
        self.state         <- map["state"]
        self.contact       <- map["contact"]
        self.phone1        <- map["phone1"]
        self.phone2        <- map["phone2"]
        self.email         <- map["email"]
        self.schedule      <- map["schedule"]
        self.themes        <- map["themes"]
        self.operatingdays <- map["operatingdays"]
    }
    
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: position.lat, longitude: position.long)
    }

    var contactRecord: CNMutableContact {
        let record = CNMutableContact()
        record.givenName = self.name

        let addressProperty = CNMutablePostalAddress()
        addressProperty.street = self.address
        addressProperty.postalCode = self.zipcode
        addressProperty.city = self.city
        addressProperty.state = self.state.title
        addressProperty.country = "Brasil"

        let addressLabel = L10n.hintAddress
        record.postalAddresses.append(CNLabeledValue(label: addressLabel, value: addressProperty))

        let phoneLabel = L10n.textTelephone
        let phone1Property = CNPhoneNumber(stringValue: self.phone1)
        let phone2Property = CNPhoneNumber(stringValue: self.phone2)

        record.phoneNumbers.append(CNLabeledValue(label: "\(phoneLabel) 1", value: phone1Property))
        record.phoneNumbers.append(CNLabeledValue(label: "\(phoneLabel) 2", value: phone2Property))

        return record
    }

    func distanceBetweenUserLocation() -> CLLocationDistance? {
        if let userCoordinates = PBLocationManager.instance.getCLLocationCoordinate2D() {
            let userLocation = CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
            let selfLocation = CLLocation(latitude: self.position.lat, longitude: self.position.long)
            return userLocation.distance(from: selfLocation)
        }
        return nil
    }
    
    func distanceBetweenProtectionNetwork(protectionNetwork: PBProtectionNetworkModel) -> CLLocationDistance {
        let location1 = CLLocation(latitude: self.position.lat, longitude: self.position.long)
        let location2 = CLLocation(latitude: protectionNetwork.position.lat, longitude: protectionNetwork.position.long)
        return location1.distance(from: location2)
    }
    
}
