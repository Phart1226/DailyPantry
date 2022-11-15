//
//  RecipeListViewController.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 10/31/22.
//

import UIKit

protocol RecipeAdder {
    func addRecipe(newRecipe: Recipe)
}

class RecipeListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RecipeAdder{
    
    @IBOutlet weak var recipeListTableView: UITableView!
    
    var recipeList:[Recipe] = []
    
    var catagory:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipeListTableView.delegate = self
        recipeListTableView.dataSource = self        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = recipeListTableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath)
        cell.textLabel?.text = recipeList[indexPath.row].name
        
        return cell
    }
    
    func addRecipe(newRecipe: Recipe) {
        recipeList.append(newRecipe)
        recipeListTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRecipeSegueIdentifier",
        let destination = segue.destination as? AddRecipeViewController {
            destination.catagory = catagory
            destination.delegate = self
        }
    }

}
