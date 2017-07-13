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
    
    
    func AnimatePayment(PaymentView : UIView){
        if paymentViewOpen == false {
            PaymentView.transform = CGAffineTransform.init(translationX: 0, y: -PaymentView.frame.height)
        
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
                PaymentView.transform = CGAffineTransform.identity
                PaymentView.alpha = 1.0
                
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
        
        timeProxStackView.isHidden = false
        SliderView.isHidden = false
        callDriver.isHidden = false
        SliderView.alpha = 0.0
        timeProxStackView.alpha = 0.0
        DisTimeView.alpha = 1.0
        timeProxStackView.transform = CGAffineTransform.init(translationX: 0, y: +approxtimeActualHeight)
        SliderView.transform = CGAffineTransform.init(translationX: 0, y: +SliderViewActualHeight)
        callDriver.transform = CGAffineTransform.init(translationX: -100, y: 0)
        
        infoView.transform = CGAffineTransform.init(translationX: 0, y: +(SliderViewActualHeight + approxtimeActualHeight))
        print("approx height" , timeProxStackView.frame.height, SliderView.frame.height)
      
        UIView.animate(withDuration: 0.8, animations: {
           
            timeProxStackView.transform = CGAffineTransform.identity
            SliderView.transform = CGAffineTransform.identity
            callDriver.transform = CGAffineTransform.identity
            infoView.transform = CGAffineTransform.identity
            SliderView.alpha = 1.0
            timeProxStackView.alpha = 1.0
        }, completion: {(success:Bool) in
            
        
        })
    }
    func AnimateHideInfo(infoView:UIView){
        UIView.animate(withDuration: 0.5, animations: {
            infoView.transform = CGAffineTransform.init(translationX: 0, y: -infoView.frame.height)
            infoView.alpha = 0.0
            infoView.isHidden = true
        })
    }
}
