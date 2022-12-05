import UIKit

class CustomNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        startObserving(&UIStyleManager.shared)
        
    }
    
}
