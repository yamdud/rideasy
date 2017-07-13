//
//  CustomTextField.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 19/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    func editingBegan(){
        self.placeholder = ""
    }
    
    func editingEnd(text: String){
        self.text = ""
        self.placeholder = text
    }
}
