//
//  HomeViewController.swift
//  CurrencySelection
//
//  Created by NDM on 2/28/17.
//  Copyright © 2017 Rome Rock. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    var titleLabel: UILabel!
    @IBOutlet var menuItem: UIBarButtonItem!
    @IBOutlet var contentView: UIView!
    
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
        contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
        contentView.layer.shadowOpacity = 0.4
        contentView.layer.shadowRadius = 3
        contentView.layer.cornerRadius = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
