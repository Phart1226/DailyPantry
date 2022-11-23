//
//  RecipeViewController.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 10/31/22.
//

import UIKit
import CoreData

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var ingredientsTableView: UITableView!

    var delegate: UIViewController!
    var recipe: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
        recipeLabel.text = (recipe.value(forKey: "name") as! String)
        
        let qty = recipe.value(forKey: "qty") as! NSSet
        
        for i in qty.allObjects {
            print((i as AnyObject).value(forKey: "qty") as! Double)
            print((i as AnyObject).value(forKey: "ingredientName") as! String)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let ingredients = recipe.value(forKey: "ingredient") as! NSSet
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientsTableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        
        let ingredients = recipe.value(forKey: "ingredient") as! NSSet
        let ingredient = ingredients.allObjects[indexPath.row] as! NSManagedObject
        
        cell.textLabel?.text = (ingredient.value(forKey: "name") as! String)
        
        
        return cell
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
