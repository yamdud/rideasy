//
//  VoucherCellTableViewCell.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 23/03/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class VoucherCellTableViewCell: UITableViewCell {

    @IBOutlet weak var detailsView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func showDetails() {
    
        detailsView.isHidden = false
    }
    
    func hideDetails(){
        detailsView.isHidden = true 
    }
}
