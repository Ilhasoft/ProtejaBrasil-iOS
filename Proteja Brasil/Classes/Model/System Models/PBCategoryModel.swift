//
//  PBCategoryModel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 27/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper

class PBCategoryModel: Mappable {

    var category: String!

    required init?(map: Map) { }

    func mapping(map: Map) {
        self.category <- map["category"]
    }
}
