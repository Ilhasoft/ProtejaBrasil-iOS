//
//  PBNetworkOperations.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 20/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import Foundation
import ObjectMapper
import Cache

class PBAPI {
    
    var token: String? {
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                return dict["PBToken"] as? String
            }
        }
        return nil;
    }

    var apiBase: String {
        
        var key = ""
        switch PBNetworkConfig.type {
        case .test:
            key = "APIDevUrl"
        case .production:
            key = "APIUrl"
        }
        
        if let path = Bundle.main.path(forResource: "APIKeys", ofType: "plist") {
            let dictRoot = NSDictionary(contentsOfFile: path)
            if let dict = dictRoot {
                return dict[key] as? String ?? ""
            }
        }
        return ""
    }

    var header: [String: String] {
        return ["Authorization": self.token ?? ""]
    }

    var lang: [String: Any] {
        guard let lang = Locale.current.languageCode else {
            return [:]
        }
        return ["lang": lang]
    }

    static let diskConfig = DiskConfig(name: "urls")
    static let memoryConfig = MemoryConfig(expiry: .never, countLimit: 10, totalCostLimit: 10)
    static let storage = try! Storage(
        diskConfig: PBAPI.diskConfig,
        memoryConfig: PBAPI.memoryConfig,
        transformer: TransformerFactory.forCodable(ofType: String.self))

    static let protectionNetwok = PBProtectionNetworkAPI()
    static let report = PBReportAPI()
    static let violationType = PBViolationTypeNetworkAPI()
    static let theme = PBThemeAPI()
    static let feedback = PBFeedbackAPI()

    internal func cacheData(data: Data?, fromUrl url: String, error: Error?) {
        if let data = data, let JSONString = String(data: data, encoding: String.Encoding.utf8), error == nil {
            try? PBAPI.storage.setObject(JSONString, forKey: url)
        }
    }

    internal func getCache(url: String) -> String? {
        return try? PBAPI.storage.object(forKey: url)
    }
}
