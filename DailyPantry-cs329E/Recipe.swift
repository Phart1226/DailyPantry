//
//  Recipe.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 10/31/22.
//

import UIKit

class Recipe: NSObject {
    var ingreidents: [Ingredient]
    var catagory: String

    
    init(ingreidents:[Ingredient], catagory:String) {
        self.ingreidents = ingreidents
        self.catagory = catagory

    }
}
