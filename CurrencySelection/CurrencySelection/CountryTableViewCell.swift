//
//  CountryTableViewCell.swift
//  tipcalculator
//
//  Created by Rome Rock on 12/21/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet var emojiFlagLabel: UILabel!
    @IBOutlet var selectedView: UIView!
    @IBOutlet var countryNameLabel: UILabel!
    @IBOutlet var currencyNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            selectedView.backgroundColor = UIColor(hex: "0288D1")
        } else {
            selectedView.backgroundColor = UIColor.white
        }
        // Configure the view for the selected state
    }

}
