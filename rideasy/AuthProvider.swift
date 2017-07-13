//
//  AuthProvider.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 19/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

typealias LoginHandler = (_ msg: String?, _ errorType: String?, _ userType : Int?) -> Void

struct loginErrorCode {
    static let INVALID_EMAIL = "Email ID Already in Use"
    static let WRONG_PASSWORD = "Check Password"
    static let USER_NOT_FOUND = "Email address is not Registered"
    static let PASSWORD_WEAK = "Your Password is too weak"
    static let PROBLEM_CONNECTING = "Problem Connecting to Server"
}
class AuthProvider {
    private static let _instance = AuthProvider()
    
    static var Instance: AuthProvider{
        return _instance
    }
    
    func login(email: String, password: String, loginHandler: LoginHandler?){
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                self.errorHandlers(error: error! as NSError, loginHandler: loginHandler)
            }
            else
            {
                FIRDatabase.database().reference().child("user").child((FIRAuth.auth()?.currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
                    //getting user type
                    let value = snapshot.value as? NSDictionary
                    let type = value?["type"] as! Int
                    print("type of user: \(type)")
                loginHandler?(nil, nil,type)
            })
            }
        })
    }
    
    func createUser(email: String,pass: String,type: Int, loginHandler: LoginHandler?){
        
       FIRAuth.auth()?.createUser(withEmail: email, password: pass, completion: { (user, error) in
        if error != nil {
             self.errorHandlers(error: error! as NSError , loginHandler: loginHandler)
        }
        else{
            loginHandler?(nil,nil,nil)
            if user?.uid != nil {
                //loggin in user 
                self.login(email: email, password: pass, loginHandler: loginHandler)
                //creating user based on the type.
                DBProvider.Instance.addUser(uid:  user!.uid, type: type, email: email)
            }
        }
       })
    }
    func errorHandlers(error: NSError, loginHandler: LoginHandler?){
        if let errorCode = FIRAuthErrorCode(rawValue: error.code){
            
            switch errorCode {
            case .errorCodeWrongPassword:
                loginHandler?(loginErrorCode.WRONG_PASSWORD,"pass",nil)
                break
                
            case .errorCodeUserNotFound:
               loginHandler?(loginErrorCode.USER_NOT_FOUND, "email",nil)
                break
                
            case .errorCodeEmailAlreadyInUse:
                loginHandler?(loginErrorCode.INVALID_EMAIL , "email",nil)
                break
            case .errorCodeWeakPassword:
                loginHandler?(loginErrorCode.PASSWORD_WEAK, "pass",nil)
            default:
                loginHandler?(loginErrorCode.PROBLEM_CONNECTING, "",nil)
                break
            }
        }
    }
    
    
}

