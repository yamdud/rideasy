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
    
    
    @IBOutlet weak var NavBarMenuItem: UIBarButtonItem!
    
    @IBOutlet weak var MapView: PassengerMapView!
    @IBOutlet weak var PopDownMenuView: rideRequestForm!
    @IBOutlet weak var LocationFormView: UIView!
    @IBOutlet weak var PaymentView: UIView!
    @IBOutlet weak var StartingPointTextBox: UITextField!
    @IBOutlet weak var DestinationTextView: UITextField!
    @IBOutlet weak var ApproxTotalLabel: UILabel!
    
    
    @IBOutlet weak var LocationFormStackView: UIStackView!
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet weak var formButton: UIButton!
    
    @IBOutlet weak var InfoView: infoView!
    
    
    
    //Location for current drivers and all available drivers
    private var currentDriverLocation: CLLocationCoordinate2D?
    private var allDriverLocation = [CLLocationCoordinate2D?]()
    
    //Starting Location
    private var startingLocation = CLLocationCoordinate2D()
    var isWaitingForRide = false
    
    
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
    
    var distance = Double()
    var ETA = Double()
    
    var PopUpView:UIView?
    
    let helper = CoordinateHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        
        
        StartingPointTextBox.delegate = self
        DestinationTextView.delegate = self
        passengerHandler.Instance.delegate = self
        passengerHandler.Instance.acceptedRide()
        MapView.delegate = self
        findCurrentLocation()
        
        locationTuples = [(StartingPointTextBox  , nil,nil),(DestinationTextView, nil,nil)]
        createTable()
        if self.revealViewController() != nil {
            print("in anv menu", self.revealViewController())
            NavBarMenuItem.target = self.revealViewController()
            NavBarMenuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            
        }
    }
   
    //MARK--delegate functions from passengerHangler
    func rideRequested(time: Double, distance: Double, cost: Double, destinationAdd: String) {
        
        isWaitingForRide = true
        InfoView.ShowView(distance: distance, time: time, cost: cost, destinationAddress: destinationAdd)
        InfoView.InfoViewSetup(option: "sliderin")
    }
    func rideAccepted(driverId: String, lat: Double, long: Double) {
        print("the ride has been accepter by \(driverId)")
        startingLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }
    
    func currentDriverLocation(currentLocation: CLLocationCoordinate2D) {
        let q = MKPlacemark(coordinate: currentLocation, addressDictionary: nil)
        print("place mark for current driver location : \(q)")
        currentDriverLocation = currentLocation
        CoordinateHelper.Instance.calculateRoute(origin: startingLocation, destination: currentDriverLocation!) { (eta) in
            self.InfoView.TaxiTrackerSlider.setupSlider(TotalTime: Float(eta), TrackingSlide: self.InfoView.TaxiTrackerSlider, view: self.InfoView.SliderView)
                Animation.Instance.AnimateInfoView(infoView: self.InfoView)
            
        }
        MapView.AddPin(LatLong: currentLocation, pinImageName: "currentDriver")
    }
    
    func rideCancelledByUser() {
        InfoView.InfoViewSetup(option: "hideview")
        let messageView = infoIndicatingView.init(frame: CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: 50))
        messageView.backgroundColor = UIColor(red: 196/255, green: 110/255, blue: 86/255, alpha: 0.8)
        self.view.addSubview(messageView)
        self.view.bringSubview(toFront: messageView)
        messageView.changeText(message: "Request is cancelled by Passenger")
        isWaitingForRide = false
    }
    
    func rideCancelledByDriver() {
        InfoView.InfoViewSetup(option: "hideview")
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
            MapView.showsUserLocation = true
            
        }
    }
    
    
    
    func findCoordinates(PlID:String){
        
        
        print("PlaceID" , PlID)
        GMSPlacesClient.shared().lookUpPlaceID(PlID, callback: { (place,error) -> Void in
            if error != nil {
                print("Error with place ID")
            }
            if place != nil {
                print("Lat & long", place?.coordinate as Any)
                //let coordinate = CoordinateHelper.Instance.findCoordinates(Placeid: PlID)
                
                let coordinate = place!.coordinate
                //        let coordinate = instance.findCoordinates(Placeid: PlID)
                var i:Int
                if self.activeTextBox == self.DestinationTextView {
                    i = 1
                    self.MapView.AddPin(LatLong: (coordinate), pinImageName: "DestinationPin")
                }
                else {
                    i = 0
                    self.MapView.AddPin(LatLong: (coordinate), pinImageName: "StartingPointPin")
                }
                
                let center = CLLocationCoordinate2D(latitude: (coordinate.latitude), longitude:(coordinate.longitude))
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                
                self.MapView.setRegion(region, animated: true)
                self.locationTuples[i].location = coordinate
                self.locationTuples[i].mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: self.DestinationTextView?.text as? [String: Any]))
                self.CalculateRoute()
            }
        })
        
    }
    
    func CalculateRoute() {
        
        let request: MKDirectionsRequest = MKDirectionsRequest()
        
        request.source = locationTuples[0].mapItem
        request.destination = locationTuples[1].mapItem
        request.requestsAlternateRoutes = false
        
        request.transportType = .automobile
        
        let direction = MKDirections(request: request)
        direction.calculate(completionHandler: {(response , error) in
            if error != nil {
                print("Direction not found")
            }
            else{
                print("direction found" , response?.routes.count)
                self.distance = (response?.routes.first?.distance)! * 0.000621371
                self.ETA = (response?.routes.first?.expectedTravelTime)!/60
                print("ETA" , self.distance , self.ETA)
                self.DrawRoute(response: response!)
            }
            
        })
    }
    func DrawRoute(response: MKDirectionsResponse) {
        print("We are in Drwa route", response)
        if MapView.overlays.count != 0 {
            for overlay in MapView.overlays{
                MapView.remove(overlay)
            }
        }
        for route in response.routes {
            MapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
            
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
            print("distance",self.distance,ldelta)
            print(locationTuples[0].mapItem)
            //let middlelocation = middleLocationWith(location1: locationTuples[0].location!, location2: locationTuples[1].location!)
            //let center = CLLocationCoordinate2D(latitude: middlelocation.latitude, longitude:middlelocation.longitude)
            //let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: ldelta, longitudeDelta: lodelta))
            /*var rect = response.routes.first?.polyline.boundingMapRect
             var kera = MKCoordinateRegionForMapRect(rect!)
             rect?.size.width += 1000
             rect?.size.height += 1000
             
             print("rect",rect)*/
            //self.MapView.setRegion(region, animated: true)
            let coo = response.routes.first?.polyline.coordinate
            let Point: CGPoint = self.MapView.convert(coo!, toPointTo: self.MapView)
            InfoView.ShowView(distance: self.distance.roudto(places: 1), time: self.ETA.roudto(places: 2), cost: 25.00, destinationAddress: (locationTuples[1].textfield?.text)!)
            //AddPin(LatLong: coo!)
            let steps = route.steps
        }
        //animate > button
        //done for today continue tomorrow .
        self.formButton.alpha = 1.0
        self.formButton.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        InfoView.InfoViewSetup(option: "disTimein")
        //self.formButton.alpha = 1.0
        UIView.animate(withDuration: 0.5, animations: {
            self.formButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            self.formButton.transform = CGAffineTransform.identity
        })
        UIView.animate(withDuration: 0.5, delay: 0.45, options: .curveEaseIn, animations: {
            self.formButton.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }, completion: nil)
        
        //hide keyboard
        self.view.endEditing(true)
        
    }
    
    func middleLocationWith(location1:CLLocationCoordinate2D,location2: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        let lon1 = location1.longitude * M_PI / 180
        let lon2 = location2.longitude * M_PI / 180
        let lat1 = location1.latitude * M_PI / 180
        let lat2 = location2.latitude * M_PI / 180
        let dLon = lon2 - lon1
        let x = cos(lat2) * cos(dLon)
        let y = cos(lat2) * sin(dLon)
        
        let lat3 = atan2( sin(lat1) + sin(lat2), sqrt((cos(lat1) + x) * (cos(lat1) + x) + y * y) )
        let lon3 = lon1 + atan2(y, cos(lat1) + x)
        
        let center:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat3 * 180 / M_PI, lon3 * 180 / M_PI)
        return center
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
        
        self.MapView.setRegion(region, animated: true)
        
        CLGeocoder().reverseGeocodeLocation(locations.last!,completionHandler: {(placemarks , error) -> Void in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
                self.locationTuples[0].mapItem = MKMapItem(placemark: MKPlacemark(coordinate: placemark.location!.coordinate, addressDictionary: placemark.addressDictionary as! [String: AnyObject]?))
                self.locationTuples[0].location = placemark.location?.coordinate
                self.StartingPointTextBox.text = self.formatAddress(placemark: placemark)
            }
        })
        if currentDriverLocation != nil {
            MapView.AddPin(LatLong: currentDriverLocation!, pinImageName: "currentRider")
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
           
       InfoView.InfoViewSetup(option: "hideview")
        PopDownMenuView.isUserInteractionEnabled = true
        Animation.Instance.animate(LocationFormView: PopDownMenuView.LocationFormView, PopDownMenuView: PopDownMenuView, PaymentView: PopDownMenuView.PaymentView, ApproxTotalLabel: PopDownMenuView.ApproxTotalLabel, searchButton: searchButton)
    }
        
    }
    
    //func didupdate
    func placeAutocomplete(text: String) {
        
        //getting the visible map area
        let visibleRegion = self.MapView.visibleMapRect
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
        let nePoint = CGPoint(x: self.MapView.bounds.maxX, y: self.MapView.bounds.origin.y)
        let swPoint = CGPoint(x: self.MapView.bounds.minX, y: self.MapView.bounds.maxY)
        let neCoord = self.MapView.convert(nePoint, toCoordinateFrom: self.MapView)
        let swCoord = self.MapView.convert(swPoint, toCoordinateFrom: self.MapView)
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
        PopDownMenuView.ApproxTotalLabel.text = "Your Approximate total is £25.00"
        
        if Animation.Instance.ButtonStatus == true {
            Animation.Instance.AnimatePayment(PaymentView: PaymentView)
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
                
                InfoView.InfoViewSetup(option: "sliderin")
                Animation.Instance.animate(LocationFormView: PopDownMenuView.LocationFormView, PopDownMenuView: PopDownMenuView, PaymentView: PopDownMenuView.PaymentView, ApproxTotalLabel: PopDownMenuView.ApproxTotalLabel, searchButton: searchButton)
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
        isWaitingForRide = false
        passengerHandler.Instance.cancelRide()
        PopDownMenuView.clearForm()
        }
    }
}
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









