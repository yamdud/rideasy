//
//  Validation.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 13/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation
class Validation {
    let isValid = false
    func isValidEmail(testStr: String) -> Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    func isPassSame(pass1: String, pass2: String)-> Bool {
        if pass1 == pass2 {
            return true
        }
        else{
            return false
        }
        
    }
    
}
