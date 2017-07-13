//
//  CustomCalloutView.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 30/05/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class CustomCalloutView: UIView {

    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var time: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    @IBAction func acceptRide(_ sender: Any) {
    }

    @IBAction func cancelRide(_ sender: Any) {
    }
}
