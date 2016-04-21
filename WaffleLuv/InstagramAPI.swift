//
//  InstagramAPI.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/11/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation

class Instagram {
    
    typealias JSONDictionary = [String:AnyObject]
    typealias JSONArray = [JSONDictionary]
    
    func fetchInstaPhotos() {
        
        print("Fetch photos called")
        let urlString = "https://www.instagram.com/waffluv/media/"
        
        
        if let url = NSURL(string: urlString)
        {
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url, completionHandler: {
                
                (data, response, error) -> () in
                
                if error != nil {
                    debugPrint("an error occured \(error)")
                }else {
                    
                    if let data = data {
                        
                        do {
                            
                            if let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? JSONDictionary {
                                
                                if let items = dictionary["items"] as? JSONArray {
                                    
                                    
                                    for item in items {
                                        
                                        if let images = item["images"] as? JSONDictionary{
                                            
                                            
                                            if let lowRes = images["low_resolution"] as? JSONDictionary {
                                                
                                                
                                                let photo = InstaPhoto.init(dict: lowRes)
                                                
                                                DataStore.sharedInstance.instaPhotos.append(photo)
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                }
                                
                                
                            } else {
                                debugPrint("cant parse dictionary")
                            }
                            
                        } catch {
                            
                            debugPrint("cant parse JSON")
                            
                        }
                    }
                }
                
            })
            
            task.resume()
            
        } else {
            debugPrint("cant print data")
        }
        
    }
    
}