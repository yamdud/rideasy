//
//  PassengerView.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 24/01/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//


//user location--- set it as starting point when user did not select address //
import GooglePlaces
import Foundation
import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth


class  PassengerView: UIViewController,MKMapViewDelegate, CLLocationManagerDelegate,UITableViewDelegate,UITextFieldDelegate, UITableViewDataSource, rideAcceptedProtocol{
    

    
    
    @IBOutlet weak var navBarMenuItem: UIBarButtonItem!
    
    @IBOutlet weak var passengerMapView: PassengerMapView!
    @IBOutlet weak var popDownMenuView: rideRequestForm!
    //@IBOutlet weak var LocationFormView: UIView!
    //@IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var StartingPointTextBox: UITextField!
    @IBOutlet weak var DestinationTextView: UITextField!
    @IBOutlet weak var ApproxTotalLabel: UILabel!
    
    
    @IBOutlet weak var LocationFormStackView: UIStackView!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var formButton: UIButton!
    
    @IBOutlet weak var infoView: infoView!
    
    
    
    //Location for current drivers and all available drivers
    private var currentDriverLocation: CLLocationCoordinate2D?
    private var allDriverLocation = [CLLocationCoordinate2D?]()
    
    //Starting Location
    private var startingLocation = CLLocationCoordinate2D()
    var isWaitingForRide = false
    
    //message view to notify passengers 
    var messageView = infoIndicatingView()
    
    
    var activeTextBox = UITextField()
    var AutoCompleteArray:[[String]] = [["", ""]]
    var locationManager = CLLocationManager()
    var locationTuples: [(textfield: UITextField? , mapItem: MKMapItem? , location:CLLocationCoordinate2D?)]!
    
    var ButtonStatus = false
    
    let GoogleApiKey = "AIzaSyC_XhKkkHB6FRMg2nNIP00jSrAQFZSkh8k"
    let baseURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    var AutoCompleteTable = UITableView()
    var fetcher : GMSAutocompleteFetcher?
    typealias Edges = (ne: CLLocationCoordinate2D , sw: CLLocationCoordinate2D)
    //direction variables
    var distance = Double()
    var ETA = Double()
    
    var PopUpView:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        
        StartingPointTextBox.delegate = self
        DestinationTextView.delegate = self
        passengerHandler.Instance.delegate = self
        passengerHandler.Instance.acceptedRide()
        passengerHandler.Instance.rideRequestedButNotAccepted()
        passengerMapView.delegate = self
        findCurrentLocation()
        
        locationTuples = [(StartingPointTextBox  , nil,nil),(DestinationTextView, nil,nil)]
        //creating autocomplete table
        createTable()
        
