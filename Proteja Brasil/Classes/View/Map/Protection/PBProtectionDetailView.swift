//
//  PBProtectionDetailView.swift
//  Proteja Brasil
//
//  Created by Daniel Borges on 17/10/15.
//  Copyright © 2015 IlhaSoft. All rights reserved.
//

import UIKit
import MapKit
import Foundation

protocol PBProtectionDetailViewDelegate {
    func showContactFromProtectionNetwork(protectionNetwork: PBProtectionNetworkModel)
}

enum PBOperatingDays:String {
    case Monday = "monday"
    case Tuesday = "tuesday"
    case Wednesday = "wednesday"
    case Thursday = "thursday"
    case Friday = "friday"
    case Saturday = "saturday"
    case Sunday = "sunday"
}

class PBProtectionDetailView: UIView {
    
    @IBOutlet weak var lbTitle: PBLabel!
    @IBOutlet weak var lbAdress: PBLabel!
    @IBOutlet weak var lbOperatingDays: PBLabel!
    @IBOutlet weak var btCall: UIButton!
    @IBOutlet weak var btRoute: UIButton!
    @IBOutlet weak var btContact: UIButton!
    
    var protectionNetwork:PBProtectionNetworkModel!
    var delegate: PBProtectionDetailViewDelegate?
    
    //MARK: Class Methods
    
    private func setupButtons() {
        let titleCallText = L10n.labelCall
        let titleRouteText = L10n.labelRoute
        let titleContactText = L10n.labelContact
        self.btCall.setTitle(titleCallText, for: .normal)
        self.btRoute.setTitle(titleRouteText, for: .normal)
        self.btContact.setTitle(titleContactText, for: .normal)
    }
    
    func setupViewWithData(protectionNetwork:PBProtectionNetworkModel) {
        self.protectionNetwork = protectionNetwork
        self.lbTitle.text = protectionNetwork.name
        
        var fullAddress = protectionNetwork.address
        
        if let neighborhood = protectionNetwork.neighborhood {
            fullAddress = "\(fullAddress), \(neighborhood)"
        }
        
        if let city = protectionNetwork.city {
            fullAddress = "\(fullAddress), \(city)"
        }

        if let state = protectionNetwork.state {
            if !state.title.isEmpty {
                fullAddress = "\(fullAddress) - \(state.title)"
            }
        }
        
        if let zipCode = protectionNetwork.zipcode {
            fullAddress = "\(fullAddress), \(zipCode)"
        }
        
        self.lbAdress.text = fullAddress        
        
        if let operatingDays = protectionNetwork.operatingdays {

            if !operatingDays.isEmpty {

                let filtered = operatingDays.filter {
                    return $0 == self.getDayOfWeek()
                }
                
                if filtered.isEmpty {
                    self.lbOperatingDays.text = L10n.labelClosedToday
                }else {
                    let openToday = L10n.labelOpenToday
                    if let schedule = self.protectionNetwork.schedule {
                        self.lbOperatingDays.text = "\(openToday): \(schedule)"
                    }else {
                        self.lbOperatingDays.text = openToday
                    }
                }
            }
        }
    }
    
    func getDayOfWeek() -> String {
        let myCalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let myComponents = myCalendar.dateComponents([.weekday], from: Date())
        let weekDay = myComponents.weekday! - 1
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "us")
        let weekDays = dateFormatter.weekdaySymbols!
        
        return weekDays[weekDay].lowercased()
    }
    
    class func loadView() -> PBProtectionDetailView {
        let view = Bundle.main.loadNibNamed("PBProtectionDetailView", owner: self, options: nil)![0] as! PBProtectionDetailView
        view.setupButtons()
        return view
    }
    
    func updateViewFromNetwork() {
        self.lbTitle.text = "Delegacia de polícia I - 120m"
        self.lbAdress.text = "Praça Raul Ramos, 11 - Poço, Maceió - AL, 57025-690"
        self.lbOperatingDays.text = "Aberto hoje: 08:00 - 18:00"
        self.layoutIfNeeded()
        self.layoutSubviews()
    }

    func getFormatedPhoneNumber(phoneNumber:String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: "(\\(\\w+\\))|\\s|-", options: NSRegularExpression.Options.caseInsensitive)
            
            let formatedPhoneNumber = regex.stringByReplacingMatches(
                in: phoneNumber,
                options: NSRegularExpression.MatchingOptions.anchored,
                range: NSRange(location: 0,length: phoneNumber.count),
                withTemplate: ""
            )
            return formatedPhoneNumber
        } catch let error as NSError {
            print(error)
            return ""
        }
    }

    //MARK: Button Events

    @IBAction func call() {
        if let phoneNumber = protectionNetwork.phone1 {
            if phoneNumber.contains("(") {
                makeCall(phoneNumber: self.getFormatedPhoneNumber(phoneNumber: phoneNumber))
            } else {
                makeCall(phoneNumber: phoneNumber)
            }
        } else if let phoneNumber = protectionNetwork.phone2 {
            if phoneNumber.contains("(") {
                makeCall(phoneNumber: self.getFormatedPhoneNumber(phoneNumber: phoneNumber))
            }else {
                makeCall(phoneNumber: phoneNumber)
            }
        }
    }
    
    @IBAction func traceRoute() {
             
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(self.protectionNetwork.position.lat, self.protectionNetwork.position.long)
        let placeMark: MKPlacemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        let destination: MKMapItem = MKMapItem(placemark: placeMark)

        if destination.responds(to: #selector(MKMapItem.openInMaps(launchOptions:))) {
            destination.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
        } else {
            let url = "http://maps.google.com/maps?saddr=Current+Location&daddr=\(self.protectionNetwork.position.lat),\(self.protectionNetwork.position.long)"
            UIApplication.shared.openURL(URL(string: url)!)
        }
    }
    
    @IBAction func showContact() {
        self.delegate?.showContactFromProtectionNetwork(protectionNetwork: self.protectionNetwork)
    }
    
}
