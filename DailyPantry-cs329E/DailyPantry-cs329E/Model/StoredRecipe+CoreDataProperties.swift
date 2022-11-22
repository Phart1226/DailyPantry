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

}

// MARK: Generated accessors for ingredent
extension StoredRecipe {

    @objc(addIngredentObject:)
    @NSManaged public func addToIngredient(_ value: StoredIngredient)

    @objc(removeIngredentObject:)
    @NSManaged public func removeFromIngredient(_ value: StoredIngredient)

    @objc(addIngredent:)
    @NSManaged public func addToInIngredient(_ values: NSSet)

    @objc(removeIngredent:)
    @NSManaged public func removeFromIngredient(_ values: NSSet)

}

extension StoredRecipe : Identifiable {

}
