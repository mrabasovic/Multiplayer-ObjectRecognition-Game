//
//  Match.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 24.5.21..
//

import Foundation

struct Match{
    
    var player1: String?
    var player2: String?
    
    var winner: String?
    
    
    init(player1: String?, player2: String?, winner: String?) {
        self.player1 = player1
        self.player2 = player2
        self.winner = winner
    }
}
