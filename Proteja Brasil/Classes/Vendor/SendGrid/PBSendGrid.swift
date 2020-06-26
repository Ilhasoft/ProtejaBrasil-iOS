//
//  PBSendGrid.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 07/03/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class PBSendGrid {
    
    // TEST
    private static let username = "danielborges93"
    private static let apiKey = "abcd1234"
    // PROD
    //private static let username = "danielborges93"
    //private static let apiKey = "abcd1234"
    
    static func send(to: String, from: String, subject: String, html: String, completion: @escaping (Bool) -> Void) {
        let url = "https://api.sendgrid.com/api/mail.send.json"
        let params = [
            "api_user": self.username,
            "api_key": self.apiKey,
            "to": to,
            "from": from,
            "subject": subject,
            "html": html
        ]
        Alamofire.request(url, method: .post, parameters: params).responseObject { (response: DataResponse<PBSendGridResponse>) in
            var success = false
            if let value = response.value {
                success = (value.message == "success")
            } else if let error = response.error {
                print("Error while send a email: \(error)")
            }
            completion(success)
        }
    }

}

private class PBSendGridResponse: Mappable {
    
    var message: String!

    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.message <- map["message"]
    }
}
