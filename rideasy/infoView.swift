//
//  infoView.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 02/05/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class infoView: UIView {

    @IBOutlet weak var mainStackview: UIStackView!
    @IBOutlet weak var infoViewHeight: NSLayoutConstraint!
    //Dis time Stack view
    @IBOutlet weak var DisTimeHeight: NSLayoutConstraint!
    @IBOutlet weak var DisTimeview: UIStackView!
    @IBOutlet weak var timeApproxStackview: UIStackView!
    
    //SliderStack View
    @IBOutlet weak var SliderView: UIStackView!
    @IBOutlet weak var TaxiTrackerSlider: Slider!
    //buttons
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var callDriverButton: UIButton!
    @IBOutlet weak var cancelTaxiButton: UIButton!
    
    @IBOutlet weak var destinationAddressLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    var actualHeightforTimeApproxStackView: CGFloat = 0.0
     var actualHeightforSliderView: CGFloat = 0.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initalSetup()
        
        
    }
    
    func initalSetup(){
        //hiding the view initially
        self.isHidden = true
        
        //getting the actual height of slider stack view and time and distance stack vuew
        actualHeightforTimeApproxStackView = timeApproxStackview.frame.height
        actualHeightforSliderView = SliderView.frame.height
        
        //setting the slider image to taxi
        let im = UIImage(named: "TaxiTracking")
        TaxiTrackerSlider.isUserInteractionEnabled = false
        TaxiTrackerSlider.setThumbImage( im , for: .normal)
//        TaxiTrackerSlider.addSubview(TaxiTrackerSlider.createTimeLabel())
        }
    func ShowView(distance: Double, time: Double, cost: Double, destinationAddress: String){
        self.isHidden = false
        destinationAddressLabel.isHidden = true
        distanceLabel.text = String(distance) + " mi"
        timeLabel.text = String(time) + " min"
        costLabel.text = "£\(cost)"
        destinationAddressLabel.text = destinationAddress
        //timeToDestinationLabel.text = String(self.ETA.roudto(places: 0)) + " min"
        
    }
    
    func InfoViewSetup(option: String){
        
       print("Actual Height",actualHeightforSliderView,actualHeightforTimeApproxStackView)
        switch option {
        case "disTimein":
            let NewDisTimeHeight = self.DisTimeHeight.constraintWithMultiplier(multiplier: 0.45)
            let NewinfoViewHeight = self.infoViewHeight.constraintWithMultiplier(multiplier: 0.13)
            self.removeConstraint(DisTimeHeight)
            self.superview?.removeConstraint(infoViewHeight)
            self.infoViewHeight = NewinfoViewHeight
            self.DisTimeHeight = NewDisTimeHeight
            self.addConstraint(DisTimeHeight)
            //superview!.addConstraint(infoViewHeight)
            //self.view.addConstraints([infoViewHeight,DisTimeHeight])
            //self.addConstraint(infoViewHeight)
            self.superview?.addConstraint(infoViewHeight)
            self.needsUpdateConstraints()
            self.layoutIfNeeded()
            self.timeApproxStackview.isHidden = true
            self.isHidden = false
            self.SliderView.isHidden = true
            self.callDriverButton.isHidden = true
            mainStackview.spacing = 5.0
            //animate
            //animate.AnimateInfoView(infoView: InfoView)
            Animation.Instance.AnimateInfoView(infoView: self)
            
        case "sliderin":
            //to do
            print("slider in: ")
            
            let NewDisTimeHeight = self.DisTimeHeight.constraintWithMultiplier(multiplier: 0.52)
            let NewinfoViewHeight = self.infoViewHeight.constraintWithMultiplier(multiplier: 0.48)
            self.removeConstraint(DisTimeHeight)
            self.superview?.removeConstraint(infoViewHeight)
            self.infoViewHeight = NewinfoViewHeight
            self.DisTimeHeight = NewDisTimeHeight
            self.addConstraint(DisTimeHeight)
            self.superview!.addConstraint(infoViewHeight)
            
            
            self.mainStackview.spacing = 10.0
            self.destinationAddressLabel.isHidden = false
            //animate.AnimateInfoView(infoView: InfoView)
            Animation.Instance.AnimateSliderWithButtons(DisTimeView: DisTimeview, timeProxStackView: timeApproxStackview, SliderView: SliderView, callDriver: callDriverButton ,infoView: self, SliderViewActualHeight: actualHeightforSliderView, approxtimeActualHeight: actualHeightforTimeApproxStackView)
            self.needsUpdateConstraints()
            self.layoutIfNeeded()
            
           // Animation.Instance.animate(LocationFormView: LocationFormView, PopDownMenuView: PopDownMenuView, PaymentView: PaymentView, ApproxTotalLabel: ApproxTotalLabel, searchButton: searchButton)
        case "hideview":
            Animation.Instance.AnimateHideInfo(infoView: self)
            print("")
        default:
            //to do
            print("")
        }
    }
    
    
    
}
