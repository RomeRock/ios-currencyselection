//
//  ResultsCountryTableController.swift
//  tipcalculator
//
//  Created by Rome Rock on 12/21/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit

class ResultsCountryTableController: BaseCountryTableViewController {

    // MARK: - Properties
    
    var filteredCountries = [Country]()
    
    var wordsSection = [String]()
    var wordsDict = [String: [Country]]()
    
    // MARK: - UITableViewDataSource
    
    func generateWordsDictionary() {
        wordsSection = [String]()
        wordsDict = [String: [Country]]()
        for country:Country in filteredCountries {
            let key = "\(country.countryName[country.countryName.startIndex])"
            let upper = key.uppercased()
            if var wordValue:[Country] = wordsDict[upper] {
                wordValue.append(country)
                wordsDict[upper] = wordValue
            } else {
                wordsDict[upper] = [country]
            }
        }
        
        wordsSection = [String](wordsDict.keys)
        wordsSection = wordsSection.sorted()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let wordKey = wordsSection[section]
        if let wordValues = wordsDict[wordKey] {
            return wordValues.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return wordsSection[section]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return wordsSection.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return wordsSection
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseCountryTableViewController.tableViewCellIdentifier)!
        
        
        let wordKey = wordsSection[indexPath.section]
        if let wordValue = wordsDict[wordKey] {
            let country = wordValue[indexPath.row]
            configureCell(cell as! CountryTableViewCell, forCountry: country)
            if UserDefaults.standard.object(forKey: "countryCode") != nil {
                let countryCode = UserDefaults.standard.string(forKey: "countryCode")!
                if countryCode == country.countryCode {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                }
            }
        }
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
}
