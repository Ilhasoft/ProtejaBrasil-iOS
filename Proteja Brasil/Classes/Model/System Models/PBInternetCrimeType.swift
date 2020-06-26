//
//  PBInternetCrimeType.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 25/04/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit
import ObjectMapper

class PBInternetCrimeType: Mappable {

    var id: Int!
    var title: String!
    var description: String!

    required init?(map: Map) { }

    func mapping(map: Map) {
        self.id          <- map["id"]
        self.title       <- map["title"]
        self.description <- map["description"]
    }
}
