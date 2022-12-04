//
//  RecipeViewController.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 10/31/22.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var ingredientsTableView: UITableView!

    var delegate: UIViewController!
    var recipe: NSManagedObject!
    var date:Date!
    var today:Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        date = datePicker.date
        today = datePicker.date
        
        recipeLabel.text = (recipe.value(forKey: "name") as! String)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ingredients = recipe.value(forKey: "ingredient") as! NSSet
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        let ingredients = recipe.value(forKey: "ingredient") as! NSSet
        let qtyArry = (recipe.value(forKey: "qty") as! NSSet).allObjects
        let ingredient = ingredients.allObjects[indexPath.row] as! NSManagedObject
        let ingredientName = (ingredient.value(forKey: "name") as! String)
        let qtyIndex = qtyArry.firstIndex(where: {($0 as! StoredQty).ingredientName! == ingredientName})
        let qty = (qtyArry[qtyIndex!] as! StoredQty).qty
        
        
        cell.textLabel?.text = ingredientName
        cell.detailTextLabel?.text = String(qty)
    

        return cell
        
    }

    @IBAction func datePickerValueChanged(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        date = datePicker.date
    }
    
    @IBAction func addToDayButtonPressed(_ sender: Any) {
        if date >= today {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            let formattedDate = formatter.string(from: date)
            
            let dates = retrieveDates()
            
            var recipeDate:RecipeDate!
            
            for i in dates{
                if i.value(forKey: "date") as? String == formattedDate {
                    recipeDate = i as? RecipeDate
                }
            }
            if recipeDate == nil {
                recipeDate = RecipeDate(context: context)
                recipeDate.date = formattedDate
                recipeDate.recipe = [recipe!]
            } else {
                recipeDate.recipe = recipeDate.recipe?.adding(recipe!) as NSSet?
            }
            
            let date = NSEntityDescription.insertNewObject(forEntityName: "RecipeDate", into: context)
            
            date.setValue(formattedDate, forKey: "date")
            date.setValue((recipe.value(forKey: "name") as! String), forKey: "recipeName")
            
            saveContext()
        }
    }
    
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func retrieveDates() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeDate")
        var fetchedResults:[NSManagedObject]? = nil
        
        do {
            try fetchedResults = context.fetch(request) as? [NSManagedObject]
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        return(fetchedResults)!
    }
    
    func clearCoreData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "RecipeDate")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                    print("\(result.value(forKey: "date")!) has been deleted")
                }
            }
            saveContext()
            
        } catch {
            // if an error occurs
            let nserror = error as NSError
            NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
            abort()
        }
        
    }


}

extension NSManagedObject {
    func addObject(value: NSManagedObject, forKey key: String) {
        let items = self.mutableSetValue(forKey: key)
        items.add(value)
    }

    func removeObject(value: NSManagedObject, forKey key: String) {
        let items = self.mutableSetValue(forKey: key)
        items.remove(value)
    }
}
