//
//  errorIndicatingImageview.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 19/04/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class errorIndicatingImageview: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func ValidationErrorView(){
        self.backgroundColor =  UIColor(red: 217/255, green: 89/255, blue: 76/255, alpha: 1.0)
        self.alpha = 1.0
        self.shake()
    }
    
    func ValidationSuccessView(){
        self.backgroundColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        self.alpha = 0.5
    }
    
    func shake() {
            let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
            animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
            animationDuration = 0.5
            animation.values = [-20,20,-20,20,-10,10,-5,5,0]
            layer.add(animation, forKey: "shake")
        }

}
