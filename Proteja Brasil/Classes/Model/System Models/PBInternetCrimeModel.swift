//
//  PBInternetCrimeModel.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper

class PBInternetCrimeModel: Mappable {

    var id: Int!
    var urlWebsite: String!
    var desc: String!
    var status: String!
    var violationType: PBProtectionNetworkTypeModel!

    required init?(map: Map) { }

    func mapping(map: Map) {
        self.id            <- map["id"]
        self.urlWebsite    <- map["url_website"]
        self.desc          <- map["description"]
        self.status        <- map["status"]
        self.violationType <- map["violationType"]
    }
}
