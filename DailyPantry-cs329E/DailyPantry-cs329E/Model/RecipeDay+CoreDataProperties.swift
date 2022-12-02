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
    @NSManaged public var recipe: StoredRecipe?

}

extension RecipeDay : Identifiable {

}
