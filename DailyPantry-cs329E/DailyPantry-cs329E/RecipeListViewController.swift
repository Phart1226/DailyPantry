//
//  RecipeListViewController.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 10/31/22.
//

import UIKit
import CoreData

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var recipeListTableView: UITableView!
    
    var catagory:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeListTableView.delegate = self
        recipeListTableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        recipeListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return retrieveRecipe().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeListTableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        cell.textLabel?.text = (retrieveRecipe()[indexPath.row].value(forKey: "name") as! String)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRecipeSegueIdentifier",
        let destination = segue.destination as? AddRecipeViewController {
            destination.catagory = catagory
            destination.delegate = self
        }
        if segue.identifier == "recipeSegueIndentifier", let destination = segue.destination as? RecipeViewController {
            destination.delegate = self
            destination.recipe = retrieveRecipe()[recipeListTableView.indexPathForSelectedRow!.row]
        }
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
        startObserving(&UIStyleManager.shared)

    }

}
