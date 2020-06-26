//
//  PBFeedbackAPI.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 05/01/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper

class PBFeedbackAPI: PBAPI {
    
    func insert(type: PBFeedbackType, name: String, email: String, message: String,
                     completion: @escaping (_ feedback: PBFeedbackModel?, _ error: Error?) -> Void) {
        let url = self.apiBase + "/feedback/"
        let params = [
            "type": type.value,
            "name": name,
            "email": email,
            "message": message,
            "platform": "ios",
            "version": Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        ]
        Alamofire
            .request(url, method: HTTPMethod.post, parameters: params, encoding: JSONEncoding.default, headers: self.header)
            .validate(statusCode: 200...200)
            .responseObject(completionHandler: { (response: DataResponse<PBFeedbackModel>) in
                completion(response.value, response.error)
            })
    }
    
}
