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
    @IBOutlet weak var slideBtn: UIButton! 
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var callDriverButton: UIButton!
    @IBOutlet weak var cancelTaxiButton: UIButton!
    
    @IBOutlet weak var destinationAddressLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceImage: UIImageView!
    @IBOutlet weak var timeImage: UIImageView!
    @IBOutlet weak var costImage: UIImageView!
    
    
    var actualHeightforTimeApproxStackView: CGFloat = 0.0
    var actualHeightforSliderView: CGFloat = 0.0
    var isFormOpen = false
    
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
        
        //swipe gestures 
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeUp.direction = .up
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipe(_:)))
        swipeUp.direction = .down
        self.addGestureRecognizer(swipeUp)
        self.addGestureRecognizer(swipeDown)
        }
    func setupLabels(distance: Double, time: Double, cost: Double, destinationAddress: String){
        self.isHidden = false
        destinationAddressLabel.isHidden = true
        distanceLabel.text = String(distance) + " mi"
        timeLabel.text = String(time) + " min"
        costLabel.text = "£\(cost)"
        destinationAddressLabel.text = destinationAddress
    }
    
    func InfoViewSetup(option: String){
        
       print("Actual Height",actualHeightforSliderView,actualHeightforTimeApproxStackView)
        switch option {
        case "disTimein":
            let NewDisTimeHeight = self.DisTimeHeight.constraintWithMultiplier(multiplier: 0.60)
            let NewinfoViewHeight = self.infoViewHeight.constraintWithMultiplier(multiplier: 0.16)
            self.removeConstraint(DisTimeHeight)
            self.superview?.removeConstraint(infoViewHeight)
            self.infoViewHeight = NewinfoViewHeight
            self.DisTimeHeight = NewDisTimeHeight
            self.addConstraint(DisTimeHeight)
            //superview!.addConstraint(infoViewHeight)
            //self.view.addConstraints([infoViewHeight,DisTimeHeight])
            //self.addConstraint(infoViewHeight)
            self.superview?.addConstraint(infoViewHeight)
            
            
            
            self.timeImage.isHidden = true
            self.distanceImage.isHidden = true
            self.costImage.isHidden = true
            mainStackview.spacing = 5.0
            //animate
            //animate.AnimateInfoView(infoView: InfoView)
            if isFormOpen {
                self.timeApproxStackview.isHidden = false
                self.isHidden = false
                self.SliderView.isHidden = false
                Animation.Instance.slideDown(slideBtn: slideBtn,infoView: self,sliderView: SliderView)
                isFormOpen = false
            }
            else{
                self.callDriverButton.isHidden = true
                self.timeApproxStackview.isHidden = true
                self.isHidden = false
                self.SliderView.isHidden = true
                Animation.Instance.AnimateInfoView(infoView: self)
                isFormOpen = true
            }
            self.needsUpdateConstraints()
            self.layoutIfNeeded()
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
            
            
            self.destinationAddressLabel.isHidden = false
            self.mainStackview.spacing = 10.0
            self.destinationAddressLabel.isHidden = false
            self.isHidden = false
            self.timeImage.isHidden = false
            self.distanceImage.isHidden = false
            self.costImage.isHidden = false
            self.slideBtn.isHidden = false 
            self.needsUpdateConstraints()
            self.layoutIfNeeded()
            //animate.AnimateInfoView(infoView: InfoView)
            Animation.Instance.AnimateSliderWithButtons(DisTimeView: DisTimeview, timeProxStackView: timeApproxStackview, SliderView: SliderView, callDriver: callDriverButton ,infoView: self, SliderViewActualHeight: actualHeightforSliderView, approxtimeActualHeight: actualHeightforTimeApproxStackView)
            isFormOpen = true
            
            
           // Animation.Instance.animate(LocationFormView: LocationFormView, PopDownMenuView: PopDownMenuView, PaymentView: PaymentView, ApproxTotalLabel: ApproxTotalLabel, searchButton: searchButton)
        case "sliderOut":
            print("sliderOut")
        case "hideview":
            Animation.Instance.AnimateHideInfo(infoView: self)
            isFormOpen = false
            slideBtn.isHidden = true
            print("")
        default:
            //to do
            print("")
        }
    }
    
    func addSlideOutButton(){
        slideBtn.addTarget(self, action: #selector(self.slideUpInfoView(sender:)), for: UIControlEvents.touchUpInside)
    }
    func hideSlideOutButton(){

    }
    @IBAction func slideButtonPressed(_ sender: Any ){
        if isFormOpen {
            //Animation.Instance.slideDown(slideBtn: slideBtn, infoView: self)
            self.InfoViewSetup(option: "disTimein")
        }
        else{
            Animation.Instance.slideUp(slideBtn: slideBtn)
            self.InfoViewSetup(option: "sliderin")
        }
    }
    func slideUpInfoView(sender: UIButton){
        print("button pressed \(isFormOpen)")
        
        
    }
    //function to hanfle the swipe
    func handleSwipe(_ gesture : UIGestureRecognizer){
        //if isWaitingForRide {
            let swipe = gesture as! UISwipeGestureRecognizer
            if (swipe.direction == .up){
                self.InfoViewSetup(option: "sliderin")
                print("swipe up")
            }
            else if(swipe.direction == .down){
                self.InfoViewSetup(option: "disTimein")
            }
        
    }

}
