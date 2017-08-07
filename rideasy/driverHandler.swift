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
    func rideAccepted(pickupCoordinate: CLLocationCoordinate2D, pickupAddress: String, destinationCoordinate: CLLocationCoordinate2D, destionAddress: String)
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
                        //self.delegate?.rideAccepted(lat: lat, long: long)
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
                var newdata = NSDictionary()
                    newdata = [constants.DRIVER_ID: self.driverID , constants.DRIVER_NAME: self.driverName ,constants.STARTING_ADDRESS: data[constants.STARTING_ADDRESS] as! String!, constants.DESTINATION_ADDRESS: data[constants.DESTINATION_ADDRESS] as! String!, constants.PASSENGER_ID: passenId, constants.STARTING_LATITUDE: data[constants.STARTING_LATITUDE] as! Double,constants.STARTING_LONGITUDE : data[constants.STARTING_LONGITUDE] as! Double, constants.COST: data[constants.COST] as! Double, constants.TIME: data[constants.TIME] as! Double, constants.DISTANCE: data[constants.DISTANCE] as! Double , constants.DESTINATION_LATITUDE: data[constants.DESTINATION_LATITUDE] as! Double, constants.DESTINATION_LONGITUDE : data[constants.DESTINATION_LONGITUDE] as! Double]
                    
                    let pickupCoordinate = CLLocationCoordinate2DMake(newdata[constants.STARTING_LATITUDE] as! Double, newdata[constants.STARTING_LONGITUDE] as! Double)
                    let destinationCoordinate = CLLocationCoordinate2DMake(newdata[constants.DESTINATION_LATITUDE] as! Double, newdata[constants.DESTINATION_LONGITUDE] as! Double)
                //moving the data to a new tree
                DBProvider.Instance.rideAcceptedReference.childByAutoId().setValue(newdata)
                
                    self.delegate?.rideAccepted(pickupCoordinate: pickupCoordinate, pickupAddress: newdata[constants.STARTING_ADDRESS] as! String, destinationCoordinate: destinationCoordinate, destionAddress: newdata[constants.DESTINATION_ADDRESS] as! String)
                //deleting the ride request data.
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
    func nonAccepetedRideRequest(){
        DBProvider.Instance.rideRequestReference.observeSingleEvent(of: FIRDataEventType.value) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value{
                    print(data)
            }
            
        }
    }
    func cancelRideRequest(){
        //todo--
        let ref = DBProvider.Instance.rideAcceptedReference.queryOrdered(byChild: constants.DRIVER_ID).queryEqual(toValue: DBProvider.Instance.currentUserId)
        ref.observe(.value, with: { (snapshot) in
            for snap in snapshot.children {
                let snap = snap as! FIRDataSnapshot
                if let data = snap.value as? NSDictionary {
                    var newdata = NSDictionary()
                    newdata = [constants.NAME: data[constants.PASSENGER_ID] as! String, constants.STARTING_ADDRESS: data[constants.STARTING_ADDRESS] as! String,constants.STARTING_LATITUDE: data[constants.STARTING_LATITUDE] as! Double,constants.STARTING_LONGITUDE: data[constants.STARTING_LONGITUDE] as! Double,constants.DESTINATION_ADDRESS: data[constants.DESTINATION_ADDRESS] as! String,constants.DESTINATION_LATITUDE: data[constants.DESTINATION_LATITUDE] as! Double,constants.DESTINATION_LONGITUDE: data[constants.DESTINATION_LONGITUDE] as! Double,constants.TIME: data[constants.TIME] as! Double,constants.COST: data[constants.COST] as! Double,constants.DISTANCE: data[constants.DISTANCE] as! Double]
                    
                   //add the ride request again
                    DBProvider.Instance.rideRequestReference.childByAutoId().setValue(newdata)
                    
                    //deleting the ride accpeted data 
                    DBProvider.Instance.rideAcceptedReference.child(snap.key).removeValue(completionBlock: { (error, snapshot) in
                        if error == nil {
                            print("data has been deleted.")
                        }
                        else{
                            print("something went wrong")
                        }
                    })
                }
            }
        })
        
    }
    
    //storing the location of all online drivers. 
    func updateCurrentLocationForAvailableDriver(location: CLLocationCoordinate2D){
        let data = NSDictionary()
        data = [constants.DRIVER_ID: "", constants.DRIVER_LOCATION_LAT : location.latitude as! Double, constants.DRIVER_LOCATION_LONG: location.longitude as! Double]
        DBProvider.Instance.onlineDriverReference.childByAutoId().setValue(data)
    }
    
    
    func activeRide(){
        let data = NSDictionary()
        
        //driver id, passenger id, starting location, destination, address both starting and destination, distance covered, total charge, time taken 
        
        data = [constants.DRIVER_ID: "", constants.PASSENGER_ID: "", constants.STARTING_ADDRESS: "" , constants.STARTING_LONGITUDE: "", constants.STARTING_LATITUDE: "", constants.DESTINATION_ADDRESS: "", constants.DESTINATION_LATITUDE: "", constants.DESTINATION_LONGITUDE
            : ""]
        DBProvider.Instance.rideActiveReference.childByAutoId().setValue(data)
    }
}
