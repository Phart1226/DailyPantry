//
//  StoredQty+CoreDataProperties.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 11/22/22.
//
//

import Foundation
import CoreData


extension StoredQty {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredQty> {
        return NSFetchRequest<StoredQty>(entityName: "StoredQty")
    }

    @NSManaged public var qty: Double
    @NSManaged public var ingredientName: String?
    @NSManaged public var recipe: NSSet?

}

// MARK: Generated accessors for recipe
extension StoredQty {

    @objc(addRecipeObject:)
    @NSManaged public func addToRecipe(_ value: StoredRecipe)

    @objc(removeRecipeObject:)
    @NSManaged public func removeFromRecipe(_ value: StoredRecipe)

    @objc(addRecipe:)
    @NSManaged public func addToRecipe(_ values: NSSet)

    @objc(removeRecipe:)
    @NSManaged public func removeFromRecipe(_ values: NSSet)

}

extension StoredQty : Identifiable {

}
