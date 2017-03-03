//
//  BaseCountryTableViewController.swift
//  tipcalculator
//
//  Created by Rome Rock on 12/21/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit

class BaseCountryTableViewController: UITableViewController {

    // MARK: - Types
    
    static let nibName = "CountryTableViewCell"
    static let tableViewCellIdentifier = "cellID"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: BaseCountryTableViewController.nibName, bundle: nil)
        
        // Required if our subclasses are to use `dequeueReusableCellWithIdentifier(_:forIndexPath:)`.
        tableView.register(nib, forCellReuseIdentifier: BaseCountryTableViewController.tableViewCellIdentifier)
    }
    
    // MARK: - Configuration
    
    func configureCell(_ cell: CountryTableViewCell, forCountry country: Country) {
        cell.countryNameLabel.text = country.countryName.uppercased()
        cell.emojiFlagLabel.text = country.emojiSymbol
        cell.currencyNameLabel.text = country.currencyName.uppercased()
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
