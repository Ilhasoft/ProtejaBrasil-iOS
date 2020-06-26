//
//  PBThemeModel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper

class PBThemeModel: Mappable {
    
    var id: Int!
    var title: String!
    var icon: String!
    var color: String!
    var desc: String!
    var sondhaId: Int!

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id       <- map["id"]
        self.title    <- map["title"]
        self.desc     <- map["description"]
        self.icon     <- map["icon"]
        self.color    <- map["color"]
        self.sondhaId <- map["sondha_id"]
    }
    
}
