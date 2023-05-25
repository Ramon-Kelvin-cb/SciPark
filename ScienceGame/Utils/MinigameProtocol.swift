//
//  MinigameProtocol.swift
//  ScienceGame
//
//  Created by Ramon Kelvin on 04/05/23.
//

import Foundation

protocol MinigameProtocol{
    var lives: Int? {get set}
    var win: Bool? {get set}
    var pontuation: Int? {get set}
    var ID : Minigames? {get}
    var curiosity: String {get}
    
    var time : Double {get set}
}

enum Minigames {
    case eletrons
    case macrophage
    case inertia
    case equilibrium
    case shake
}
