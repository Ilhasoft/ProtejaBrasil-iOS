//
//  PBMapPinAnnotationView.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 21/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MapKit
import SDWebImage

class PBProtectionNetworkPinAnnotationView: MKAnnotationView {
    
    var protectionNetwork: PBProtectionNetworkModel!
    var imgIcon: UIImageView!
    
    convenience init(annotation: PBProtectionNetworkAnnotation) {
        self.init()
        self.frame = CGRect(x: 0, y: 0, width: 24, height: 35)
        self.backgroundColor = UIColor.clear
        self.annotation = annotation
        self.protectionNetwork = annotation.protectionNetwork
        self.imgIcon = UIImageView(frame: CGRect(x: 5, y: 5, width: 14, height: 14))
        self.imgIcon.contentMode = .scaleAspectFit
                
        self.addSubview(self.imgIcon)
        
        if let icon = self.protectionNetwork.protectionNetworkType.icon {
            self.imgIcon.sd_setImage(with: URL(string: icon))
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.protectionNetwork.protectionNetworkType.rgbaColor().set()
        context.move(to: CGPoint(x: 13, y: 35))
        context.addLine(to: CGPoint(x: 0.5, y: 16))
        context.addLine(to: CGPoint(x: 23.5, y: 16))
        context.addLine(to: CGPoint(x: 12, y: 35))
        context.addEllipse(in: CGRect(x: 0, y: 0, width: 24, height: 24))
        context.fillPath()
    }

}
