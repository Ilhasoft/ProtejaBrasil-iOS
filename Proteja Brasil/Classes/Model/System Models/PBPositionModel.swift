//
//  PBPositionModel.swift
//  Proteja Brasil
//
//  Created by Daniel Amaral on 21/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import ObjectMapper

class PBPositionModel: Mappable {

    var lat:Double!
    var long:Double!

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.lat  <- map["lat"]
        self.long <- map["long"]
    }
    
}
