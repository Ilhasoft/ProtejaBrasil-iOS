//
//  PBProtectionNetworkAPI.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import CoreLocation
import NSString_UrlEncode
import ObjectMapper

class PBProtectionNetworkAPI: PBAPI {
    
    func getProtectionNetworks(state: String? = nil, themeId: Int? = nil, name: String? = nil, userCoordinate: CLLocationCoordinate2D? = nil, completion: @escaping ([PBProtectionNetworkModel]?, Error?) -> Void) {
        let resource = "/protection_network"
        var url = "\(self.apiBase)\(resource)/"
        
        if let state = state {
            url = "\(url)state/\(state)/"
        }
        if let themeId = themeId {
            url = "\(url)theme/\(themeId)/"
        }
        if var name = name {
            name = (name as NSString).urlEncode()
            url = "\(url)name/\(name)/"
        }
        
        if let userCoordinate = userCoordinate {
            url = "\(url)position/\(userCoordinate.latitude),\(userCoordinate.longitude)/"
        }
        
        Alamofire
            .request(url, method: .get, parameters: self.lang, headers: self.header)
            .validate(statusCode: 200...200)
            .responseArray(completionHandler: { (response: DataResponse<[PBProtectionNetworkModel]>) in
                var error = response.error
                var value = response.value
                self.cacheData(data: response.data, fromUrl: url, error: error)
                if let JSONString = self.getCache(url: url), error != nil {
                    value = Mapper<PBProtectionNetworkModel>().mapArray(JSONString: JSONString)
                    error = nil
                }
                completion(value, error)
            })
    }
    
    func getNearestProtectionNetwork(lat:Double,long:Double,protectionNetworkTypeId:Int, completion: @escaping (PBProtectionNetworkModel?, Error?) -> Void) {
        
        let resource = "/protection_network/type/\(protectionNetworkTypeId)/position/\(lat),\(long)"
        let url = "\(self.apiBase)\(resource)/"
        
        Alamofire
            .request(url, method: .get, parameters: self.lang, headers: self.header)
            .validate(statusCode: 200...200)
            .responseObject(completionHandler: { (response: DataResponse<PBProtectionNetworkModel>) in
                var error = response.error
                var value = response.value
                self.cacheData(data: response.data, fromUrl: url, error: error)
                if let JSONString = self.getCache(url: url), error != nil {
                    value = Mapper<PBProtectionNetworkModel>().map(JSONString: JSONString)
                    error = nil
                }
                completion(value, error)
            })
        
    }
    
    func getTypes(completion: @escaping ([PBProtectionNetworkTypeModel]?, Error?) -> Void) {
        let resource = "/protection_network/types/"
        let url = "\(self.apiBase)\(resource)"
        
        Alamofire
            .request(url, method: .get, parameters: self.lang, headers: self.header)
            .validate(statusCode: 200...200)
            .responseArray(completionHandler: { (response: DataResponse<[PBProtectionNetworkTypeModel]>) in
                var error = response.error
                var value = response.value
                self.cacheData(data: response.data, fromUrl: url, error: error)
                if let JSONString = self.getCache(url: url), error != nil {
                    value = Mapper<PBProtectionNetworkTypeModel>().mapArray(JSONString: JSONString)
                    error = nil
                }
                completion(value, error)
            })
    }
    
}
