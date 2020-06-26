//
//  PBViolationTypeAPI.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class PBViolationTypeNetworkAPI: PBAPI {
    
    func getViolationType(completion: @escaping ([PBViolationTypeModel]?, Error?) -> Void) {
        let resource = "/violation_type/"
        let url = "\(self.apiBase)\(resource)"
        
        Alamofire
            .request(url, method: .get, parameters: self.lang, headers: self.header)
            .validate(statusCode: 200...200)
            .responseArray(completionHandler: { (response: DataResponse<[PBViolationTypeModel]>) in
                if let error = response.error {
                    if let JSONString = self.getCache(url: url) {
                        let value = Mapper<PBViolationTypeModel>().mapArray(JSONString: JSONString)
                        completion(value, nil)
                    } else {
                        completion(nil, error)
                    }
                } else if let value = response.value {
                    completion(value, nil)
                }
            })
    }
    
    func getViolationTypeByCategory(category:String, completion: @escaping ([PBViolationTypeModel]?, Error?) -> Void) {
        let resource = "/violation_type/category/\(category)"
        let url = "\(self.apiBase)\(resource)"

        Alamofire
            .request(url, method: .get, parameters: self.lang, headers: self.header)
            .validate(statusCode: 200...200)
            .responseArray(completionHandler: { (response: DataResponse<[PBViolationTypeModel]>) in
                if let error = response.error {
                    if let JSONString = self.getCache(url: url) {
                        let value = Mapper<PBViolationTypeModel>().mapArray(JSONString: JSONString)
                        completion(value, nil)
                    } else {
                        completion(nil, error)
                    }
                } else if let value = response.value {
                    completion(value, nil)
                }
            })
    }

    func getViolationTypeByTheme(theme: PBThemeModel, completion: @escaping ([PBViolationTypeModel]?, Error?) -> Void) {
        let resource = "/violation_type/theme/\(String(describing: theme.id))/"
        let url = self.apiBase + resource
        
        Alamofire
            .request(url, method: .get, parameters: self.lang, encoding: JSONEncoding.default, headers: self.header)
            .validate(statusCode: 200...200)
            .responseArray { (response: DataResponse<[PBViolationTypeModel]>) in
                if let error = response.error {
                    if let JSONString = self.getCache(url: url) {
                        let value = Mapper<PBViolationTypeModel>().mapArray(JSONString: JSONString)
                        completion(value, nil)
                    } else {
                        completion(nil, error)
                    }
                } else if let value = response.value {
                    completion(value, nil)
                }
            }
    }
}
