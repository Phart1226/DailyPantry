//
//  IngredientTableViewCell.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 11/3/22.
//

import UIKit

protocol IngredientTableViewCellDelegate: AnyObject {
    func addButtonPressed(with ingredient: Ingredient, with qty:Int)
}

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    var ingredient: Ingredient!
    
    weak var delegate: IngredientTableViewCellDelegate?
    static let identifier = "ingredientCell"

    
    func configure(with ingredient:Ingredient) {
        self.ingredient = ingredient
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if (unitField.text != nil && unitField.text!.isInt) {
            delegate?.addButtonPressed(with: ingredient, with: Int(unitField.text!)!)
        }
        
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        }

}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}