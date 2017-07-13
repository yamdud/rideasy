//
//  CustomTableViewForRideDetails.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 03/03/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit
import MapKit
class CustomTableViewForRideDetails: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var shadowView: ShadowView!
    @IBOutlet weak var ExpandView: UIView!
    @IBOutlet weak var DateOfTravel: UILabel!
    @IBOutlet weak var bodyStackview: UIStackView!
    @IBOutlet weak var MainStackView: UIStackView!
    @IBOutlet weak var bodyViewHeight:NSLayoutConstraint!
    @IBOutlet weak var ExpandViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var dateOfTravelLabel: UILabel!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var DestinationLabel: UILabel!
    @IBOutlet weak var Costabel: UILabel!
    @IBOutlet weak var DistanceLabel: UILabel!
    
    
    var fareBreakDown = UIViewController()
    var ContainerView = UIView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setupCell(){
        mainView.layer.cornerRadius = 8
        mainView.layer.masksToBounds = true
        shadowView.layer.cornerRadius = 8
        shadowView.layer.masksToBounds = false
    }
    
    func nonSelectedCell(){
        cancelButton.isHidden = true
        MainStackView.isHidden = false
        ContainerView.removeFromSuperview()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func expand(cell : CustomTableViewForRideDetails, storyboard: UIStoryboard){
        MainStackView.isHidden = true
        cancelButton.isHidden = false
  
        //let ContainerView = UIView()
        //ContainerView.backgroundColor = UIColor.red
        ContainerView.frame = CGRect(origin: CGPoint(x: cell.frame.origin.x, y: cell.mainView.frame.origin.y - 10  ), size: CGSize(width: cell.frame.width - 40 ,height: cell.frame.height - 20))
        
        
        //if (fareBreakDown == nil){
        fareBreakDown = storyboard.instantiateViewController(withIdentifier: "RideDetailsFareBreakDown")
        //addChildViewController(fareBreakDown)
        //}
        
        fareBreakDown.view.frame = ContainerView.frame
        ContainerView.addSubview(fareBreakDown.view)
        cell.mainView.addSubview(ContainerView)
       
        
        print("containerView", ContainerView.frame, "farebreakdownView",fareBreakDown.view.frame)
    }
}



class ShadowView: UIView {
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
            print("didSet shadowView's width to: \(self.bounds.width)\n")
        }
    }
    
    private func setupShadow() {
        self.translatesAutoresizingMaskIntoConstraints = false 
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 3
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
