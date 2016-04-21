//
//  NaviTableViewController.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/5/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit

class NaviTableViewController: UITableViewController {
    
    var instaApi = Instagram()
    
    var calendarApi = CalendarAPI()
    
    var locationsView = LocationsViewController()
    
    @IBOutlet weak var waffleLoveImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        instaApi.fetchInstaPhotos()
 
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }
        
        reachability.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            dispatch_async(dispatch_get_main_queue()) {
                print("Not reachable")
                
                let alertController = UIAlertController(title: "No Internet Connection", message: "Please connect your device to the internet", preferredStyle: .Alert)
                let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
                
                alertController.addAction(action)
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }


    }

  

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 6
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 5 {
            
            return 600
        }
        
        return 40
    }
}
