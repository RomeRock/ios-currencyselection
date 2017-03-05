//
//  HomeViewController.swift
//  CurrencySelection
//
//  Created by NDM on 2/28/17.
//  Copyright © 2017 Rome Rock. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, UIGestureRecognizerDelegate, CLLocationManagerDelegate {

    var titleLabel: UILabel!
    @IBOutlet var menuItem: UIBarButtonItem!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var sampleLabel: UILabel!
    @IBOutlet var currentCountryLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.revealViewController() != nil {
            menuItem.target = self.revealViewController()
            menuItem.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.revealViewController().panGestureRecognizer().delegate = self
        }
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.text = "MM: Currency Selection"
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOffset = CGSize(width: 0, height: 1)
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 0
        contentView.layer.cornerRadius = 2
        
        updateCurrency()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.updateCurrency), name: .updateCurrency, object: nil)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    
    @IBAction func useLocationButtonPressed(_ sender: Any) {
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        UserDefaults.standard.set("US", forKey: "countryCode")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .updateCurrency, object: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = (placemarks?[0])! as CLPlacemark
                self.displayLocationInfo(placemark: pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
        let countryCode:String = placemark.isoCountryCode!
        
        UserDefaults.standard.set(countryCode, forKey: "countryCode")
        UserDefaults.standard.synchronize()
        NotificationCenter.default.post(name: .updateCurrency, object: nil)
        if UserDefaults.standard.bool(forKey: "firstLoad") {
            UserDefaults.standard.set(false, forKey: "firstLoad")
            performSegue(withIdentifier: "currencySelection", sender: self)
        }
    }
    
    func updateCurrency() {
        var countryCode:String = "US"
        
        if UserDefaults.standard.object(forKey: "countryCode") != nil {
            countryCode = UserDefaults.standard.string(forKey: "countryCode")!
        }
        
        let country:Country = Country.getCountry(code: countryCode)
        
        sampleLabel.text = "100.00 \(country.currencyCode)"
        currentCountryLabel.text = "\(country.emojiSymbol) \(country.countryName) - \(country.currencyName)"
        
    }
    

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
