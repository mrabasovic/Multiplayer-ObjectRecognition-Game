//
//  Igrac.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 7.4.21..
//

import Foundation


struct Igrac: Codable {
    var ime: String
    var pogodjeni: Int = 0
}

enum PlayerType: String, Codable, CaseIterable {
    case one
    case two
}

extension PlayerType {
    func enemyIndex() -> Int {
        switch self {
        case .one:
            return 1
        case .two:
            return 0
        }
    }
    
    func index() -> Int {
        switch self {
        case .one:
            return 0
        case .two:
            return 1
        }
    }
    
    
}
