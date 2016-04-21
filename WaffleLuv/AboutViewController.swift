//
//  AboutViewController.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/5/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var navButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            navButton.target = self.revealViewController()
            navButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }


    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        if indexPath.section == 0 {
        
        let firstCell = tableView.dequeueReusableCellWithIdentifier("FirstCell")
        
        return firstCell!
        }
        
        if indexPath.section == 1 {
            
            
            let secondCell = tableView.dequeueReusableCellWithIdentifier("SecondCell")
            
            return secondCell!
        }
        
        if indexPath.section == 2 {
            
            let thirdCell = tableView.dequeueReusableCellWithIdentifier("ThirdCell")
            
            return thirdCell! 
        }
        
        if indexPath.section == 3 {
            
            
            let fourthCell = tableView.dequeueReusableCellWithIdentifier("FourthCell")
            
            return fourthCell!
        }
        return cell 
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            
            return 650
        }
        
        if indexPath.section == 1 {
            
            
            return 500
        }
        
        if indexPath.section == 2 {
            
            return 400
            
        }
        
        if indexPath.section == 3 {
            
            return 650
        }
        
        return 30 
    }

}
