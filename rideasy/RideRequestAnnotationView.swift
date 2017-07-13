//
//  RideRequestAnnotationView.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 30/05/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol manageAnnotations: class {
    func cancelRide(selectedAnnotation : MKAnnotation)
}

class RideRequestAnnotationView: MKAnnotationView {
    
    
    @IBOutlet weak var startingAddress: UILabel!
    
    weak var delegate: manageAnnotations?
    var id = ""
    var currentLocation = CLLocationCoordinate2D()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func acceptRide(_ sender: Any) {
        print("Ride is acceptedBy the Driver")
        //let customAnnotation = self.annotation as! CustomPointAnnotation
        //let id = customAnnotation.autoID
        driverHandler.Instance.requestAccepted(passenId: id)
        driverHandler.Instance.updateCurrentDriverLocation(location: currentLocation)
        driverHandler.Instance.isRideAlive = true
        //setup protocol to let the driver vc know that the ride has been accepted delete all the annotations except the accepted one and change the icon.
        self.removeFromSuperview()
        driverHandler.Instance.obsereveRideAccepted()
    }
    
    @IBAction func cancelRide(_ sender: Any) {
       let selectedAnnotation = self.annotation
       self.delegate?.cancelRide(selectedAnnotation: selectedAnnotation!)
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, with: event)
        if hitView != nil {
            superview?.bringSubview(toFront: self)
        }
        return hitView
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let rect = self.bounds
        var isInside = rect.contains(point)
        if !isInside {
            for view in subviews {
                isInside = view.frame.contains(point)
                if isInside {
                    break
                }
            }
        }
        return isInside
    }
}
