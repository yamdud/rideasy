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
    var pointAnnotation = CustomPointAnnotation()
    var eta = Double()
    var distance = Double()
    var cost = 25.00
   
    
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
            pointAnnotation.pinCustomImageName = "Taxi"
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
    func calculateRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D){
        CoordinateHelper.Instance.calculateRoute(origin: origin, destination: destination, completion: { (eta,distance,response) in
            self.distance = distance * 0.000621371
            self.eta = eta/60
            self.drawRoute(response: response)
        })
    }
        
    func drawRoute(response: MKDirectionsResponse) {
        
        if self.overlays.count != 0 {
            for overlay in self.overlays{
                self.remove(overlay)
            }
        }
        for route in response.routes {
            
            self.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            var ldelta = 0.0
            var lodelta = 0.0
            if self.distance <= 5.00 {
                ldelta = 0.03
                lodelta = 0.03
            }
            else if self.distance <= 12.00 {
                ldelta = 0.07
                lodelta = 0.07
            }
            else {
                ldelta = 0.5
                lodelta = 0.5
            }
            //let middlelocation = middleLocationWith(location1: locationTuples[0].location!, location2: locationTuples[1].location!)
            //let center = CLLocationCoordinate2D(latitude: middlelocation.latitude, longitude:middlelocation.longitude)
            //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: ldelta, longitudeDelta: lodelta))
            /*var rect = response.routes.first?.polyline.boundingMapRect
             var kera = MKCoordinateRegionForMapRect(rect!)
             rect?.size.width += 1000
             rect?.size.height += 1000
             
             print("rect",rect)*/
            //self.MapView.setRegion(region, animated: true)
        }
    }

    func removeAvailableTaxiPins(){
        let availableTaxiPins = self.annotations
        for annotation in availableTaxiPins {
            let customAnnotaion = annotation as! CustomPointAnnotation
            if customAnnotaion.pinCustomImageName == "Taxi"{
                
                self.removeAnnotation(annotation)
            }
        }
    }
    

}
