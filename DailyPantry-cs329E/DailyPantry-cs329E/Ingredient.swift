//
//  Ingredient.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 11/1/22.
//

import UIKit

public class Ingredient: NSObject {
    let name: String
    let unit: String
    var amountAvailable: Int32
    let catagory: String
    
    init(name: String, unit: String, amountAvailable: Int32, catagory: String ) {
        self.name = name
        self.unit = unit
        self.amountAvailable = amountAvailable
        self.catagory = catagory
    }
}
