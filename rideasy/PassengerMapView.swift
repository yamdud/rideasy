//
//  PassengerMapView.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 26/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PassengerMapView: MKMapView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        findCurrentLocation()
        
    }
    
    var locationManager = CLLocationManager()
    var pointAnnotation:CustomPointAnnotation!
    
   
    
    func findCurrentLocation(){
        AddPin(LatLong: (CLLocationCoordinate2DMake(56.398202, -3.447540)), pinImageName: "Taxi")
        AddPin(LatLong: CLLocationCoordinate2DMake(56.394557, -3.434408), pinImageName:  "Taxi")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error", error.localizedDescription)
    }
    
    func AddPin(LatLong: CLLocationCoordinate2D,pinImageName : String){
        // self.MapView.removeAnnotation(pin)
        var pin = MKPinAnnotationView()
        pointAnnotation = CustomPointAnnotation()
        
        switch pinImageName {
        case "StartingPointPin":
            pointAnnotation.pinCustomImageName = "StartingPointPin"
            pointAnnotation.title = "Starting Point"
            break
            
        case "DestinationPin":
            pointAnnotation.pinCustomImageName = "DestinationPin"
            pointAnnotation.title = "Destination"
            pointAnnotation.subtitle = "Total Distance : "
            break
        case "Taxi":
            pointAnnotation.pinCustomImageName = pinImageName
            pointAnnotation.title = "Available taxis"
            break
        case "currentDriver":
            pointAnnotation.pinCustomImageName = "Driver"
            pointAnnotation.title = "Your current Driver"
            break
        default:
            break
        }
        
        //get the cordinates from place id s
        pointAnnotation.coordinate = LatLong
        
        pin = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
         self.addAnnotation(pin.annotation!)
        
    }


}
