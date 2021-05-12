//
//  GameModel.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 7.4.21..
//

import Foundation
import UIKit
import GameKit

struct GameModel: Codable {
    var igraci: [Igrac] = []
    //var time: Int = 60
    
}

extension GameModel {
    func encode() -> Data? {
        return try? JSONEncoder().encode(self)
    }
    
    static func decode(data: Data) -> GameModel? {
        return try? JSONDecoder().decode(GameModel.self, from: data)
    }
}
