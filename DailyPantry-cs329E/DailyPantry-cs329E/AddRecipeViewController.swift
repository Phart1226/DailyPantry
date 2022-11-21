//
//  AddRecipeViewController.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 10/31/22.
//

import UIKit

class AddRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var ingredients:[Ingredient] = [Ingredient(name: "Egg", unit: "Whole", amountAvailable: 12, catagory: "Fridge"), Ingredient(name: "Milk", unit: "Cup", amountAvailable: 20, catagory: "Fridge")]
    
    var addedIngredients: [Ingredient] = []
    var filteredIngredients: [Ingredient]!
    var addedQty: [Int] = []


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
        filteredIngredients = ingredients
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
            
            cell.textLabel?.text = filteredIngredients[indexPath.row].name
            cell.unitLabel?.text = filteredIngredients[indexPath.row].unit
            cell.configure(with: filteredIngredients[indexPath.row])
            cell.delegate = self
        
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddedIngredientCell", for: indexPath)
            cell.textLabel?.text = addedIngredients[indexPath.row].name
            cell.detailTextLabel?.text = String(addedQty[indexPath.row])
            return cell
        }
        
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        let recipe = Recipe(ingreidents: addedIngredients, catagory: "Breakfast")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredIngredients = []
        
        if searchText == "" {
            filteredIngredients = ingredients
        } else {
            for ingredient in ingredients {
                if ingredient.name.localizedCaseInsensitiveContains(searchText) {
                    filteredIngredients.append(ingredient)
                }
            }
        }
        self.addTableView.reloadData()
    }
}

extension AddRecipeViewController: IngredientTableViewCellDelegate {
    func addButtonPressed(with ingredient: Ingredient, with qty: Int) {
        if !addedIngredients.contains(ingredient) {
            addedIngredients.append(ingredient)
            addedQty.append(qty)
            addedTableView.reloadData()
        }
        
    }
}
