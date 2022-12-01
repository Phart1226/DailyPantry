import Foundation
import UIKit

struct UIStyleManager {
    
    static let uiStyleDarkModeOn = "userInterfaceStyleDarkModeOn";
    
    static var shared = UIStyleManager()
    private var observers = [ObjectIdentifier : WeakStyleObserver]()
    
    private init() { }
    
    private(set) var currentStyle: UIUserInterfaceStyle = UserDefaults.standard.bool(forKey: UIStyleManager.uiStyleDarkModeOn) ? .dark : .light {
        // Property observer to trigger every time value is set to currentStyle
        didSet {
            if currentStyle != oldValue {
                // Trigger notification when currentStyle value changed
                styleDidChanged()
            }
        }
    }
}

// MARK:- Public functions
extension UIStyleManager {
    
    mutating func addObserver(_ observer: UIStyleObserver) {
        let id = ObjectIdentifier(observer)
        // Create a weak reference observer and add to dictionary
        observers[id] = WeakStyleObserver(observer: observer)
    }
    
    mutating func removeObserver(_ observer: UIStyleObserver) {
        let id = ObjectIdentifier(observer)
        observers.removeValue(forKey: id)
    }
    
    mutating func updateUserInterfaceStyle(_ isDarkMode: Bool) {
        currentStyle = isDarkMode ? .dark : .light
    }
}

// MARK:- Private functions
private extension UIStyleManager {
    mutating func styleDidChanged() {
        for (id, weakObserver) in observers {
            // Clean up observer that no longer in memory
            guard let observer = weakObserver.observer else {
                observers.removeValue(forKey: id)
                continue
            }
            
            // Notify observer by triggering userInterfaceStyleManager(_:didChangeStyle:)
            observer.uiStyleManager(self, didChangeStyle: currentStyle)
        }
    }
}
