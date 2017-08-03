//
//  DriverVC.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 26/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
import FirebaseDatabase

class DriverVC: UIViewController, MKMapViewDelegate, RideController, CLLocationManagerDelegate  {
    
    

    @IBOutlet weak var mapDisplayView: DriverMapView!
    @IBOutlet weak var menu: UIBarButtonItem!
    
    @IBOutlet weak var infoView: infoViewForDrivers!
    
    @IBOutlet weak var statusSwitch: UISwitch!
    var locationManager = CLLocationManager()
    
    var currentLocation = CLLocationCoordinate2D()
    var rideAccepeted = false 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapDisplayView.delegate = self
        driverHandler.Instance.delegate = self
        findCurrentLocation()
        //rideRequest()
        //driverHandler.Instance.observeRideRequest()
        // Do any additional setup after loading the view.
        if self.revealViewController() != nil {
            print("in anv menu", self.revealViewController())
            menu.target = self.revealViewController()
            menu.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
    
    
    @IBAction func StatusChanged(_ sender: Any) {
        if statusSwitch.isOn {
            driverHandler.Instance.observeRideRequest()
        }
        else{
            mapDisplayView.removeAnnotations(mapDisplayView.annotations)
        }
        
    }
    //--MARK--custom delgate function from driverhandler
    func showride(lat: Double, long: Double,passengerId: String, startingAddress: String) {
      let coordinate = CLLocationCoordinate2D(latitude: lat as CLLocationDegrees, longitude: long as CLLocationDegrees)
        mapDisplayView.AddPin(LatLong: coordinate, pinImageName: "newJob",id: passengerId, startAdd: startingAddress, driverCurrentLocation: currentLocation)
        
    }
    func rideAccepted(pickupCoordinate: CLLocationCoordinate2D, pickupAddress: String, destinationCoordinate: CLLocationCoordinate2D, destionAddress: String) {
        mapDisplayView.removeAnnotations(mapDisplayView.annotations)
        mapDisplayView.addCustomAnnotaion(latLong: pickupCoordinate)
        infoView.rideActive()
        infoView.setupAddressLabels(address: pickupAddress, option: "pickup")
    }
    
    func findCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            mapDisplayView.showsUserLocation = true
            
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        let reuseIdentifier = "pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if view == nil {
            if annotation.isKind(of: SimpleAnnotationPoint.self){
                print("simpleannotationpoint in -> mkannotation ")
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
                let customPoint = annotation as! SimpleAnnotationPoint
                view!.image = UIImage(named: (customPoint.pinCustomImage))
                return view
                
            }
            else{
            view = RideRequestAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            
            view!.canShowCallout = false
                let customPoint = annotation as! CustomPointAnnotation
                view!.image = UIImage(named: (customPoint.pinCustomImageName))
            return view
            }
        }
        else{
            view!.annotation = annotation
          
        }
        
        //view = setCalloutViewLayout(annotation: view!)

        return view!
        
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isKind(of: MKUserLocation.self){
        
        }
        if (view.annotation?.isKind(of: SimpleAnnotationPoint.self))!{
            print("simpleAnnotationPoint")
        }
        else{
            
        let location = CLLocationCoordinate2D(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)
        let region = MKCoordinateRegionMakeWithDistance(location, 3000.0, 4000.0)
        mapView.setRegion(region, animated: true)
        
        let customView = (Bundle.main.loadNibNamed("customCalloutView", owner: self, options: nil))?[0] as! RideRequestAnnotationView
        customView.layer.cornerRadius = 3
        let customAnnotation = view.annotation as! CustomPointAnnotation
        customView.id = customAnnotation.autoID
        customView.currentLocation = customAnnotation.driverCurrentLocation
        customView.startingAddress.text = customAnnotation.startAdd
        print("custom id \(customAnnotation.autoID)")
        let calloutViewFrame = customView.frame
        customView.frame = CGRect(x: -calloutViewFrame.size.width/2.23, y: -calloutViewFrame.size.height-7, width: 250, height: 130)
        view.addSubview(customView)
        }
    }
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView)
    {
        for childView:AnyObject in view.subviews{
            childView.removeFromSuperview();
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let  location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        mapDisplayView.setRegion(region, animated: true)
        currentLocation = (location?.coordinate)!
        
        locationManager.stopUpdatingLocation()
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error", error.localizedDescription)
    }

    @objc private func acceptRide(){
        print("Ride is Accepted \(currentLocation)")
        driverHandler.Instance.updateCurrentDriverLocation(location: currentLocation)
    }
    
    @IBAction func cancelRide(_ sender: Any) {
    }
    
    @IBAction func startRide(_ sender: Any) {
    }
    

} //end of class

