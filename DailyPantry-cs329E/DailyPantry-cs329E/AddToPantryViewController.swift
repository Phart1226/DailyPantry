//
//  AddToPantryViewController.swift
//  DailyPantry-cs329E
//
//  Created by Administrator on 11/22/22.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class AddToPantryViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    var categories = ["Meat","Produce","Dairy","Spices","Snacks","Miscellaneous"]
    
    var groceryItems:[NSManagedObject] = []
    var selectedItems:[NSManagedObject] = []
    
    var selectedItem = NSManagedObject()
    
    var catSelected = "Meat"
    var qtyVal = 0
    
    @IBOutlet weak var itemPicker: UIPickerView!
    @IBOutlet weak var catPicker: UIPickerView!
    
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        catPicker.delegate = self
        catPicker.dataSource = self
        itemPicker.delegate = self
        itemPicker.dataSource = self
        
        groceryItems = retrieveItems()
        getItems()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
                return categories.count
            } else {
                return selectedItems.count
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
                return categories[row]
            } else {
                return selectedItems[row].value(forKey: "name") as! String
            }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            catSelected = categories[row]
            selectedItems = []
            getItems()
            itemPicker.reloadAllComponents()
        }
        else{
            selectedItem = selectedItems[row]
            qtyVal = selectedItem.value(forKey: "qty") as! Int
            stepper.value = Double(qtyVal)
            quantityField.text = "\(qtyVal)"
            itemPicker.reloadAllComponents()
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
    
    func retrieveItems() -> [NSManagedObject] {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PantryItem")
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
    
    func getItems(){
        for item in groceryItems{
            if (item.value(forKey: "category") as! String) == catSelected{
                selectedItems.append(item)
            }
        }
        
        selectedItems.sort{
            ($0.value(forKey: "name") as! String) < ($1.value(forKey: "name") as! String)
        }
        
        selectedItem = selectedItems[0]
        qtyVal = selectedItem.value(forKey: "qty") as! Int
        stepper.value = Double(qtyVal)
        quantityField.text = "\(qtyVal)"
    }
    
    @IBAction func stepChange(_ sender: Any) {
        qtyVal = Int(stepper.value)
        quantityField.text = "\(qtyVal)"
    }
    
    
    @IBAction func qtyChanged(_ sender: Any) {
        stepper.value = Double(quantityField.text!)!
    }
    
    
    @IBAction func addItem(_ sender: Any) {
        // update qty of item
        selectedItem.setValue(qtyVal, forKey: "qty")
        saveContext()
        
        
    }
    
    

}
