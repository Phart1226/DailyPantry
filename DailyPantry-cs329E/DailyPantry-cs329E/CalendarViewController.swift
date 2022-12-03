//
//  CalenderViewController.swift
//  DailyPantry-cs329E
//
//  Created by Administrator on 10/21/22.
//

import UIKit
import FSCalendar
import CoreData

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, UITableViewDelegate, UITableViewDataSource{
    
    var calendar:FSCalendar!
    var formatter = DateFormatter()
    var selMeals:[String] = []
    var allMeals:[NSManagedObject] = []
    var dateSelected = ""
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up calendar
        calendar = FSCalendar(frame: CGRect(x: 0.0, y: 100.0, width: self.view.frame.size.width, height: 500.0))
        calendar.scrollDirection = .vertical
        calendar.scope = .week
        self.view.addSubview(calendar)
        
        calendar.delegate = self
        
        // Table View
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // Calendar style
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 20)
        calendar.appearance.headerTitleFont = UIFont.boldSystemFont(ofSize: 25)
        calendar.appearance.weekdayFont = UIFont.boldSystemFont(ofSize: 20)
        
        calendar.appearance.headerTitleColor = UIColor.systemOrange
        calendar.appearance.weekdayTextColor = UIColor.systemOrange
        
        // setting selected date to current day
        formatter.dateFormat = "dd-MMM-YYYY"
        dateSelected = formatter.string(from: Date())
        
        
//        clearCoreData()
//        loadCalendar()
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-YYYY"
        
        // grab date selected by user
        dateSelected = formatter.string(from: date)
        allMeals = retrieveMeals()
        selMeals = []
        tableView.reloadData()
    }
    
    // showing dots undernieth date for events
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
          formatter.dateFormat = "dd-MM-yyyy"
            guard let eventDate = formatter.date(from:"04-11-2022") else{return 0}
        if date.compare(eventDate) == .orderedSame{
            return 2
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        for meal in allMeals{
            if (meal.value(forKey: "date") as! String) == dateSelected{
                let recipeName = meal.value(forKey: "recipeName") as? String ?? ""
                if recipeName != ""{
                    selMeals.append(recipeName)
                }
            }
        }
        return selMeals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // placeholder for table view data
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        
        cell.textLabel?.text = selMeals[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipes = retrieveRecipe()
        let recipe = recipes[indexPath.row] as! StoredRecipe
        
        let ingredients = recipe.value(forKey: "ingredient") as! NSSet
        let qtyArry = (recipe.value(forKey: "qty") as! NSSet).allObjects
        
        let alert = UIAlertController(title: "Meal: \(recipe.value(forKey: "name") as! String)",
                                      message: "Ingredients:",
                                      preferredStyle: .alert)
        
        let backAction = UIAlertAction(title: "Dismiss", style: .cancel)
        
        alert.addAction(backAction)
        
        present(alert, animated: true, completion: {
            for ing in ingredients{
                let ingredient = ing as! NSManagedObject
                let ingredientName = (ingredient.value(forKey: "name") as! String)
                let qtyIndex = qtyArry.firstIndex(where: {($0 as! StoredQty).ingredientName! == ingredientName})
                let qty = (qtyArry[qtyIndex!] as! StoredQty).qty
                //  Add your label
                  let margin:CGFloat = 8.0
                  let rect = CGRect(x: margin, y: 72.0, width: alert.view.frame.width - margin * 2.0 , height: 20)
                  let label = UILabel(frame: rect)
                  label.text = "\(ingredientName)     qty: \(qty)"
                  label.textAlignment = .center
                  label.adjustsFontSizeToFitWidth = true
                  label.minimumScaleFactor = 0.5
                  alert.view.addSubview(label)
            }
        })
    }
    
    func retrieveMeals() -> [NSManagedObject]{
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
        
        return (fetchedResults)!
    }
    
    func retrieveRecipe() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredRecipe")
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

}
