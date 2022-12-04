//
//  IngredientTableViewCell.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 11/3/22.
//

import UIKit
import CoreData


protocol IngredientTableViewCellDelegate: AnyObject {
    func addButtonPressed(with ingredient: NSManagedObject, with qty:Float64)
}

class IngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var unitLabel: UILabel!
    @IBOutlet weak var unitField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    var ingredient: NSManagedObject!
    
    weak var delegate: IngredientTableViewCellDelegate?
    static let identifier = "ingredientCell"

    
    func configure(with ingredient:NSManagedObject) {
        self.ingredient = ingredient
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        if (unitField.text != nil && (Float(unitField.text!) != nil)) {
            delegate?.addButtonPressed(with: ingredient, with: Float64(unitField.text!)!)
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
