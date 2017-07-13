//
//  registerUser.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 11/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation
import FirebaseAuth

class registerUser: UIViewController {
    
    @IBOutlet weak var emailErrorView: errorIndicatingImageview!
    @IBOutlet weak var email: CustomTextField!
    @IBOutlet weak var password: CustomTextField!
    @IBOutlet weak var passErrorView: errorIndicatingImageview!
    @IBOutlet weak var RepeatPass: CustomTextField!
    @IBOutlet weak var repeatPassErrorView: errorIndicatingImageview!
    let validation = Validation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    @IBAction func ValidateEmail(_ sender: Any) {
        if !validation.isValidEmail(testStr: email.text!) {
            
            emailErrorView.ValidationErrorView()
        }
        else{
            emailErrorView.ValidationSuccessView()
        }
    }
    @IBAction func CheckPassForMatch(_ sender: Any) {
        if !validation.isPassSame(pass1: password.text!, pass2: RepeatPass.text!){
            passErrorView.ValidationErrorView()
            repeatPassErrorView.ValidationErrorView()
        }
        else{
            passErrorView.ValidationSuccessView()
            repeatPassErrorView.ValidationSuccessView()
        }
        
    }
    @IBAction func isValidPassword(_ sender: Any) {
        if password.text == nil {
            passErrorView.ValidationErrorView()
        }
    }
    @IBAction func Registr(_ sender: Any) {
        if validation.isValidEmail(testStr: email.text!) && validation.isPassSame(pass1: password.text!, pass2: RepeatPass.text!) {
            AuthProvider.Instance.createUser(email: email.text!, pass: password.text!,type: 1, loginHandler: { (msg, erroType, userType) in
                if msg != nil {
                    if erroType == "email"{
                        self.email.editingEnd(text: msg!)
                        self.emailErrorView.ValidationErrorView()
                    }
                    else {
                        self.password.editingEnd(text: msg!)
                        self.RepeatPass.editingEnd(text: "Repeat Password")
                        self.passErrorView.ValidationErrorView()
                        
                    }
                }
                else{
                    self.performSegue(withIdentifier: "userRegistered", sender: self)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.SwitchrootViewController(identifier: "SignInPassengers")
                }
            })
        }
    }
    
}
