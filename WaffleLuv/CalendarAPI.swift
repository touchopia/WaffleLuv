//
//  CalendarApi.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/6/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation

class CalendarAPI {
    
    typealias JSONDictionary = [String:AnyObject]
    
    typealias JSONArray = [JSONDictionary]
    
    let calendarIDs = [["37acdbblsoobtn4e8pdiiou0og":"Utah County Truck",
        "7le3v0i298umv73s6utg6mlgns":"Salt Lake County Truck #2",
        "vedof0bnd56tpg88ts26ri8tfs":"Salt Lake County Truck #1",
        "ljtm924o1d2i1rsvcasfifa8v0":"Davis / Weber Truck",
        "cv3ksjlpccbinsdskl03sje1uk":"St. George Truck",
        "a4qf72ifpil5ubisui5krs6o6s":"Arizona Truck"]]
    
    var eventsArray = [CalendarEvent]()
    
    let dateFormatter = NSDateFormatter()
    
    func fetchCalendars() {
        for calendar in calendarIDs {
            fetchCalendar(calendar)
        }
    }
    
    func fetchCalendar(calendar: [String:String]) {
        
        for (idString, truckName) in calendar {
            print("searching for \(truckName)")
            
            let urlString = "https://www.googleapis.com/calendar/v3/calendars/\(idString)@group.calendar.google.com/events?key=AIzaSyA6hNF8nwtP3iCRa72yFJIhWbjWUfw0rvw&maxResults=9999"
            
            if let url = NSURL(string: urlString) {
                let session = NSURLSession.sharedSession()
                
                let task = session.dataTaskWithURL(url, completionHandler: {
                    (data, response, error) -> () in
                    
                    if error != nil {
                        print("an error occured \(error)")
                    } else {
                        if let data = data {
                            do {
                                if let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONDictionary {
                                    
                                    if let items = dictionary["items"] as? JSONArray {
                                        for item in items {
                                            let event = CalendarEvent(dict: item)
                                            event.truckName = truckName
                                            //print(event.location)
                                            //print(event.startDate)
                                            DataStore.sharedInstance.addEvent(event)
                                        }
                                    } else {
                                        //print("cant parse dictionary")
                                    }
                                }
                            } catch {
                                //print("cant parse JSON")
                            }
                        }
                    }
                })
                task.resume()
                
            } else {
                //print("cant print data")
            }
        }
    }
}