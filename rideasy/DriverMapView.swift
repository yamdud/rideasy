//
//  DriverMapView.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 11/05/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DriverMapView: MKMapView{

  
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    var pointAnnotation:CustomPointAnnotation!
    

    func AddPin(LatLong: CLLocationCoordinate2D,pinImageName : String, id: String, startAdd: String, driverCurrentLocation: CLLocationCoordinate2D){
        // self.MapView.removeAnnotation(pin)
    
        var pin = MKAnnotationView()
        pointAnnotation = CustomPointAnnotation()
        
        switch pinImageName {
        case "newJob":
            print("in new job ")
            pointAnnotation.pinCustomImageName = "newJob"
            pointAnnotation.autoID = id
            pointAnnotation.startAdd = startAdd
            pointAnnotation.driverCurrentLocation = driverCurrentLocation
            pointAnnotation.title = "new job"
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
        default:
            break
        }
        //get the cordinates from place id s
        pointAnnotation.coordinate = LatLong
        
        // pin = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        // pin = MKAnnotationView(
        pin = MKAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        print("lat of pin",pin.annotation?.coordinate.latitude)
        self.addAnnotation(pointAnnotation)
        
    }
    func addCustomAnnotaion(latLong : CLLocationCoordinate2D){
        var pin = MKAnnotationView()
        let newAnnotation = SimpleAnnotationPoint()
        
        newAnnotation.pinCustomImage = "StartingPointPin"
        newAnnotation.title = "Accepted Job"
            
            
            //get the cordinates from place id s
        newAnnotation.coordinate = latLong
        
        // pin = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: "pin")
        // pin = MKAnnotationView(
        pin = MKAnnotationView(annotation: newAnnotation, reuseIdentifier: "pin")
        print("lat of pin",pin.annotation?.coordinate.latitude)
        self.addAnnotation(pin.annotation!)
    }
    
}


