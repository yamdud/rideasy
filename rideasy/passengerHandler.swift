//
//  requestRide.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 26/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation
import FirebaseDatabase
import CoreLocation

protocol rideAcceptedProtocol: class {
    func rideRequested(time: Double, distance: Double, cost: Double , destinationAdd: String)
    func rideAccepted(driverId: String, lat: Double, long: Double)
    func currentDriverLocation(currentLocation: CLLocationCoordinate2D)
    func rideCancelledByUser()
    func rideCancelledByDriver()
}
class passengerHandler {
    private static let _instance = passengerHandler()
    
    weak var delegate: rideAcceptedProtocol?
    var isRideAcceptedByDriver = false
    static var Instance: passengerHandler {
        return _instance
    }
    var queryUsingPassengerIdForRideAccepted: FIRDatabaseQuery{
        return DBProvider.Instance.rideAcceptedReference.queryOrdered(byChild: constants.PASSENGER_ID).queryEqual(toValue: DBProvider.Instance.currentUserId)
    }
    
    var queryUsingPassengerIdForRideRequest: FIRDatabaseQuery{
        return DBProvider.Instance.rideRequestReference.queryOrdered(byChild: constants.USER_ID).queryEqual(toValue: DBProvider.Instance.currentUserId)
    }
    
    func rideRequested (email: String,userId: String,startingAddress: String, startingLat: Double, startingLong: Double,destinationAddress: String, destinationLat : Double, destinationLong: Double, cost: Double , distance: Double, duration : Double){
        //let userid = DBProvider.Instance.ref.
        let data: Dictionary<String,Any> = [constants.NAME : email,constants.USER_ID : userId,constants.STARTING_ADDRESS : startingAddress,  constants.STARTING_LATITUDE : startingLat , constants.STARTING_LONGITUDE : startingLong, constants.DESTINATION_ADDRESS : destinationAddress,constants.DESTINATION_LATITUDE:destinationLat, constants.DESTINATION_LONGITUDE : destinationLong, constants.TIME : duration, constants.COST : cost, constants.DISTANCE : distance]
        DBProvider.Instance.rideRequestReference.childByAutoId().setValue(data)
    }
    
    func acceptedRide() {
        print("acceptedRide")
        if isRideAcceptedByDriver {
            queryUsingPassengerIdForRideAccepted.observe(.childAdded, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                print("the value \(value)")
                
                if let driverID = value?[constants.DRIVER_ID] as! String!{
                    let lat = value?[constants.STARTING_LATITUDE] as! Double
                    let long = value?[constants.STARTING_LONGITUDE] as! Double
                    self.updateCurrentDriverLocation(driverId: driverID)
                    self.delegate?.rideAccepted(driverId : driverID, lat: lat, long: long)
                    self.isRideAcceptedByDriver = true
                }
            })
        }
        else {
            queryUsingPassengerIdForRideRequest.observe(.childAdded, with: { (snapshot) in
                if let value = snapshot.value as? NSDictionary {
                    let cost = value[constants.COST] as! Double
                    let time = value[constants.TIME] as! Double
                    let distance = value[constants.DISTANCE] as! Double
                    let destinationAddress = value[constants.DESTINATION_ADDRESS] as! String
                    self.delegate?.rideRequested(time: time, distance: distance, cost: cost, destinationAdd: destinationAddress)
                    
                }
                print("")
                
            })
        }
       
    }
    func cancelRide(){
        if isRideAcceptedByDriver {
            print("insideRide Accepted by Driver")
           
            queryUsingPassengerIdForRideAccepted.observe(.value, with: { (snapshot) in
                print("the snapshot \(snapshot)")
                for snap in snapshot.children {
                    
                    if let snap = snap as? FIRDataSnapshot {
                        
                        DBProvider.Instance.rideAcceptedReference.child(snap.key).removeValue(completionBlock: { (error, ref) in
                            if error == nil {
                                print("data deleted")
                                self.delegate?.rideCancelledByDriver()
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
        else {
            queryUsingPassengerIdForRideRequest.observe(.value, with: { (snapshot) in
                for snap in snapshot.children {
                    if let snap = snap as? FIRDataSnapshot {
                        DBProvider.Instance.rideRequestReference.child(snap.key).removeValue(completionBlock: { (error, ref) in
                            if error == nil{
                                self.delegate?.rideCancelledByUser()
                            }
                            else {
                                
                            }
                        })
                    }
                }
            })
        }
    }
    func updateCurrentDriverLocation(driverId: String){
        let ref = DBProvider.Instance.rideAcceptedReference.queryOrdered(byChild: constants.DRIVER_ID).queryEqual(toValue: driverId)
        ref.observe(.value, with: { (snapsnot) in
            for snap in snapsnot.children {
                let snap = snap as! FIRDataSnapshot
                let key = snap.key
                DBProvider.Instance.rideAcceptedReference.child(key).child(constants.CURRENT_DRIVER_LOCATION).observe(.value, with: { (snapshot) in
                    if let data = snapshot.value as? NSDictionary{
                        print("the location of the driver is \(data)")
                        let lat = data[constants.CURRENT_DRIVER_LOCATION_LAT] as! Double
                        let lon = data[constants.CURRENT_DRIVER_LOCATION_LONG] as! Double
                        let currentDriverLocation = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                        self.delegate?.currentDriverLocation(currentLocation: currentDriverLocation)
                        
                    }
                    
                })
//                print("the location of driver is \(data)")
            }
    
        })
    }
   
}
