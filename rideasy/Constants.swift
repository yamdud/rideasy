//
//  Constant.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 26/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation

class constants {
    
    //db provider 
    static let PASSENGERS = "Passenger"
    static let DRIVERS = "Drivers"
    static let EMAIL = "email"
    static let DATA = "data"
    static let isRider = "isRider"
    static let RIDE_REQUEST = "Ride_Request"
    static let RIDE_ACCEPTED = "Ride_Accepted"
    
    //sub tree 
    static let RIDE_DETAILS = "Ride_Details"

    
    
    //Ride handler
    static let NAME = "PASSENGER_NAME"
    static let USER_ID = "USER_ID"
    static let STARTING_ADDRESS = "STARTING_ADDRESS"
    static let STARTING_LATITUDE = "STARTING_LATITUDE"
    static let STARTING_LONGITUDE = "STARTING_LONGITUDE"
    static let DESTINATION_ADDRESS = "DESTINATION_ADDRESS"
    static let DESTINATION_LATITUDE = "DESTINATION_LATITUDE"
    static let DESTINATION_LONGITUDE = "DESTINATION_LONGITUDE"
    static let TIME = "TIME"
    static let DISTANCE = "DISTANCE"
    static let COST = "COST"
    
    //Driver handler 
    static let DRIVER_NAME = "DRIVER_NAME"
    static let DRIVER_ID = "DRIVER_ID"
    
    //ride accepted
    static let PASSENGER_ID = "PASSENGER_ID"
    static let CURRENT_DRIVER_LOCATION = "CURRENT_DRIVER_LOCATION"
    static let CURRENT_DRIVER_LOCATION_LAT = "CURRENT_DRIVER_LOCATION_LAT"
    static let CURRENT_DRIVER_LOCATION_LONG = "CURRENT_DRIVER_LOCATION_LONG"
}
