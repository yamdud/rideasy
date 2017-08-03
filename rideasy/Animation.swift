//
//  Animation.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 07/02/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class Animation: CAAnimation {
    private static let _instance = Animation()
    
    static var Instance: Animation {
        return _instance
    }
    var ButtonStatus = false
    var paymentViewOpen = false
    
    func animate(LocationFormView: UIView , PopDownMenuView: UIView, PaymentView: UIView, ApproxTotalLabel: UILabel,searchButton: UIBarButtonItem){
        
        if ButtonStatus == false {
            LocationFormView.transform = CGAffineTransform.init(translationX: 0, y: -LocationFormView.frame.height)
        }
        UIView.animate(withDuration: 0.3, animations:{
            
            if self.ButtonStatus == false {
                PopDownMenuView.isHidden = false
                searchButton.image = UIImage(named: "close.png")
                self.ButtonStatus = true
                LocationFormView.transform = CGAffineTransform.identity
                
                
                PaymentView.alpha = 0
                LocationFormView.alpha = 1.0
                //self.PopDownMenuView.alpha = 1.0
            }
            else {
                searchButton.image = UIImage(named: "Search")
                self.ButtonStatus = false
                self.paymentViewOpen = false
                LocationFormView.transform = CGAffineTransform.init(translationX: 0, y: -LocationFormView.frame.height)
                PaymentView.transform = CGAffineTransform.init(translationX: 0, y: -PaymentView.frame.height - LocationFormView.frame.height)
                ApproxTotalLabel.text = ""
                PopDownMenuView.alpha = 1
            }
        }, completion: {(success:Bool) in
            print(self.ButtonStatus)
            print("sucess")
            if self.ButtonStatus != true {
                PopDownMenuView.isHidden = true
            }
            
        })
    }
    
    
    func AnimatePayment(paymentView : UIView){
        if paymentViewOpen == false {
            paymentView.transform = CGAffineTransform.init(translationX: 0, y: -paymentView.frame.height)
        
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                paymentView.transform = CGAffineTransform.identity
                paymentView.alpha = 1.0
                
            }, completion: {(success:Bool) in
                print("Sucess")
                self.paymentViewOpen = true
            })
        }
    }
    func AnimateInfoView(infoView: UIView){
        infoView.isHidden = false
        infoView.transform = CGAffineTransform.init(translationX: 0, y : +infoView.frame.height)
        UIView.animate(withDuration: 0.4, delay: 0.2, options: .curveEaseIn, animations: {
            infoView.transform = CGAffineTransform.identity
            infoView.alpha = 1.0
        }, completion: {(success: Bool) in
            
        })
    }
    func AnimateSliderWithButtons(DisTimeView:UIStackView, timeProxStackView: UIStackView,
                                  SliderView : UIStackView , callDriver: UIButton , infoView : UIView, SliderViewActualHeight: CGFloat, approxtimeActualHeight: CGFloat){
        
        //DisTimeView.alpha = 0.0
        SliderView.isHidden = false
        callDriver.isHidden = false
        //SliderView.alpha = 0.0
        //timeProxStackView.alpha = 0.0
        timeProxStackView.isHidden = false
        timeProxStackView.transform = CGAffineTransform.init(translationX: 0, y: +approxtimeActualHeight)
        SliderView.transform = CGAffineTransform.init(translationX: 0, y: +SliderViewActualHeight)
        callDriver.transform = CGAffineTransform.init(translationX: -100, y: 0)
        
        infoView.transform = CGAffineTransform.init(translationX: 0, y: +(SliderViewActualHeight + approxtimeActualHeight))
        print("approx height" , timeProxStackView.frame.height, SliderView.frame.height)
      
        UIView.animate(withDuration: 0.5, animations: {
           
            timeProxStackView.transform = CGAffineTransform.identity
            SliderView.transform = CGAffineTransform.identity
            callDriver.transform = CGAffineTransform.identity
            infoView.transform = CGAffineTransform.identity
           DisTimeView.alpha = 1.0
            SliderView.alpha = 1.0
            timeProxStackView.alpha = 1.0
        }, completion: {(success:Bool) in
            
        
        })
        
    }
    func AnimateHideInfo(infoView:UIView){
        UIView.animate(withDuration: 0.6, animations: {
            infoView.transform = CGAffineTransform.init(translationX: 0, y: infoView.frame.height)
        }, completion: {(success: Bool) in
            //infoView.alpha = 0.0
            infoView.isHidden = false
        })
        }
    
    func slideUp(slideBtn:UIButton){
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
            
           slideBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi * 2))
        }) { (success: Bool) in
            
        }
    }
    func slideDown(slideBtn: UIButton,infoView: UIView,sliderView: UIStackView){
         infoView.transform = CGAffineTransform.init(translationX: 0, y: 0)
        sliderView.alpha = 0.0
        UIView.animate(withDuration: 0.4,animations:  {
             slideBtn.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            sliderView.isHidden = true
           infoView.transform = CGAffineTransform.identity
            
        })
        
    }
}
