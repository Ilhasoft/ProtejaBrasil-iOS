//
//  PBFeedbackModel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 05/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper

class PBFeedbackModel: Mappable {
    
    var id: Int!
    var type: String!
    var name: String!
    var email: String!
    var message: String!

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id      <- map["id"]
        self.type    <- map["type"]
        self.name    <- map["name"]
        self.email   <- map["email"]
        self.message <- map["message"]
    }
    
}
