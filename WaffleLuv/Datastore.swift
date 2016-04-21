//
//  Datastore.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/7/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation
import CoreLocation

class DataStore: NSObject {
    
    // DataStore is a Singleton
    static let sharedInstance = DataStore()
    private override init() {}
    
    var queue = [CalendarEvent]()
    var currentEventsArray = [CalendarEvent]()
    var instaPhotos = [InstaPhoto]()
    
    //MARK: - Events Functions
    
    func addEvent(event: CalendarEvent) {
        if event.location.isEmpty {
            return
        }
        
        if event.startDate.isToday() && !containedInArray(event) {
            
            // Add to temporary queue
            self.queue.append(event)
            
            // Add Lat/Long
            self.geocodeLocation(event)
        }
    }
    
    func containedInArray(event: CalendarEvent) -> Bool {
        for e in currentEventsArray {
            if event.location == e.location && event.startDate == e.startDate {
                return true
            }
        }
        return false
    }
    
    func numberOfEvents() -> Int {
        return self.currentEventsArray.count
    }
    
    func geocodeLocation(event: CalendarEvent)  {
        
        geocode(event.location)  {
            (latitude: Double, longitude: Double) in
            // update latitude and longitude
            event.latitiude = latitude
            event.longitude = longitude
            
            // Append to final array
            self.currentEventsArray.append(event)
            
            if self.currentEventsArray.count == self.queue.count {
                NSNotificationCenter.defaultCenter().postNotificationName("TRUCKS_FOUND", object: nil)
            }
            
            print("\n\n\(event.truckName)\n\(event.location)\n\(event.startDate.toShortTimeString())-\(event.endDate.toShortTimeString())\n\(event.latitiude),\(event.longitude)")
        }
    }
    
    func geocode(location: String, completion: (Double, Double) -> ()) {
        CLGeocoder().geocodeAddressString(location) { (placemarks, error) in
            if placemarks?.count > 0 {
                let placemark = placemarks?[0]
                let location = placemark!.location
                let coordinate = location?.coordinate
                completion((coordinate?.latitude)!, (coordinate?.longitude)!)
            }
        }
    }
}