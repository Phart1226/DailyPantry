//
//  SettingsSection.swift
//  DailyPantry-cs329E
//
//  Created by Administrator on 11/9/22.
//

protocol SectionType: CustomStringConvertible {
    var containsSwitch: Bool { get }
}

enum SettingsSection: Int, CaseIterable, CustomStringConvertible{
    case Social
    case AppOptions
    
    var description: String{
        switch self{
        case .Social: return "Social"
        case .AppOptions: return "App Options"
        }
    }
}

enum SocialOption: Int, CaseIterable, SectionType{

    case editProfile
    case logOut
    
    var containsSwitch: Bool {return false}
    
    var description: String{
        switch self{
        case .editProfile: return "Edit Profile"
        case .logOut: return "Log Out"
        }
    }
}

enum AppOption: Int, CaseIterable, SectionType{
    
    case darkMode
    case stylisticFont
    case notifications
    
    var containsSwitch: Bool {
        switch self{
        case .darkMode: return true
        case .stylisticFont: return true
        case .notifications: return true
        }
    }
    
    var description: String{
        switch self{
        case .darkMode: return "Dark Mode"
        case .stylisticFont: return "Stylistic Font"
        case .notifications: return "Notifications"
        }
    }
}
