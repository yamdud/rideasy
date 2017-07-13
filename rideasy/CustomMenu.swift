//
//  CustomMenu.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 26/02/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class CustomMenu: UITableViewController {

    
    let passengerMenuDetail:[(menuITem: String,Icon: UIImage)] = [("TRACK RIDE",UIImage(named: "TrackRide")!),("RIDE DETAILS",UIImage(named: "RideDetails")!),("YOUR MILES",UIImage(named: "TrackMiles")!),("YOUR DETAILS",UIImage(named: "YourDetails")!),("CONTACT US",UIImage(named: "ContactUs")!)]
    let DriverMenuDetail:[(menuITem: String,Icon: UIImage)] = [("Home",UIImage(named: "TaxiTracking")!),("Home",UIImage(named: "TaxiTracking")!),("Home",UIImage(named: "TaxiTracking")!),("Home",UIImage(named: "TaxiTracking")!),("Home",UIImage(named: "TaxiTracking")!)]
    let AdminMenuDetail:[(menuITem: String,Icon: UIImage)] = [("Home",UIImage(named: "TaxiTracking")!),("Home",UIImage(named: "TaxiTracking")!),("Home",UIImage(named: "TaxiTracking")!),("Home",UIImage(named: "TaxiTracking")!),("Home",UIImage(named: "TaxiTracking")!)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight:CGFloat = UIScreen.main.bounds.height - 20.00
        let numberOfRow: CGFloat = CGFloat(passengerMenuDetail.count)
        return screenHeight/numberOfRow
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return passengerMenuDetail.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        // Configure the cell...
        let lable = cell.viewWithTag(1) as! UILabel
        lable.text = passengerMenuDetail[indexPath.row].menuITem
        let imageView = cell.viewWithTag(2) as! UIImageView
        imageView.image = passengerMenuDetail[indexPath.row].Icon
       
        return cell
    }


    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "TrackRide", sender: nil)
        case 1:
            performSegue(withIdentifier: "rideDetails", sender: nil)
        case 2:
            performSegue(withIdentifier: "yourMiles", sender: nil)
        case 3:
            performSegue(withIdentifier: "yourDetails", sender: nil)
        case 4:
            performSegue(withIdentifier: "ContactUs", sender: nil)
        default:
            print("Default")
        }
        
        }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "TrackRide"?:
            let vc = segue.destination as! UINavigationController
        case "rideDetails"?:
            let vc = segue.destination as! UINavigationController
        case "yourMiles"?:
            let vc = segue.destination as! UINavigationController
        case "yourDetails"?:
            let vc = segue.destination as! UINavigationController
        case "ContactUs"?:
            let vc = segue.destination as! UINavigationController
        default:
            print("Default")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
