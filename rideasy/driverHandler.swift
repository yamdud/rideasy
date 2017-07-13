//
//  driverHandler.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 10/05/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//


import FirebaseDatabase
import FirebaseAuth
import CoreLocation

protocol RideController: class {
    func showride(lat: Double, long: Double, passengerId: String, startingAddress: String)
    func rideAccepted(lat: Double, long: Double)
}

class driverHandler {
    
    private static let _instance = driverHandler()
    
    weak var delegate: RideController?
    
    var passengerID = ""
    var driverName = "Rob Johnson"
    var driverID = ""
    var rideRequestID = ""
    var isRideAlive = false
    
    static var Instance : driverHandler {
        return _instance
    }
    
    func observeRideRequest(){
        
                          DBProvider.Instance.rideRequestReference.observe(FIRDataEventType.childAdded, with: { (snapshot: FIRDataSnapshot) in
                            if let data = snapshot.value as? NSDictionary {
                                
                                if let latitude = data[constants.STARTING_LATITUDE] as? Double {
                                    if let longitude = data[constants.STARTING_LONGITUDE] as? Double {
                                        self.driverID = DBProvider.Instance.currentUserId
                                        self.passengerID = data[constants.USER_ID] as! String
                                        let startAdd = data[constants.STARTING_ADDRESS] as! String
                                        print("data \(self.driverName,self.passengerID,latitude,longitude) the thread is \(Thread.current))")
                                       // print("key \(key)")
                                        self.delegate?.showride(lat: latitude, long: longitude,passengerId: self.passengerID, startingAddress: startAdd)
                                        
                                    }
                                }
                               
                            }
                          })

    }
    func obsereveRideAccepted(){
        DBProvider.Instance.rideAcceptedReference.observe(.childAdded, with: { (snapshot) in
            if let data = snapshot.value as? NSDictionary {
                print("ride accepted data \(data)")
                if let lat = data[constants.STARTING_LATITUDE] as? Double{
                    if let long = data[constants.STARTING_LONGITUDE] as? Double {
                        self.delegate?.rideAccepted(lat: lat, long: long)
                    }
                }
            }
        })
    }
    func requestAccepted(passenId: String){
        
     let ref = DBProvider.Instance.rideRequestReference.queryOrdered(byChild: constants.USER_ID).queryEqual(toValue: passenId)
        ref.observe(.value, with: { (snapshot) in
            for snap in snapshot.children {
                let snap = snap as! FIRDataSnapshot
                if let data = snap.value as? NSDictionary {
                var newdata = Dictionary<String,Any?>()
                    newdata = [constants.DRIVER_ID: self.driverID , constants.DRIVER_NAME: self.driverName ,constants.STARTING_ADDRESS: data[constants.STARTING_ADDRESS] as! String!, constants.DESTINATION_ADDRESS: data[constants.DESTINATION_ADDRESS] as! String!, constants.PASSENGER_ID: passenId, constants.STARTING_LATITUDE: data[constants.STARTING_LATITUDE] as! Double,constants.STARTING_LONGITUDE : data[constants.STARTING_LONGITUDE] as! Double]
                    
                
                DBProvider.Instance.rideAcceptedReference.childByAutoId().setValue(newdata)
                
                    DBProvider.Instance.rideRequestReference.child(snap.key).removeValue(completionBlock: { (error, ref) in
                    if error == nil {
                        print("data deleted")
                    }
                    else
                    {
                        print("something went wrong \(String(describing: error?.localizedDescription))")
                    }
                })
                }
            }
        })

    }
    func updateCurrentDriverLocation(location: CLLocationCoordinate2D){
        let ref = DBProvider.Instance.rideAcceptedReference.queryOrdered(byChild: constants.DRIVER_ID).queryEqual(toValue: driverID)
        ref.observe(.value, with: { (snapshot) in
            for snap in snapshot.children {
                    let snap = snap as! FIRDataSnapshot
                    print("the key is \(snap.key)")
                var currentDriverLocation = Dictionary<String,Any?>()
                currentDriverLocation = [constants.CURRENT_DRIVER_LOCATION_LAT: location.latitude, constants.CURRENT_DRIVER_LOCATION_LONG: location.longitude]
                DBProvider.Instance.rideAcceptedReference.child(snap.key).child(constants.CURRENT_DRIVER_LOCATION).setValue(currentDriverLocation)
            }
            
        })
        
       
    }
    func NonAccepetedRideRequest(){
        DBProvider.Instance.rideRequestReference.observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value{
                    print(data)
            }
            
        }
    }
}
