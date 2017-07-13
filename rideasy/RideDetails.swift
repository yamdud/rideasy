//
//  RideDetails.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 28/02/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation


class RideDetails:UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var RideTableView: UITableView!
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    @IBOutlet weak var HeaderView: UIView!
    
    let searchbar = UISearchController(searchResultsController: nil)
    //var fareBreakDown = UIViewController()
   // var filteredRide = [Ride]()
    
    var SelectedRow:IndexPath? = nil
    var searchopen = false
    //@IBOutlet weak var contentView: UIView!
    
    var Rides = [
                Ride(dateOfTravel : "10 Jan 2016",origin: "Perth College Tesco", Destination: "Perth Bus Station",cost: "12.00", Distance: "1.8"),
                Ride(dateOfTravel : "10 Sept 2016",origin: "playhouse, Perth", Destination: "Perth Railway station", cost: "08.00", Distance: "2.8"),
                Ride(dateOfTravel : "12 Feb 2017",origin: "256 Crieff Road Tesco", Destination: "Perth college", cost: "15.00", Distance: "2.2"),
                Ride(dateOfTravel : "10 Mar 2017",origin: "12/21 Jenfield Road", Destination: "16 atholl Street", cost: "22.00", Distance: "2.0"),
                Ride(dateOfTravel : "21 Nov 2016",origin: "21 South methven street", Destination: "Perth Bus Station", cost: "15.00", Distance: "1.6"),
                Ride(dateOfTravel : "02 Dec 2016",origin: "21 South methven street", Destination: "Perth Bus Station", cost: "11.00", Distance: "5.8"),
                Ride(dateOfTravel : "07 Sept 2016",origin: "Crieff Road Tesco", Destination: "Perth Bus Station", cost: "14.00", Distance: "7.8"),
                Ride(dateOfTravel : "10 Sept 2016",origin: "Crieff Road Tesco", Destination: "Bus Station", cost: "16.00", Distance: "8.8"),
                Ride(dateOfTravel : "10 Oct 2016",origin: "Crieff Road Tesco", Destination: "21 South methven street", cost: "20.00", Distance: "2.8"),]
    
    var filteredRide = [Ride]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchbar.searchBar.delegate = self
        searchbar.searchResultsUpdater = self
        searchbar.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        HeaderView.addSubview(searchbar.searchBar)
        searchbar.isActive = false
        searchbar.searchBar.isHidden = true
        RideTableView.tableHeaderView?.backgroundColor = UIColor.clear
       
        if revealViewController() != nil {
            MenuButton.target = self.revealViewController()
            MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if SelectedRow != nil && SelectedRow?.row == indexPath.row {
            return 450
        }
        else {
            return 190.00
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchbar.isActive && searchbar.searchBar.text != nil {
            return filteredRide.count
        }
        else{
            return Rides.count
        }
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if searchopen == true {
            return 30.00
        }
        else{
            return 0.00
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewForRideDetails
        
        cell.setupCell()
        if searchbar.isActive && searchbar.searchBar.text != nil {
                cell.dateOfTravelLabel.text = filteredRide[indexPath.row].dateOfTravel
                cell.originLabel.text = filteredRide[indexPath.row].origin
                cell.DestinationLabel.text = filteredRide[indexPath.row].Destination
                cell.Costabel.text = filteredRide[indexPath.row].cost
                cell.DistanceLabel.text = filteredRide[indexPath.row].Distance
        }
        else {
            cell.dateOfTravelLabel.text = Rides[indexPath.row].dateOfTravel
            cell.originLabel.text = Rides[indexPath.row].origin
            cell.DestinationLabel.text = Rides[indexPath.row].Destination
            cell.Costabel.text = Rides[indexPath.row].cost
            cell.DistanceLabel.text = Rides[indexPath.row].Distance
        }
        if indexPath == SelectedRow {
            cell.MainStackView.isHidden = true
            cell.expand(cell: cell, storyboard : storyboard!)
        }
        else{
            cell.nonSelectedCell()
        }
        
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          //let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewForRideDetails
        SelectedRow = indexPath
        print(SelectedRow)
        let cell = tableView.cellForRow(at: SelectedRow!) as! CustomTableViewForRideDetails
        print(cell)
        tableView.beginUpdates()
        cell.expand(cell: cell, storyboard: storyboard!)
        tableView.endUpdates()
        cell.cancelButton.addTarget(self, action: Selector("closeView"), for: .touchUpInside)
        
    }
    func Searchfilter(searchText: String){
        filteredRide = Rides.filter { Ride in
            return Ride.origin.lowercased().contains(searchText.lowercased())
        }
        print(filteredRide)
        RideTableView.reloadData()
    }
    func closeView(){
        
      let cell = tableView.cellForRow(at: SelectedRow!) as! CustomTableViewForRideDetails
        cell.nonSelectedCell()
        self.tableView.beginUpdates()
        SelectedRow = nil
        self.tableView.endUpdates()
        
    }
    
    @IBAction func OpenSearchBar(_ sender: UIBarButtonItem) {
        searchopen = true
        searchbar.searchBar.backgroundImage = UIImage()
        searchbar.searchBar.barTintColor = UIColor(red: 63/255, green: 94/255, blue: 90/255, alpha: 1)
        searchbar.searchBar.backgroundColor = UIColor.clear
        self.searchbar.searchBar.isHidden = false
        self.searchbar.isActive = true
        self.searchbar.searchBar.text = ""


        print(RideTableView.tableHeaderView?.frame.height)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchopen = false
        self.searchbar.isActive = false
        self.searchbar.searchBar.isHidden = true
        print(RideTableView.tableHeaderView?.frame.height)
        print(searchbar.searchBar.frame)
        RideTableView.reloadData()
    }
    
    
    
    
}
extension RideDetails: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        Searchfilter(searchText: searchController.searchBar.text!)
    }
   
}
