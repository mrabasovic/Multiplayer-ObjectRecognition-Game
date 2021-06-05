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
    var player1Score : String?
    var player2Score: String?
    var winner: String?
    
    
    init(player1: String?, player1Score: String?, player2: String?, player2Score : String?, winner: String?) {
        self.player1 = player1
        self.player2 = player2
        self.player1Score = player1Score
        self.player2Score = player2Score
        self.winner = winner
    }
    
    
}
