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
    case opt2
    case opt3
    
    var containsSwitch: Bool {
        switch self{
        case .darkMode: return true
        case .opt2: return true
        case .opt3: return true
        }
    }
    
    var description: String{
        switch self{
        case .darkMode: return "Dark Mode"
        case .opt2: return "opt 2"
        case .opt3: return "opt 3"
        }
    }
}
