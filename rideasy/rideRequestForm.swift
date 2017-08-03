//
//  rideRequestForm.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 03/05/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit
import GooglePlaces

class rideRequestForm: UIView {

    @IBOutlet weak var LocationFormView: UIView!
    @IBOutlet weak var LocationFormStackView: UIStackView!
    @IBOutlet weak var PaymentView: UIView!
    @IBOutlet weak var StartingPointTextBox: UITextField!
    @IBOutlet weak var DestinationTextView: UITextField!
    @IBOutlet weak var ApproxTotalLabel: UILabel!
    @IBOutlet weak var formButton: UIButton!
    
    var AutoCompleteTable = UITableView()
    var fetcher: GMSAutocompleteFetcher?
    var activeTextBox = UITextField()
    var AutoCompleteArray:[[String]] = [["", ""]]
    
    
   // let autoCompleteTable = AutoCompleteTable(autoCompleteArray: AutoCompleteArray, SelectedTextBox: activeTextBox)

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        //let autoCompleteTable = AutoCompleteTable(autoCompleteArray: AutoCompleteArray, SelectedTextBox: activeTextBox)
    }
    
    func initialSetup(){
        self.alpha = 1.0
        LocationFormView.alpha = 0.0
        PaymentView.alpha = 0.0
        self.isHidden = true
        self.isUserInteractionEnabled = false
        formButton.alpha = 0.0
        StartingPointTextBox.text = ""
        DestinationTextView.text = ""
    }
    
    
    func placeAutocomplete(text: String) {
        
        //getting the visible map area
        //let visibleRegion = self.MapView.visibleMapRect
        //let bounds = GMSCoordinateBounds(coordinate: edgePoints().ne,coordinate: edgePoints().sw)
        //set the filter to no filter in order to get the addressess for all the location
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        filter.country = "uk"
        
        GMSPlacesClient.shared().autocompleteQuery(text, bounds: nil, filter: filter, callback: {
            (results, error) -> Void in
            guard error == nil else {
                
                print("Autocomplete error \(error)")
                return
            }
            if let results = results {
                //self.AutoCompleteArray.removeAll()
                for result in results {
                    
                    
                    self.AutoCompleteArray.insert([result.attributedFullText.string , result.placeID!], at: 0)
                    print("complete address: ", self.AutoCompleteArray)
                    
                }
                
            }
            
            self.AutoCompleteTable.reloadData()
           // autoCompleteTable.
        })
    }
    func clearForm(){
       
    }

//    func createTable(view: UIView)  {
//        print("We here")
//        let screenSize = UIScreen.main.bounds.size
//        let tableView = UITableView(frame: CGRect(x: view.frame.origin.x, y: activeTextBox.frame.origin.y + /*LocationFormStackView.frame.height +*/ 12, width: screenSize.width, height: 300))
//        
//        tableView.dataSource = self as! UITableViewDataSource
//        tableView.delegate = self as! UITableViewDelegate
//        tableView.rowHeight = 30
//        tableView.isHidden = true
//        tableView.separatorStyle = .none
//        tableView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        view.addSubview(tableView)
//        AutoCompleteTable = tableView
//        AutoCompleteTable.isHidden = false
//    }
//
//
//    func showTable(SelectedTextBox : UITextField){
//        let Table = AutoCompleteTable(autoCompleteArray: AutoCompleteArray, SelectedTextBox: SelectedTextBox)
//        print("we here in showtable: \(AutoCompleteArray)")
//    }
//   
   
}

//class AutoCompleteTable: UITableViewController {
//    private var AutoCompleteArray:[[String]] = [["", ""]]
//    private var selectedTextBox = UITextField()
//    var ACtable = UITableView()
//    
//    init(autoCompleteArray: [[String]], SelectedTextBox: UITextField){
//        super.init(style: .plain)
//        self.AutoCompleteArray = autoCompleteArray
//        self.selectedTextBox = SelectedTextBox
//        createTable()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //createTable()
//        
//    }
//    
//    
//        func refreshTable(){
//        self.ACtable.reloadData()
//    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        print("the total number of address",AutoCompleteArray.count)
//        return AutoCompleteArray.count
//            }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.backgroundColor = UIColor.clear
//        cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 16.0)
//        cell.textLabel?.textColor = UIColor.black
//        cell.textLabel?.text = AutoCompleteArray[indexPath.row][0]
//        return cell
//    }
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //dissmiss table
//        ACtable.isHidden = true
//        
//        //setting the textbox text to the selected address
//        self.selectedTextBox.text = AutoCompleteArray[indexPath.row][0]
//        //getting the place id to find the coordinates
//        //findCoordinates(PlID: AutoCompleteArray[indexPath.row][1])
//        AutoCompleteArray.removeAll()
//    }
//    
//    
//    
//    
//}
