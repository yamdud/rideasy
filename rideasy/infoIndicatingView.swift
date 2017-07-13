//
//  infoIndicatingView.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 03/07/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class infoIndicatingView: UIView {

    let infoLabel = UILabel()
    let closeButton = UIButton(type: UIButtonType.custom) as UIButton
        override init(frame: CGRect) {
        super.init(frame: frame)
       setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
       
        infoLabel.frame = CGRect.zero
        //infoLabel.text = message
        infoLabel.textColor = UIColor.white
        infoLabel.font = UIFont(name: "Courier New", size: 15)
        
        self.addSubview(infoLabel)
        
        closeButton.frame = CGRect.zero
        closeButton.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeMessage(sender:)), for: .touchUpInside)
        self.addSubview(closeButton)
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        //constrainsts for info label 
        infoLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        infoLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -20).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
       //constraints for close button
        //setting
        closeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        let height = NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 33)
        let width = NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 33)
        closeButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        NSLayoutConstraint.activate([height,width])
    }
    
    func changeText(message: String){
        infoLabel.text = message
    }
    
    func closeMessage(sender: UIButton){
        self.removeFromSuperview()
    }

}
