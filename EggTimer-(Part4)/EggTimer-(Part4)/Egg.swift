//
//  Egg.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import Foundation

class Egg {
    enum EggType{
        case easy
        case medium
        case hard
        case so_hard
    }
    enum EggImage{
        case egg1
        case egg2
        case egg3
        case egg4
    }
    
    static func cooking(style: EggType) -> Float{
        switch style {
        case .easy:
            return 120
        case .medium:
            return 180
        case .hard:
            return 240
        case .so_hard:
            return 300
        }
    }
    
    static func eggType(type: EggType) -> [String]{
        switch type {
        case .easy:
            return ["Easy","egg-1","6"]
        case .medium:
            return ["Medium","egg-2","70"]
        case .hard:
            return ["Hard","egg-3","240"]
        case .so_hard:
            return ["So Hard","egg-4","300"]
        }
    }
    
}
