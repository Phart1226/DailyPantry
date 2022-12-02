//
//  RecipeDay+CoreDataProperties.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 12/2/22.
//
//

import Foundation
import CoreData


extension RecipeDay {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecipeDay> {
        return NSFetchRequest<RecipeDay>(entityName: "RecipeDay")
    }

    @NSManaged public var date: String?
    @NSManaged public var recipe: NSSet?

}

// MARK: Generated accessors for recipe
extension RecipeDay {

    @objc(addRecipeObject:)
    @NSManaged public func addToRecipe(_ value: StoredRecipe)

    @objc(removeRecipeObject:)
    @NSManaged public func removeFromRecipe(_ value: StoredRecipe)

    @objc(addRecipe:)
    @NSManaged public func addToRecipe(_ values: NSSet)

    @objc(removeRecipe:)
    @NSManaged public func removeFromRecipe(_ values: NSSet)

}

extension RecipeDay : Identifiable {

}
