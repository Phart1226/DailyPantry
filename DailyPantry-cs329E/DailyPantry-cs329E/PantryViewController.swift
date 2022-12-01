//
//  PantryViewController.swift
//  DailyPantry-cs329E
//
//  Created by Administrator on 11/13/22.
//

import UIKit
import Foundation

struct ExpandableNames{
    var isExpanded: Bool
    var names: [String]
}

private let reuseIdentifier = "PantryCell"

class PantryViewController: UIViewController {
    
    var tableView: UITableView!
    var tempMat = ["Meat": ExpandableNames(isExpanded: true, names: ["Turkey", "Beef"]), "Produce": ExpandableNames(isExpanded: true, names: ["Apple", "Banana", "Lettuce"]) , "Snacks": ExpandableNames(isExpanded: true, names: ["Chips", "Granola Bar"]), "Spices": ExpandableNames(isExpanded: true, names: ["Salt", "Pepper"])]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        tableView.tableFooterView = UIView()
    }
    
    func configureUI() {
        configureTableView()
        
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationBar.isTranslucent = false
//        navigationController?.navigationBar.barStyle = .black
//        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationItem.title = "Pantry"
    }
    @IBAction func clearPantry(_ sender: Any) {
        let alert = UIAlertController(title: "Clear Pantry",
                                      message: "Are you sure you would like to clear your pantry?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Yes", style: .default) {
            _ in
            let pantryItems = self.retrievePantry()
            for item in pantryItems{
                item.setValue(0, forKey: "amountAvailable")
            }
            self.saveContext()
            self.getPantryItems()
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func getPantryItems(){
        let pantryItems = retrievePantry()
        if pantryItems.count != 0 {
            if (currentPantryItems["Meat"]?.names.count)! == 0{
                for item in pantryItems{
                    currentPantryItems[(item.value(forKey: "catagory") as! String)]?.names.append((item.value(forKey: "name") as! String))
                    currentPantryItems[(item.value(forKey: "catagory") as! String)]?.qtys.append((item.value(forKey: "amountAvailable") as! Int))
                    
                }
            }else{
                for item in pantryItems{
                    let spot = currentPantryItems[(item.value(forKey: "catagory") as! String)]?.names.firstIndex(of: (item.value(forKey: "name") as! String))
                    currentPantryItems[(item.value(forKey: "catagory") as! String)]?.qtys[spot!] = (item.value(forKey: "amountAvailable") as! Int)
                    
                }
            }
        // add in pantry items if this is the first time a user is using the app or for some reason their pantry got completely cleared
        }else{
            for (catagory, nameList) in initPantry{
                for name in nameList{
                    let item = NSEntityDescription.insertNewObject(forEntityName: "StoredIngredient", into: context)
                    
                    item.setValue(name, forKey: "name")
                    item.setValue(catagory, forKey: "catagory")
                    item.setValue(0, forKey: "amountAvailable")
                    
                    // commit the changes
                    saveContext()
                }
            }
        }
    }
    
    func retrievePantry() -> [NSManagedObject]{
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
        
        return (fetchedResults)!
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

extension PantryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView (_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        button.setTitle(PantrySection(rawValue: section)?.description, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        
        return button
    }
    
    @objc func handleExpandClose(button: UIButton){
        var section: String
        switch button.tag{
        case 0:
            section = "Meat"
        case 1:
            section = "Produce"
        case 2:
            section = "Snacks"
        case 3:
            section = "Spices"
        default:
            section = ""
        }
        
        var indexPaths = [IndexPath]()
        for item in tempMat[section]!.names.indices{
            let indexPath = IndexPath(row: item, section: button.tag)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = tempMat[section]?.isExpanded
        tempMat[section]?.isExpanded = !(isExpanded!)
        
        if isExpanded!{
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
        else{
            tableView.insertRows(at: indexPaths, with: .fade)
        }
        
    }
    func numberOfSections (in tableView: UITableView) -> Int{
        return PantrySection.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = PantrySection(rawValue: section) else { return 0}
        
        if tempMat[section.description]!.isExpanded{
            switch section{
            case .Meat: return tempMat["Meat"]!.names.count
            case .Produce: return tempMat["Produce"]!.names.count
            case .Snacks: return tempMat["Snacks"]!.names.count
            case .Spices: return tempMat["Spices"]!.names.count
            }
        }
        else{
            return 0
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        guard let section = PantrySection(rawValue: indexPath.section) else { return UITableViewCell()}
        
        switch section{
        case .Meat:
            cell.textLabel?.text = tempMat["Meat"]!.names[indexPath.row]
        case .Produce:
            cell.textLabel?.text = tempMat["Produce"]!.names[indexPath.row]
        case .Snacks:
            cell.textLabel?.text = tempMat["Snacks"]!.names[indexPath.row]
        case .Spices:
            cell.textLabel?.text = tempMat["Spices"]!.names[indexPath.row]

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // when select will show pop that tells number of that item in pantry and how many are used
    }
    
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    
    
}
    
