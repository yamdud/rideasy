//
//  CoordinateHelper.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 26/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
import GooglePlaces

class CoordinateHelper {
    private static let _instance = CoordinateHelper()
    
    static var Instance: CoordinateHelper {
        return _instance
    }
    var coordinates = CLLocationCoordinate2D()
    
    
    
    func findCoordinates(Placeid: String) -> CLLocationCoordinate2D{
        
        GMSPlacesClient.shared().lookUpPlaceID(Placeid) { (place, error) in
            if error == nil {
                self.coordinates = place!.coordinate
                print("corrdinates : \(place!.coordinate)")
                print("corrdinate co : \(self.coordinates)")
                
            }
        }
        print("corrdinate co : \(self.coordinates)")
        return coordinates
        
    }
    
    func calculateRoute(origin: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completion: @escaping (Double) -> ())  {
        DispatchQueue.global(qos: .userInteractive).async {
            let request: MKDirectionsRequest = MKDirectionsRequest()
            let originMapItem = MKMapItem(placemark: MKPlacemark(coordinate: origin, addressDictionary: nil))
            let destinationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
            var eta = Double()
            request.source = originMapItem
            request.destination = destinationMapItem
            request.requestsAlternateRoutes = false
            request.transportType = .automobile
            let group = DispatchGroup()
            
            let direction = MKDirections(request: request)
            print("eta from singleton 1",eta)
            //group.enter()
            
            direction.calculateETA { (response, error) in
                print("eta from singleton 2",eta)
                if error == nil {
                    eta = (response?.expectedTravelTime)!
                    
                    print("eta from singleton",eta)
                    print("completion")
                    DispatchQueue.main.async {
                    completion(eta)
                    }
                }
                else{
                    print(error?.localizedDescription)
                }
                // group.leave()
            }
            
        }
        print("Step 2")
    }
    
    func returnPlacemark(address:String) -> MKMapItem {
        let location = CLLocation(latitude: 56.4056356, longitude: -3.460563) //
        let location2d = CLLocationCoordinate2D(latitude: 56.4056356, longitude: -3.460563)
        let geoCode = CLGeocoder()
        var mapItem = MKMapItem()
        geoCode.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                mapItem = MKMapItem(placemark: MKPlacemark(coordinate: location2d, addressDictionary: placemark.addressDictionary as! [String: AnyObject]?))
            }
        })
      
        print("the address is \(address) ",mapItem)
        return mapItem
    }
    
}
