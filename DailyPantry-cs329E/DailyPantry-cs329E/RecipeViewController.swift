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
    @IBOutlet weak var ingredientsTableView: UITableView!

    var delegate: UIViewController!
    var recipe: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startObserving(&UIStyleManager.shared)

        // Do any additional setup after loading the view.
        ingredientsTableView.delegate = self
        ingredientsTableView.dataSource = self
        
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
