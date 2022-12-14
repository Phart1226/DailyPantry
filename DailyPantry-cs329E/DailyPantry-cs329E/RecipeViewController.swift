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
        UILabel.appearance().substituteFontName = fontStyle
        // Do any additional setup after loading the view.
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        date = datePicker.date
        today = datePicker.date
        
        recipeLabel.text = (recipe.value(forKey: "name") as! String)
        startObserving(&UIStyleManager.shared)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ingredientsTableView.reloadData()
        startObserving(&UIStyleManager.shared)
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
        let qty = String((qtyArry[qtyIndex!] as! StoredQty).qty)
        let available = ingredient.value(forKey: "amountAvailable")!
        
        cell.textLabel?.text = ingredientName
        cell.detailTextLabel?.text = "Required \(qty) : Available \(String(describing: available))"
    
        return cell
    }

    @IBAction func datePickerValueChanged(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        date = datePicker.date
    }
    
    @IBAction func addToDayButtonPressed(_ sender: Any) {
        let ingredients = recipe.value(forKey: "ingredient") as! NSSet
        let qtyArry = (recipe.value(forKey: "qty") as! NSSet).allObjects
        for ingredient in ingredients {
            let ingredientName = (ingredient as! NSManagedObject).value(forKey: "name")!
            let qtyIndex = qtyArry.firstIndex(where: {($0 as! StoredQty).ingredientName! == ingredientName as! String})
            let qty = (qtyArry[qtyIndex!] as! StoredQty).qty
            let available = (ingredient as! NSManagedObject).value(forKey: "amountAvailable")!
            
            if qty > available as! Double {
                let controller = UIAlertController(
                    title: "Cannot Add Recipe",
                    message: "You dont have enough \(String(describing: ingredientName))",
                    preferredStyle: .alert)
                controller.addAction(UIAlertAction(
                    title: "Ok",
                    style: .default))
                present(controller, animated: true)
                
                return
            }
        }
   
        if date >= today {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MMM-yyyy"
            let formattedDate = formatter.string(from: date)
            let recipeName = (recipe.value(forKey: "name") as! String)
            
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
            
            for ingredient in ingredients {
                let ingredientName = (ingredient as! NSManagedObject).value(forKey: "name")!
                let qtyIndex = qtyArry.firstIndex(where: {($0 as! StoredQty).ingredientName! == ingredientName as! String})
                let qty = (qtyArry[qtyIndex!] as! StoredQty).qty
                let available = (ingredient as! NSManagedObject).value(forKey: "amountAvailable")! as! Double
                
                (ingredient as! NSManagedObject).setValue((available-qty), forKey: "amountAvailable")
                
            }
            
            saveContext()
            
            notify(recipeName: recipeName, date: formattedDate)
            
            ingredientsTableView.reloadData()
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
    
    func notify(recipeName: String, date: String) {
        let content = UNMutableNotificationContent()
        content.title = "You've added a recipe!"
        content.subtitle = "You added \(recipeName) to \(date)!"
        content.body = "\(recipeName) will now appear on your calendar!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8.0 , repeats: false)
        
        let request = UNNotificationRequest(identifier: "recipeNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
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
