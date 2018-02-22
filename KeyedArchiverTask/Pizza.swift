//
//  Pizza.swift
//  KeyedArchiverTask
//
//  Created by Robert Berry on 2/21/18.
//  Copyright © 2018 Robert Berry. All rights reserved.
//

import UIKit

class Pizza: NSObject, NSCoding {
    
    // MARK: Properties
    
    // Keys
    
    let pizzaSizeKey = "pizzaSize"
    let meatsKey = "meats"
    let veggiesKey = "veggies"
   
    let pizzaSize: String
    let meats: String
    let veggies: String
    
    init(pizzaSize: String, meats: String, veggies: String) {
        
        self.pizzaSize = pizzaSize
        self.meats = meats
        self.veggies = veggies
    }
    
    // Methods to conform to NSCoding
    
    // Method initializes the object from an NSCoder.
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let pizzaSize = aDecoder.decodeObject(forKey: "pizzaSize") as? String,
              let meats = aDecoder.decodeObject(forKey: "meats") as? String,
              let veggies = aDecoder.decodeObject(forKey: "veggies") as? String else { return nil }
        
        self.init(pizzaSize: pizzaSize, meats: meats, veggies: veggies)
    }
    
    // Method encodes the fields of the Pizza object.
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.pizzaSize, forKey: pizzaSizeKey)
        aCoder.encode(self.meats, forKey: meatsKey)
        aCoder.encode(self.veggies, forKey: veggiesKey)
    }
    
    // Method returns a string with the details of a pizza when called.
    
    override var description: String {
        
        return "Pizza Size: \(pizzaSize) Meats: \(meats) Veggies: \(veggies)"
    } 
}
