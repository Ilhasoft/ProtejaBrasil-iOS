//
//  PBCityModel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 16/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper

class PBCityModel: Mappable {
    
    var code: String!
    var name: String!
    var state: String!

    required init?(map: Map) { }

    func mapping(map: Map) {
        self.code  <- map["city_code"]
        self.name  <- map["city_name"]
        self.state <- map["state"]
    }
}