        if self.revealViewController() != nil {
            navBarMenuItem.target = self.revealViewController()
            navBarMenuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    //MARK--delegate functions from passengerHangler
    func rideRequested(time: Double, distance: Double, cost: Double, destinationAdd: String,destinationCoordinate: CLLocationCoordinate2D, startingCoordinate: CLLocationCoordinate2D) {
        
        isWaitingForRide = true
        infoView.setupLabels(distance: distance, time: time, cost: cost, destinationAddress: destinationAdd)
        if passengerMapView.overlays.count == 0 {
            passengerMapView.calculateRoute(origin: startingCoordinate, destination: destinationCoordinate)
            
        }
        infoView.InfoViewSetup(option: "sliderin")
        passengerMapView.AddPin(LatLong: destinationCoordinate, pinImageName: "DestinationPin")
        passengerMapView.AddPin(LatLong: startingCoordinate, pinImageName: "StartingPointPin")
    }
    func rideAccepted(driverId: String, startingCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, address: String, time: Double, cost: Double, distance: Double) {
        print("the ride has been accepter by \(driverId)")
        
        startingLocation = startingCoordinate
        infoView.InfoViewSetup(option: "sliderin")
        isWaitingForRide = true 
        //check this
        passengerMapView.removeAvailableTaxiPins()
        passengerMapView.AddPin(LatLong: destinationCoordinate, pinImageName: "DestinationPin")
        passengerMapView.AddPin(LatLong: startingCoordinate, pinImageName: "StartingPointPin")
        if passengerMapView.overlays.count == 0 {
            passengerMapView.calculateRoute(origin: startingCoordinate, destination: destinationCoordinate)
            
        }
        infoView.setupLabels(distance: distance, time: time, cost: cost, destinationAddress: address)
    }
    func currentDriverLocation(currentLocation: CLLocationCoordinate2D) {
        let q = MKPlacemark(coordinate: currentLocation, addressDictionary: nil)
        print("place mark for current driver location : \(q)")
        currentDriverLocation = currentLocation
        CoordinateHelper.Instance.calculateRoute(origin: startingLocation, destination: currentDriverLocation!) { (eta,distance,response) in
            self.infoView.TaxiTrackerSlider.setupSlider(TotalTime: (Float(eta)), TrackingSlide: self.infoView.TaxiTrackerSlider, view: self.infoView.SliderView)
                //Animation.Instance.AnimateInfoView(infoView: self.infoView)
                //infoView.InfoViewSetup(option:)
            
        }
        
        passengerMapView.AddPin(LatLong: currentLocation, pinImageName: "currentDriver")
       
    }
    
    func rideCancelledByUser() {
       
    }
    
    func rideCancelledByDriver() {
        infoView.InfoViewSetup(option: "hideview")
        isWaitingForRide = false
    }

    
    func createTable()  {
        print("We here")
        let screenSize = UIScreen.main.bounds.size
        let tableView = UITableView(frame: CGRect(x: view.frame.origin.x, y: activeTextBox.frame.origin.y + LocationFormStackView.frame.height + 12, width: screenSize.width, height: 300))
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 30
        tableView.isHidden = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        AutoCompleteTable = tableView
        AutoCompleteTable.isHidden = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AutoCompleteArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 16.0)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = AutoCompleteArray[indexPath.row][0]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //dissmiss table
        AutoCompleteTable.isHidden = true
        
        //setting the textbox text to the selected address
        self.activeTextBox.text = AutoCompleteArray[indexPath.row][0]
        //getting the place id to find the coordinates
        findCoordinates(PlID: AutoCompleteArray[indexPath.row][1])
        AutoCompleteArray.removeAll()
        
    }
    
