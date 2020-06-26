//
//  PBViolationTypeModel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper

class PBViolationTypeModel: Mappable {

    var id: Int!
    var name: String!
    var desc: String!
    var theme: PBThemeModel!
    var protectionNetworkTypes: [PBViolationTypeModel]!
    var color: String!
    var icon: String!
    var action: String!
    var categories: [PBCategoryModel]!

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id                      <- map["id"]
        self.name                    <- map["name"]
        self.desc                    <- map["description"]
        self.theme                   <- map["theme"]
        self.protectionNetworkTypes  <- map["types"]
        self.color                   <- map["color"]
        self.icon                    <- map["icon"]
        self.action                  <- map["action"]
        self.categories              <- map["categories"]
    }
}
