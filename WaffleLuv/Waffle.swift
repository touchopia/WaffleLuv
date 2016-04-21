//
//  Waffle.swift
//  WaffleLuv
//
//  Created by Bronson Dupaix on 4/6/16.
//  Copyright © 2016 Bronson Dupaix. All rights reserved.
//

import Foundation

class Waffle {
    
    typealias JSONDictionary = [String:AnyObject]
    typealias JSONArray = [JSONDictionary]
    
    var name: String = ""
    var price: String = ""
    var description: String = ""
    var photo: String = ""
    var isSelected: Bool = false
    
    init() {
        
    }
    
    init(dict: JSONDictionary) {
        
        if let name = dict["name"] as? String {
            self.name = name
          //  print(name)
        } else {
            print("Coulndt parse name")
        }
        
        if let price = dict["price"] as? String {
            self.price = price
           // print(price)
        } else {
            print("couldnt parse price")
        }
        
        if let description = dict["description"] as? String {
            self.description = description
           // print(description)
        } else {
            print(" couldnt parse description")
        }
        
        if let photo = dict["photo"] as? String {
            self.photo = photo
           // print(photo)
        } else {
            print("couldnt parse photo")
        }
    }
}