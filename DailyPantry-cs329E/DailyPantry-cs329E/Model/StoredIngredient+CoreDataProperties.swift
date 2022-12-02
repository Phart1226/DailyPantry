//
//  StoredIngredient+CoreDataProperties.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 11/22/22.
//
//

import Foundation
import CoreData


extension StoredIngredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredIngredient> {
        return NSFetchRequest<StoredIngredient>(entityName: "StoredIngredient")
    }

    @NSManaged public var name: String?
    @NSManaged public var catagory: String?
    @NSManaged public var amountAvailable: Int16
    @NSManaged public var recipe: StoredRecipe?

}

extension StoredIngredient : Identifiable {

}
