//
//  AddRecipeViewController.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 10/31/22.
//
import UIKit
import CoreData

class AddRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var addedIngredients: [NSManagedObject] = []
    var filteredIngredients: [NSManagedObject]!
    var addedQty: [Float64] = []
    var catagory:String!
    var delegate:UIViewController!

    @IBOutlet weak var recipeName: UITextField!
    @IBOutlet weak var addTableView: UITableView!
    @IBOutlet weak var addedTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTableView.delegate = self
        addTableView.dataSource = self
        addedTableView.delegate = self
        addedTableView.dataSource = self
        searchBar.delegate = self
        filteredIngredients = retrieveIngredients()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == addTableView {
            return filteredIngredients.count
        } else {
            return addedIngredients.count
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: IngredientTableViewCell.identifier, for: indexPath) as! IngredientTableViewCell
            
            cell.textLabel?.text = (filteredIngredients[indexPath.row].value(forKey: "name") as! String)
            cell.configure(with: filteredIngredients[indexPath.row])
            cell.delegate = self
        
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddedIngredientCell", for: indexPath)
            cell.textLabel?.text = (addedIngredients[indexPath.row].value(forKey: "name") as! String)
            
            if floor(addedQty[indexPath.row]) == addedQty[indexPath.row] {
                cell.detailTextLabel?.text = String(Int(addedQty[indexPath.row]))
            } else {
                cell.detailTextLabel?.text = String(addedQty[indexPath.row])
            }
 
            return cell
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if recipeName.text != "" && addedIngredients.count > 0 {
            let recipe = StoredRecipe(context: context)
            recipe.name = recipeName.text
            recipe.catagory = catagory
            recipe.ingredient = NSSet(array: addedIngredients)
            
            var qtyArray:[StoredQty] = []
            
            for i in 0...addedIngredients.count - 1{
                let qty = StoredQty(context: context)
                qty.qty = Float64(addedQty[i])
                qty.ingredientName = addedIngredients[i].value(forKey: "name") as! String
                qtyArray.append(qty)
            }
            
            recipe.qty = NSSet(array: qtyArray)
            
            saveContext()
            
            // spin table view 360 degrees
            var durationValue = 1.0
            
            UIView.animate(
                withDuration: durationValue,
                animations: {
                    // 180 degree rotation
                    self.addTableView.transform =
                    self.addTableView.transform.rotated(by: CGFloat(Double.pi))
                    }
            )
            
            UIView.animate(
                withDuration: durationValue,
                animations: {
                    // 180 degree rotation
                    self.addTableView.transform =
                    self.addTableView.transform.rotated(by: CGFloat(Double.pi))
                    }
            )
            
        } else {
            var missing: String
            if recipeName.text == "" {
                missing = "recipe name."
            } else {
                missing = "ingredeints"
            }
            
            let controller = UIAlertController(
                title: "Cannot Add Recipe",
                message: "Please add \(missing)",
                preferredStyle: .alert)
            controller.addAction(UIAlertAction(
                title: "Ok",
                style: .default))
            present(controller, animated: true)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredIngredients = []
        
        if searchText == "" {
            filteredIngredients = retrieveIngredients()
        } else {
            for ingredient in retrieveIngredients() {
                let name = ingredient.value(forKey: "name") as! String
                if name.localizedCaseInsensitiveContains(searchText) {
                    filteredIngredients.append(ingredient)
                }
            }
        }
        self.addTableView.reloadData()
    }
    
    func retrieveIngredients() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredIngredient")
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
    
    func clearCoreData() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StoredRecipe")
        var fetchedResults:[NSManagedObject]
        
        do {
            try fetchedResults = context.fetch(request) as! [NSManagedObject]
            
            if fetchedResults.count > 0 {
                for result:AnyObject in fetchedResults {
                    context.delete(result as! NSManagedObject)
                    print("\(result.value(forKey: "name")!) has been deleted")
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

extension AddRecipeViewController: IngredientTableViewCellDelegate {
    func addButtonPressed(with ingredient: NSManagedObject, with qty: Float64) {
        if !addedIngredients.contains(ingredient) {
            addedIngredients.append(ingredient)
            addedQty.append(qty)
            addedTableView.reloadData()
        }
    }
}
