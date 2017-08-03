//
//  yourMiles.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 22/03/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import Foundation

class yourMiles: UIViewController,UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var VoucherTable: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var selectedRow = IndexPath()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        VoucherTable.delegate = self
        VoucherTable.dataSource = self
        if revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedRow {
            return 190
        }
        else{
            return 90
        }
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //print
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! VoucherCellTableViewCell
        if selectedRow == indexPath {
            cell.showDetails()
        }
        else {
            cell.detailsView.isHidden = true
        }
        return cell
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = VoucherTable.cellForRow(at: indexPath) as! VoucherCellTableViewCell
        if selectedRow == indexPath {
            selectedRow = IndexPath()
            cell.hideDetails()
        }
        else{
             selectedRow = indexPath
            
            cell.showDetails()
        }
        
        VoucherTable.beginUpdates()
        VoucherTable.endUpdates()
        
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedRow = IndexPath()
        let cell = VoucherTable.cellForRow(at: indexPath) as! VoucherCellTableViewCell
        cell.detailsView.isHidden = true
        VoucherTable.beginUpdates()
        VoucherTable.endUpdates()
    }

}
