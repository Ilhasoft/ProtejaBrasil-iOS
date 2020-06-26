//
//  PBThemeAPI.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

class PBThemeAPI: PBAPI {

    func getThemes(completion: @escaping ([PBThemeModel]?, Error?) -> Void) {
        let resource = "/themes/"
        let url = "\(self.apiBase)\(resource)"
        
        Alamofire
            .request(url, method: .get, parameters: self.lang, headers: self.header)
            .validate(statusCode: 200...200)
            .responseArray { (response: DataResponse<[PBThemeModel]>) in
                var error = response.error
                var value = response.value
                self.cacheData(data: response.data, fromUrl: url, error: error)
                if let JSONString = self.getCache(url: url), error != nil {
                    value = Mapper<PBThemeModel>().mapArray(JSONString: JSONString)
                    error = nil
                }
                completion(value, error)
            }
    }
    
}
