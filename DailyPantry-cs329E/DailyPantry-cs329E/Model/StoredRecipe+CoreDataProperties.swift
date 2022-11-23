//
//  StoredRecipe+CoreDataProperties.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 11/22/22.
//
//

import Foundation
import CoreData


extension StoredRecipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoredRecipe> {
        return NSFetchRequest<StoredRecipe>(entityName: "StoredRecipe")
    }

    @NSManaged public var name: String?
    @NSManaged public var catagory: String?
    @NSManaged public var ingredient: NSSet?
    @NSManaged public var qty: NSSet?

}

// MARK: Generated accessors for ingredient
extension StoredRecipe {

    @objc(addIngredientObject:)
    @NSManaged public func addToIngredient(_ value: StoredIngredient)

    @objc(removeIngredientObject:)
    @NSManaged public func removeFromIngredient(_ value: StoredIngredient)

    @objc(addIngredient:)
    @NSManaged public func addToIngredient(_ values: NSSet)

    @objc(removeIngredient:)
    @NSManaged public func removeFromIngredient(_ values: NSSet)

}

// MARK: Generated accessors for qty
extension StoredRecipe {

    @objc(addQtyObject:)
    @NSManaged public func addToQty(_ value: StoredQty)

    @objc(removeQtyObject:)
    @NSManaged public func removeFromQty(_ value: StoredQty)

    @objc(addQty:)
    @NSManaged public func addToQty(_ values: NSSet)

    @objc(removeQty:)
    @NSManaged public func removeFromQty(_ values: NSSet)

}

extension StoredRecipe : Identifiable {

}
