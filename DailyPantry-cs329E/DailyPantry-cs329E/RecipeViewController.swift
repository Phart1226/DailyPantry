//
//  RecipeViewController.swift
//  DailyPantry-cs329E
//
//  Created by Hamza Elsiesy on 10/31/22.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var recipeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startObserving(&UIStyleManager.shared)

        // Do any additional setup after loading the view.
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
