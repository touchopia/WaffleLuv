//
//  CalendarEvent.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/6/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation

class CalendarEvent {
    
    typealias JSONDictionary = [String:AnyObject]
    
    var location: String = ""
    var truckName: String = ""
    
    var startDate = NSDate()
    var endDate = NSDate()
    
    var latitiude: Double = 0.00
    var longitude: Double = 0.00
    
    var dateFormatter: NSDateFormatter = {
        var formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return formatter
    }()
    
    init(dict: JSONDictionary) {
        
        if let location = dict["location"] as? String {
            self.location = location
        } else {
            //print("Couldnt parse location")
        }
        
        if let startDate = dict["start"] as? JSONDictionary {
            if let dateString = startDate["dateTime"] as? String {
                if let date = dateFormatter.dateFromString(dateString) {
                    self.startDate = date
                } else {
                    print(" Couldnt convert string to date")
                }
            }
        } else {
            //print("Couldnt parse startDate")
        }
        
        if let endDate = dict["end"] as? JSONDictionary {
            
            if let endDateString = endDate["dateTime"] as? String {
                if let date = dateFormatter.dateFromString(endDateString) {
                    self.endDate = date
                }
            }
        } else {
            //print("Couldnt parse endDate")
        }
    }
}
