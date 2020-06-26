//
//  PBSearchLocationTableViewCell.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 25/02/16.
//  Copyright © 2016 IlhaSoft. All rights reserved.
//

import UIKit
import CoreLocation

class PBSearchLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: "PBSearchLocationTableViewCell", bundle: nil)
    }
    
    func updateCellFromPlacemark(placemark: CLPlacemark) {
        let preferredWidth = self.frame.size.width - 70
        self.lbTitle.preferredMaxLayoutWidth = preferredWidth
        self.lbSubtitle.preferredMaxLayoutWidth = preferredWidth
        let title = NSMutableString()
        if let street = placemark.thoroughfare {
            title.append(street)
        }
        if let number = placemark.subThoroughfare {
            title.append(", " + number)
        }
        self.lbTitle.text = title as String
        let subtitle = NSMutableString()
        if let city = placemark.locality, let state = placemark.administrativeArea {
            subtitle.append(city + "-" + state)
        }
        if let userLocation = PBLocationManager.sharedInstance().getCLLocationCoordinate2D(),
            let placemarkCoordinate = placemark.location?.coordinate,
            let distance = PBLocationManager.sharedInstance().distanceBetween(location1: userLocation, and: placemarkCoordinate) {
                var factor = 1000.0
                var measureUnit = "km"
                if distance < 1000 {
                    measureUnit = "m"
                    factor = 1.0
                }
            subtitle.append(String(format: " %.lf%@", distance/factor, measureUnit))
        }
        self.lbSubtitle.text = subtitle as String
    }
    
}
