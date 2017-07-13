//
//  Register.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 28/03/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation

class Register: UIViewController{
    
    @IBOutlet weak var ContainerView: UIView!
   
    @IBOutlet weak var PassengerButton: UIButton!
    @IBOutlet weak var DriverButton: UIButton!
    var passengerView = UIViewController()
    var DriverView = UIViewController()
    var currentView = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
    }
    func initialSetup(){
        passengerView = (storyboard?.instantiateViewController(withIdentifier: "PassengerRegisterView"))!
        DriverView = (storyboard?.instantiateViewController(withIdentifier: "DriverRegisterView"))!
        loadInContainer(ToLoadView: passengerView)
    }
    
    func loadInContainer(ToLoadView: UIViewController){
        addChildViewController(ToLoadView)
        ContainerView.frame = (ToLoadView.view.frame)
        
        ContainerView.addSubview((ToLoadView.view)!)
        ToLoadView.didMove(toParentViewController: self)
        currentView = ToLoadView
    }
    func removeFromContainerview(toRemoveView: UIViewController){
        toRemoveView.willMove(toParentViewController: nil)
        toRemoveView.view.removeFromSuperview()
        toRemoveView.removeFromParentViewController()
    }
    @IBAction func PassengerButtonClicked(_ sender: Any) {
        if currentView != passengerView {
            PassengerButton.setImage(#imageLiteral(resourceName: "Passenger active"), for: .normal)
            DriverButton.setImage(#imageLiteral(resourceName: "Driver"), for: .normal)
            removeFromContainerview(toRemoveView: DriverView)
            loadInContainer(ToLoadView: passengerView)
        }
        
    }
    @IBAction func DriverButtonClicked(_ sender: Any) {
        if currentView != DriverView {
            DriverButton.setImage(#imageLiteral(resourceName: "Driver filled"), for: .normal)
            PassengerButton.setImage(#imageLiteral(resourceName: "Passenger"), for: .normal)
            removeFromContainerview(toRemoveView: passengerView)
            loadInContainer(ToLoadView: DriverView)
        }
    }
}
