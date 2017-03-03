//
//  CurrentLocationViewController.swift
//  CurrencySelection
//
//  Created by Rome Rock on 3/2/17.
//  Copyright © 2017 Rome Rock. All rights reserved.
//

import UIKit

class CurrentLocationViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var currentCountryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        updateCurrency()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CurrentLocationViewController.updateCurrency), name: .updateCurrency, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    @IBAction func okButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func updateCurrency() {
        var countryCode:String = "US"
        
        if UserDefaults.standard.object(forKey: "countryCode") != nil {
            countryCode = UserDefaults.standard.string(forKey: "countryCode")!
        }
        
        let country:Country = Country.getCountry(code: countryCode)
        
        currentCountryLabel.text = "\(country.emojiSymbol) \(country.countryName) - \(country.currencyName)"
        
    }
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch:UITouch? = touches.first
        let touchLocation = touch?.location(in: self.view)
        let contentViewFrame = self.view.convert(contentView.frame, from: contentView.superview)
        if !contentViewFrame.contains(touchLocation!) {
            dismiss(animated: true, completion: nil)
        }
        
    }
    */
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.destination is MainCountryTableViewController {
            let countries: [Country] = Country.getCountries()
            
            let destination:MainCountryTableViewController = segue.destination as! MainCountryTableViewController
            destination.countries = countries
        }
    }

}
