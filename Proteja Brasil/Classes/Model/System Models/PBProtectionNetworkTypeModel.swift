//
//  PBViolationTypeModel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper

class PBProtectionNetworkTypeModel: Mappable {
    
    var id: Int!
    var icon: String?
    var color: String?
    var name: String?

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id     <- map["id"]
        self.icon   <- map["icon"]
        self.color  <- map["color"]
        self.name   <- map["name"]
    }
    
    func rgbaColor() -> UIColor {
        if let color = self.color {
            if !color.isEmpty{
                return UIColor(rgba: color)
            }else {
                return UIColor(rgba: "#68ae30")
            }
        }
        return UIColor(rgba: "#68ae30")
    }
    
}
