//
//  PBState.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 21/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import ObjectMapper

class PBState: Mappable {

    var initials:String!
    var title:String!

    required init?(map: Map) { }

    func mapping(map: Map) {
        self.initials  <- map["initials"]
        self.title     <- map["title"]
    }
}