    func findCurrentLocation(){
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            passengerMapView.showsUserLocation = true
            
        }
    }
    
    
    
    func findCoordinates(PlID:String){
        
        
        print("PlaceID" , PlID)
        GMSPlacesClient.shared().lookUpPlaceID(PlID, callback: { (place,error) -> Void in
            if error != nil {
                print("Error with place ID")
            }
            if place != nil {
                let coordinate = place!.coordinate
                var i:Int
                if self.activeTextBox == self.DestinationTextView {
                    i = 1
                    self.passengerMapView.AddPin(LatLong: (coordinate), pinImageName: "DestinationPin")
                }
                else {
                    i = 0
                    self.passengerMapView.AddPin(LatLong: (coordinate), pinImageName: "StartingPointPin")
                }
                
                let center = CLLocationCoordinate2D(latitude: (coordinate.latitude), longitude:(coordinate.longitude))
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                
                self.passengerMapView.setRegion(region, animated: true)
                self.locationTuples[i].location = coordinate
                self.locationTuples[i].mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: self.DestinationTextView?.text as? [String: Any]))
                
                //checking if both the location are set for both textfield.
               self.checkIfEmpty()
            }
        })
        
    }
    
    func checkIfEmpty(){
        print("in here in echeck if empty \(locationTuples[0] ,locationTuples[1])")
        if locationTuples[0].location != nil && locationTuples[1].location != nil {
            print("in here in echeck if empty")
            
            passengerMapView.calculateRoute(origin: locationTuples[0].location!, destination: locationTuples[1].location!)
           CoordinateHelper.Instance.calculateRoute(origin: self.locationTuples[0].location!, destination: self.locationTuples[1].location!, completion: { (eta,distance,response) in
                self.distance = distance * 0.000621371
                self.ETA = eta/60
                self.passengerMapView.drawRoute(response: response)
            
                print("checking distance \(self.distance,self.ETA)")
                self.infoView.setupLabels(distance: self.distance.roudto(places: 1), time: self.passengerMapView.eta.roudto(places: 2), cost: 25.00, destinationAddress: (self.locationTuples[1].textfield?.text)!)
            self.formButton.alpha = 1.0
            self.formButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            self.infoView.InfoViewSetup(option: "disTimein")
            UIView.animate(withDuration: 0.5, animations: {
                self.formButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
                self.formButton.transform = CGAffineTransform.identity
            })
            
            self.view.endEditing(true)
          })
        }
    }
    
    

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
        let reuseIdentifier = "pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            view?.canShowCallout = true
        }
        else{
            view?.annotation = annotation
        }
        
        let customPoint = annotation as! CustomPointAnnotation
        view?.image = UIImage(named: (customPoint.pinCustomImageName))
        
        return view
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(red: 217/255, green: 89/255, blue: 76/255, alpha: 1)
        renderer.lineWidth = 5.0
        return renderer
    }
    
    //location delegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let  location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        
        self.passengerMapView.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(locations.last!,completionHandler: {(placemarks , error) -> Void in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.locationTuples[0].mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String: AnyObject]?))
                self.locationTuples[0].location = placemark.location?.coordinate
                self.StartingPointTextBox.text = self.formatAddress(placemark: placemark)
            }
        })
        if currentDriverLocation != nil {
            passengerMapView.AddPin(LatLong: currentDriverLocation!, pinImageName: "currentRider")
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error", error.localizedDescription)
    }
    
    func formatAddress(placemark: CLPlacemark) -> String {
        return (placemark.addressDictionary!["FormattedAddressLines"] as! [String]).joined(separator: ", ")
    }
    
    @IBAction func SearchRoute(_ sender: Any) {
        if !isWaitingForRide {
           
       infoView.InfoViewSetup(option: "hideview")
        popDownMenuView.isUserInteractionEnabled = true
        Animation.Instance.animate(LocationFormView: popDownMenuView.LocationFormView, PopDownMenuView: popDownMenuView, PaymentView: popDownMenuView.PaymentView, ApproxTotalLabel: popDownMenuView.ApproxTotalLabel, searchButton: searchButton)
    }
        
    }
    
    //func didupdate
    func placeAutocomplete(text: String) {
        
        //getting the visible map area
        let visibleRegion = self.passengerMapView.visibleMapRect
        let bounds = GMSCoordinateBounds(coordinate: edgePoints().ne,coordinate: edgePoints().sw)
        //set the filter to no filter in order to get the addressess for all the location
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "uk"
        
        GMSPlacesClient.shared().autocompleteQuery(text, bounds: nil, filter: filter, callback: {
            (results, error) -> Void in
            guard error == nil else {
                
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                //self.AutoCompleteArray.removeAll()
                for result in results {
                    
                    
                    self.AutoCompleteArray.insert([result.attributedFullText.string , result.placeID!], at: 0)
                    print("complete address: ", self.AutoCompleteArray)
                    
                }
                
            }
            
            self.AutoCompleteTable.reloadData()
            
        })
    }
    
    
    
    //getting the edge
    func edgePoints() -> Edges {
        let nePoint = CGPoint(x: self.passengerMapView.bounds.maxX, y: self.passengerMapView.bounds.origin.y)
        let swPoint = CGPoint(x: self.passengerMapView.bounds.minX, y: self.passengerMapView.bounds.maxY)
        let neCoord = self.passengerMapView.convert(nePoint, toCoordinateFrom: self.passengerMapView)
        let swCoord = self.passengerMapView.convert(swPoint, toCoordinateFrom: self.passengerMapView)
        return (ne: neCoord, sw: swCoord)
    }
    
    
    @IBAction func DestionationEntered(_ sender: Any) {
        
        CLGeocoder().geocodeAddressString( self.DestinationTextView.text!, completionHandler: {(placemarks , error) -> Void in
            if let placemarks = placemarks {
                
            }
            else {
                
            }
        })
    }
    
    @IBAction func CalculateApproxPrice(_ sender: Any) {
        popDownMenuView.ApproxTotalLabel.text = "Your Approximate total is £25.00"
        
        if Animation.Instance.ButtonStatus == true {
            Animation.Instance.AnimatePayment(paymentView: popDownMenuView.PaymentView)
        }
    }
    
    @IBAction func StratingPointDidChange(_ sender: Any) {
        if StartingPointTextBox.text != "" {
            self.AutoCompleteTable.isHidden = false
            placeAutocomplete(text: StartingPointTextBox.text!)
            fetcher?.sourceTextHasChanged(StartingPointTextBox.text)
            
        }
    }
    @IBAction func StartingPointEditStart(_ sender: Any) {
        StartingPointTextBox.placeholder = nil
        activeTextBox = StartingPointTextBox
    }
    @IBAction func StartingPointEditEnd(_ sender: Any) {
        
        if StartingPointTextBox.text == nil {
            StartingPointTextBox.placeholder = "Starting Point"
        }
    }
    
    @IBAction func DestinationFeildDidChange(_ sender: Any) {
        if DestinationTextView.text != "" {
            self.AutoCompleteTable.isHidden = false
            placeAutocomplete(text: DestinationTextView.text!)
            fetcher?.sourceTextHasChanged(DestinationTextView.text)
            
        }
    }
    
    @IBAction func DestinationEditStart(_ sender: Any) {
        DestinationTextView.placeholder  = nil
        activeTextBox = DestinationTextView
        
    }
    
    @IBAction func DestinationComplete(_ sender: Any) {
        if DestinationTextView.text == nil {
            DestinationTextView.placeholder = "Destination"
        }
    }
    
    
    @IBAction func PayNow(_ sender: Any) {
        isWaitingForRide = true
        if isWaitingForRide {
            if let user = FIRAuth.auth()?.currentUser {
                
                infoView.InfoViewSetup(option: "sliderin")
                Animation.Instance.animate(LocationFormView: popDownMenuView.LocationFormView, PopDownMenuView: popDownMenuView, PaymentView: popDownMenuView.PaymentView, ApproxTotalLabel: popDownMenuView.ApproxTotalLabel, searchButton: searchButton)
                passengerHandler.Instance.rideRequested(email: StartingPointTextBox.text!, userId: user.uid, startingAddress: (locationTuples[0].textfield?.text)!, startingLat: (locationTuples[0].location?.latitude)!, startingLong: (locationTuples[0].location?.longitude)!, destinationAddress: (locationTuples[1].textfield?.text)! , destinationLat: (locationTuples[1].location?.latitude)!, destinationLong: (locationTuples[1].location?.longitude)!, cost: 25.40 , distance: self.distance.roudto(places: 1) , duration: self.ETA.roudto(places: 0))
                
                
            }
        }
        else {
            print("Ride Already requested")
        }
        
    }
    
    
    
    @IBAction func menuPressed(_ sender: UIBarButtonItem) {
        //revealViewController().revealToggle(UIBarButtonItem)
    }
    
    @IBAction func cancelRide(_ sender: Any) {
        if isWaitingForRide {
        infoView.InfoViewSetup(option: "hideview")
        messageView = infoIndicatingView.init(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 50))
            messageView.backgroundColor = UIColor(red: 196/255, green: 110/255, blue: 86/255, alpha: 0.8)
        self.view.addSubview(messageView)
        self.view.bringSubview(toFront: messageView)
        messageView.changeText(message: "Request is cancelled by Passenger")
        isWaitingForRide = false
        passengerHandler.Instance.cancelRide()
        popDownMenuView.initialSetup()
        locationTuples = [(StartingPointTextBox,nil,nil),(DestinationTextView,nil,nil)]
        //removing overlays if present
        for overlay in passengerMapView.overlays{
                passengerMapView.remove(overlay)
            }
            //removing annotation for the startign point and destination
            for annotation in passengerMapView.annotations {
                if let title = annotation.title, (title == "Starting Point") || (title == "Destination") {
                    passengerMapView.removeAnnotation(annotation)
            }
            }
        }
    }
}//end of class
    
extension NSLayoutConstraint {
    func constraintWithMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
    //func textfieldShouldReturn()
}
extension Double{
    func roudto(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded()/divisor
    }
}
extension ViewController: GMSAutocompleteFetcherDelegate {
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        let resultsStr = NSMutableString()
        for prediction in predictions {
            resultsStr.appendFormat("%@\n", prediction.attributedPrimaryText)
        }
        
        print("GSM REsult" , resultsStr)
        // resultsStr.text = resultsStr as String
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        //resultText.text = error.localizedDescription
    }
    
}









