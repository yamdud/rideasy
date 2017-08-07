//
//  DBProvider.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 20/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
class DBProvider {
    private static let _instance = DBProvider()
    
    static var Instance: DBProvider {
        return _instance
    }
    var ref : FIRDatabaseReference {
      return FIRDatabase.database().reference()
    }
    
    var passgengerReference: FIRDatabaseReference {
        return ref.child(constants.PASSENGERS)
    }
    
    var DriverReference: FIRDatabaseReference {
        return ref.child(constants.DRIVERS)
    }
    var onlineDriverReference: FIRDatabaseReference {
        return ref.child(constants.AVAILABLE_RIDE)
    }
    var rideRequestReference: FIRDatabaseReference {
        return ref.child(constants.RIDE_REQUEST)
    }
    var rideAcceptedReference: FIRDatabaseReference{
        return ref.child(constants.RIDE_ACCEPTED)
    }
    
    var rideActiveReference: FIRDatabaseReference{
        return ref.child(constants.RIDE_ACTIVE)
    }
    
    var currentUserId: String {
       return (FIRAuth.auth()?.currentUser?.uid)!
    }
    func addUser(uid: String,type: Int,email: String){
      
        //creating a child which includes all the user with their type.
        ref.child("user").child(uid).setValue(["type" : type])
        
        var data = Dictionary<String,Any>()
        
        //creating child nodes based on the user type. 
        if type == 1 {
             data = [constants.EMAIL : email,constants.isRider : true]
            passgengerReference.child(uid).setValue(data)
        }
        else{
             data = [constants.EMAIL : email,constants.isRider : false]
            DriverReference.child(uid).setValue(data)
        }
        
    }
    
}
