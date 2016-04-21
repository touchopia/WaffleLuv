//
//  AppDelegate.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/4/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let calAPI = CalendarAPI()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        calAPI.fetchCalendars()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {

    }

    func applicationDidEnterBackground(application: UIApplication) {

    }

    func applicationWillEnterForeground(application: UIApplication) {

    }

    func applicationDidBecomeActive(application: UIApplication) {
 
    }

    func applicationWillTerminate(application: UIApplication) {

    }


}

