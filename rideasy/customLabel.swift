//
//  customLabel.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 19/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class customLabel: UILabel {
    
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        hideView()
    }
    func hideView(){
        self.alpha = 0.0
    }
    func showView(){
        self.alpha = 0.3
    }
}
