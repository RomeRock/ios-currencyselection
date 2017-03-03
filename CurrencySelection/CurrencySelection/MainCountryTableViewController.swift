//
//  MainCountryTableViewController.swift
//  tipcalculator
//
//  Created by Rome Rock on 12/21/16.
//  Copyright © 2016 Rome Rock. All rights reserved.
//

import UIKit

class MainCountryTableViewController: BaseCountryTableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    // MARK: - Types
    
    /// State restoration values.
    enum RestorationKeys : String {
        case viewControllerTitle
        case searchControllerIsActive
        case searchBarText
        case searchBarIsFirstResponder
    }
    
    struct SearchControllerRestorableState {
        var wasActive = false
        var wasFirstResponder = false
    }
    
    // MARK: - Properties
    
    /// Data model for the table view.
    var countries = [Country]()
    
    /*
     The following 2 properties are set in viewDidLoad(),
     They an implicitly unwrapped optional because they are used in many other places throughout this view controller
     */
    
    /// Search controller to help us with filtering.
    var searchController: UISearchController!
    
    /// Secondary search results table view.
    var resultsTableController: ResultsCountryTableController!
    
    /// Restoration state for UISearchController
    var restoredState = SearchControllerRestorableState()
    
    var rigthButton:UIBarButtonItem!
    
    var leftButton:UIBarButtonItem!
    
    var titleLabel:UILabel!
    
    var wordsSection = [String]()
    var wordsDict = [String: [Country]]()
    
    // MARK: - View Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultsTableController = ResultsCountryTableController()
        
        // We want to be the delegate for our filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        resultsTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        //tableView.tableHeaderView = searchController.searchBar
        
        let btnRigthMenu: UIButton = UIButton()
        btnRigthMenu.setImage(UIImage(named: "ic_search"), for: UIControlState.normal)
        btnRigthMenu.addTarget(self, action: #selector(MainCountryTableViewController.addSearchBar), for: UIControlEvents.touchUpInside)
        btnRigthMenu.frame = CGRect(x:0, y:0, width:22, height:22)
        rigthButton = UIBarButtonItem(customView: btnRigthMenu)
        
        self.navigationItem.rightBarButtonItem = rigthButton
        
        let btnLeftMenu: UIButton = UIButton()
        btnLeftMenu.setImage(UIImage(named: "ic_back"), for: UIControlState.normal)
        btnLeftMenu.addTarget(self, action: #selector(MainCountryTableViewController.onClickBack), for: UIControlEvents.touchUpInside)
        btnLeftMenu.frame = CGRect(x:0, y:0, width:22, height:17)
        leftButton = UIBarButtonItem(customView: btnLeftMenu)
        self.navigationItem.leftBarButtonItem = leftButton
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "Select currency"
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        self.navigationItem.backBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = true // default is YES
        self.searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        searchController.searchBar.tintColor = UIColor.white
        self.tableView.sectionIndexColor = UIColor(hex: "0288D1")
        
        /*
         Search is now just presenting a view controller. As such, normal view controller
         presentation semantics apply. Namely that presentation will walk up the view controller
         hierarchy until it finds the root view controller or one that defines a presentation context.
         */
        definesPresentationContext = true
        generateWordsDictionary()
    }
    
    func generateWordsDictionary() {
        for country:Country in countries {
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
    
    func addSearchBar() {
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.becomeFirstResponder()
    }
    func onClickBack()
    {
        _ = navigationController?.popViewController(animated: true)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Restore the searchController's active state.
        if restoredState.wasActive {
            searchController.isActive = restoredState.wasActive
            restoredState.wasActive = false
            
            if restoredState.wasFirstResponder {
                searchController.searchBar.becomeFirstResponder()
                restoredState.wasFirstResponder = false
            }
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchControllerDelegate
    
    func presentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(__FUNCTION__).")
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //debugPrint("UISearchControllerDelegate invoked method: \(#function).")
        self.navigationItem.rightBarButtonItem = rigthButton
        self.navigationItem.leftBarButtonItem = leftButton
        self.navigationItem.titleView = titleLabel
        tableView.reloadData()
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = countries
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        // Build all the "AND" expressions for each value in the searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in
            // Each searchString creates an OR predicate for: name, yearIntroduced, introPrice.
            //
            // Example if searchItems contains "iphone 599 2007":
            //      name CONTAINS[c] "iphone"
            //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
            //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
            //
            var searchItemsPredicate = [NSPredicate]()
            
            // Below we use NSExpression represent expressions in our predicates.
            // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value).
            
            // Name field matching.
            let titleExpression = NSExpression(forKeyPath: "countryName")
            let searchStringExpression = NSExpression(forConstantValue: searchString)
            
            let titleSearchComparisonPredicate = NSComparisonPredicate(leftExpression: titleExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
            
            let currencyExpression = NSExpression(forKeyPath: "currencyName")
            //let searchStringExpression = NSExpression(forConstantValue: searchString)
            
            let currencySearchComparisonPredicate = NSComparisonPredicate(leftExpression: currencyExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
            
            searchItemsPredicate.append(titleSearchComparisonPredicate)
            searchItemsPredicate.append(currencySearchComparisonPredicate)
            
            
            // Add this OR predicate to our master AND predicate.
            let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:searchItemsPredicate)
            
            return orMatchPredicate
        }
        
        // Match up the fields of the Product object.
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        // Hand over the filtered results to our search results table.
        let resultsController = searchController.searchResultsController as! ResultsCountryTableController
        resultsController.filteredCountries = filteredResults
        resultsController.generateWordsDictionary()
        resultsController.tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: BaseCountryTableViewController.tableViewCellIdentifier, for: indexPath)
        let wordKey = wordsSection[indexPath.section]
        if let wordValue = wordsDict[wordKey] {
            let country = wordValue[indexPath.row]
            configureCell(cell as! CountryTableViewCell, forCountry: country)
            if UserDefaults.standard.object(forKey: "countryCode") != nil {
                let countryCode = UserDefaults.standard.string(forKey: "countryCode")!
                if countryCode == country.countryCode {
                    tableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
                }
            }
        }
        
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedCountry: Country? = nil
        
        // Check to see which table view cell was selected.
        if tableView === self.tableView {
            let wordKey = wordsSection[indexPath.section]
            if let wordValue = wordsDict[wordKey] {
                selectedCountry = wordValue[indexPath.row]
            }
        }
        else {
            let wordKey = resultsTableController.wordsSection[indexPath.section]
            if let wordValue = resultsTableController.wordsDict[wordKey] {
                selectedCountry = wordValue[indexPath.row]
            }
        }
        UserDefaults.standard.set(selectedCountry?.countryCode, forKey: "countryCode")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .updateCurrency, object: nil)
        print((selectedCountry?.currencyCode)! as String)
        onClickBack()
    }
    
    // MARK: - UIStateRestoration
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        
        // Encode the view state so it can be restored later.
        
        // Encode the title.
        coder.encode(navigationItem.title!, forKey:RestorationKeys.viewControllerTitle.rawValue)
        
        // Encode the search controller's active state.
        coder.encode(searchController.isActive, forKey:RestorationKeys.searchControllerIsActive.rawValue)
        
        // Encode the first responser status.
        coder.encode(searchController.searchBar.isFirstResponder, forKey:RestorationKeys.searchBarIsFirstResponder.rawValue)
        
        // Encode the search bar text.
        coder.encode(searchController.searchBar.text, forKey:RestorationKeys.searchBarText.rawValue)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        
        // Restore the title.
        guard let decodedTitle = coder.decodeObject(forKey: RestorationKeys.viewControllerTitle.rawValue) as? String else {
            fatalError("A title did not exist. In your app, handle this gracefully.")
        }
        title = decodedTitle
        
        // Restore the active state:
        // We can't make the searchController active here since it's not part of the view
        // hierarchy yet, instead we do it in viewWillAppear.
        //
        restoredState.wasActive = coder.decodeBool(forKey: RestorationKeys.searchControllerIsActive.rawValue)
        
        // Restore the first responder status:
        // Like above, we can't make the searchController first responder here since it's not part of the view
        // hierarchy yet, instead we do it in viewWillAppear.
        //
        restoredState.wasFirstResponder = coder.decodeBool(forKey: RestorationKeys.searchBarIsFirstResponder.rawValue)
        
        // Restore the text in the search field.
        searchController.searchBar.text = coder.decodeObject(forKey: RestorationKeys.searchBarText.rawValue) as? String
    }
}
