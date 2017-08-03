//
//  infoViewForDrivers.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 01/08/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class infoViewForDrivers: UIView {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var destinationIndicatingLabel: UILabel!
    
    @IBOutlet weak var startRideBtn: UIButton!
    @IBOutlet weak var cancelRideBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialsetup()
    }
    
    func initialsetup(){
        self.isHidden = true
        self.isUserInteractionEnabled = false
    }
    func rideActive(){
        
        self.isHidden = false
        self.isUserInteractionEnabled = true
    }
    
    func setupAddressLabels(address: String, option: String){
        switch  option{
        case "pickup":
            print("pickup")
            addressLabel.text = address
            destinationIndicatingLabel.text = "Pickup Location"
            
        case "destination":
            addressLabel.text = address
            destinationIndicatingLabel.text = "Destination"
            print("destination")
            
        default:
            break
        }
        
    }
}
