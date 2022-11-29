//
//  PantrySection.swift
//  DailyPantry-cs329E
//
//  Created by Administrator on 11/9/22.
//

enum PantrySection: Int, CaseIterable, CustomStringConvertible{
    case Meat
    case Produce
    case Snacks
    case Spices
    
    var description: String{
        switch self{
        case .Meat:
            return "Meat"
        case .Produce: return "Produce"
        case .Snacks: return "Snacks"
        case .Spices: return "Spices"
        }
    }
}



