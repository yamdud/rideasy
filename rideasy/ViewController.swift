//
//  ViewController.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 23/01/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit
import FirebaseAuth
class ViewController: UIViewController {
    
    @IBOutlet weak var EmailLabel: customLabel!
    
    @IBOutlet weak var EmailTextbox: CustomTextField!
    @IBOutlet weak var PasswordLabel: customLabel!
    @IBOutlet weak var PasswordTextField: CustomTextField!
    @IBOutlet weak var forgotPass: UIButton!
    let validation = Validation()
    
    @IBOutlet weak var ErrorEmailView: errorIndicatingImageview!
    @IBOutlet weak var passErrorView: errorIndicatingImageview!
    let passPlaceholder = "Password"
    let emailPlaceholder = "E-mail"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
  

    @IBAction func EmaiTextFieldStartEdit(_ sender: Any) {
        
        EmailTextbox.editingBegan()
        EmailLabel.showView()
    }
    
    @IBAction func PasswordTextFieldStartEdit(_ sender: Any) {
        PasswordTextField.editingBegan()
        PasswordLabel.showView()
    }
    
    @IBAction func EmailTextFieldEndEdit(_ sender: Any) {
        
        print("We here")
        if EmailTextbox.text == ""{
           
            ErrorEmailView.ValidationErrorView()
            EmailTextbox.editingEnd(text: "Email ID Required")
            EmailLabel.hideView()
        }
        else if !(validation.isValidEmail(testStr: EmailTextbox.text!)) {
            print("Invalid Email Address ")
            ErrorEmailView.ValidationErrorView()
            EmailTextbox.editingEnd(text: "Invalid Email ID")
            EmailLabel.hideView()
            
        }
        else {
        print("Else Phase")
        ErrorEmailView.ValidationSuccessView()
        }
        
    }
    
    @IBAction func PasswordTextFieldEndEdit(_ sender: Any) {
        if PasswordTextField.text == ""{
            passErrorView.ValidationErrorView()
            PasswordTextField.editingEnd(text: passPlaceholder)
            PasswordLabel.hideView()
        }
        else{
            passErrorView.ValidationSuccessView()
        }
        
    }
    
    @IBAction func SignIn(_ sender: Any) {
        var identifier = ""
         var type = Int()
        if validation.isValidEmail(testStr: EmailTextbox.text!) && PasswordTextField.text != nil{
            AuthProvider.Instance.login(email: EmailTextbox.text!, password: PasswordTextField.text!, loginHandler: { (msg, errorType, userType) in
    
                 if msg != nil {
                    print(msg)
                    if errorType == "pass" {
                        self.PasswordTextField.editingEnd(text: msg!)
                        self.passErrorView.ValidationErrorView()
                    }
                    else{
                        self.EmailTextbox.editingEnd(text: msg!)
                        self.ErrorEmailView.ValidationErrorView()
                    }
                }
                else  {
                        if (userType == 1){
                        identifier = "SignInPassengers"
                    }
                    else {
                        identifier = "SignInDrivers"
                    }
                    print(identifier)
                    self.performSegue(withIdentifier: identifier, sender: self)
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    //appDelegate.SwitchrootViewController(identifier: identifier)
                }
            })
           
            

        }
    }
    
       override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        EmailTextbox.resignFirstResponder()
        PasswordTextField.resignFirstResponder()
    }
    @IBAction func ForgotPassword(_ sender: Any) {
        //performSegue(withIdentifier: "ResetPassword", sender: self.forgotPass)
    }
    @IBAction func SignUp(_ sender: Any) {
    }
    
}
