//
//  CustomCell.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 02/03/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var contentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.5
        contentView.layer.shadowOffset = CGSize(width: -1, height: 1)
        contentView.layer.shadowRadius = 1
        
        contentView.layer.shadowPath = UIBezierPath(rect: contentView.bounds).cgPath
        contentView.layer.shouldRasterize = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
