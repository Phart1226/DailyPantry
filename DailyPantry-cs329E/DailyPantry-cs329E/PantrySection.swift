//
//  PantrySection.swift
//  DailyPantry-cs329E
//
//  Created by Administrator on 11/9/22.
//
enum PantrySection: Int, CaseIterable, CustomStringConvertible{
    case Meat
    case Produce
    case Dairy
    case Snacks
    case Spices
    case Miscellaneous
    
    var description: String{
        switch self{
        case .Meat:
            return "Meat"
        case .Dairy: return "Dairy"
        case .Produce: return "Produce"
        case .Snacks: return "Snacks"
        case .Spices: return "Spices"
        case .Miscellaneous: return "Miscellaneous"
        }
    }
}


