import Foundation
import UIKit

protocol UIStyleObserver: AnyObject {
    func startObserving(_ uiStyleManager: inout UIStyleManager)
    func uiStyleManager(_ manager: UIStyleManager, didChangeStyle style: UIUserInterfaceStyle)
    func fancyFontManager()
}

extension UIViewController: UIStyleObserver {
    
    func startObserving(_ uiStyleManager: inout UIStyleManager) {
        // Add view controller as observer of UserInterfaceStyleManager
        uiStyleManager.addObserver(self)
        
        // Change view controller to desire style when start observing
        overrideUserInterfaceStyle = uiStyleManager.currentStyle
    }
    
    func uiStyleManager(_ manager: UIStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIViewController
        overrideUserInterfaceStyle = style
        
        // Update status bar style
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func fancyFontManager() {
        
    }
}

extension UIView: UIStyleObserver {
    
    func startObserving(_ uiStyleManager: inout UIStyleManager) {
        // Add view as observer of UserInterfaceStyleManager
        uiStyleManager.addObserver(self)
        
        // Change view to desire style when start observing
        overrideUserInterfaceStyle = uiStyleManager.currentStyle
    }
    
    func uiStyleManager(_ manager: UIStyleManager, didChangeStyle style: UIUserInterfaceStyle) {
        // Set user interface style of UIView
        overrideUserInterfaceStyle = style
    }
    
    func fancyFontManager() {
        
    }
}
