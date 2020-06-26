//
//  PBComplaintStep.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 17/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import OAStackView

class PBComplaintStep {
    
    var title: String?
    private(set) var elements: [PBComplaintElementProtocol]!
    private(set) var stackView: OAStackView!
    private(set) var hasObligatoryFields: Bool
    var infoAction: Selector?
    
    init(stackView: OAStackView, elements: [PBComplaintElementProtocol], hasObligatoryFields: Bool = false,
         title: String? = nil) {
        self.stackView = stackView
        self.elements = elements
        self.hasObligatoryFields = hasObligatoryFields
        self.title = title
    }
    
    func getDataOfAllElements() -> [String: Any] {
        var result = [String: Any]()
        for element in self.elements {
            if let apiKey = element.apiKey, let data = element.getData() {
                result[apiKey] = data.1
            }
        }
        return result
    }
    
}
