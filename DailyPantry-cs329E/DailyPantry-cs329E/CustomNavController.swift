//
//  CustomNavController.swift
//  DailyPantry-cs329E
//
//  Created by Jonathan Abdo on 11/26/22.
//

import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UIStyleManager.shared)
        
        //self.title.Font
        // Do any additional setup after loading the view.
    }
    
}
