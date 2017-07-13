//
//  Ride.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 16/03/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation

class Ride {
    var dateOfTravel : String
    var origin : String
    var Destination : String
    var cost : String
    var Distance : String
    
    init(dateOfTravel: String, origin: String, Destination: String, cost: String, Distance: String) {
        self.dateOfTravel = dateOfTravel
        self.origin = origin
        self.Destination = Destination
        self.cost = cost
        self.Distance = Distance
    }
}
