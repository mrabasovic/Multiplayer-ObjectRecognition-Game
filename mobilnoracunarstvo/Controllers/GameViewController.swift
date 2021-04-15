//
//  GameViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 6.4.21..
//

import UIKit
import GameKit

class GameViewController: UIViewController {

    
    
    @IBOutlet weak var vremeLabela: UILabel!
    var match: GKMatch?
    
    @IBOutlet weak var lokalniPogodjeni: UILabel!
    
    @IBOutlet weak var imeProtivnik: UILabel!
    @IBOutlet weak var protivnikPogodjeni: UILabel!
    
    private var gameModel: GameModel! {
            didSet {
                updateUI()
            }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Game view KONTROLER")
        gameModel = GameModel()
        match?.delegate = self
        
        savePlayers()
        //updateUI()
        
    }
    
    private func updateUI() {
        guard gameModel.igraci.count >= 2 else { return }
            
        vremeLabela.text = "\(gameModel.time)"
            
        
        lokalniPogodjeni.text = String(gameModel.igraci[0].pogodjeni)
        
        imeProtivnik.text = gameModel.igraci[1].ime
        protivnikPogodjeni.text = String(gameModel.igraci[1].pogodjeni)
        
        
    }
    
    
    // send it to the other players when there is a change. We use the sendData method available in GKMatch, passing the GameModel converted to Data.

    private func sendData() {
        guard let match = match else { return }
            
        do {
            guard let data = gameModel.encode() else { return }
            try match.sendData(toAllPlayers: data, with: .reliable)
        } catch {
            print("Send data failed")
        }
    }

    private func savePlayers() {
        guard let player2Name = match?.players.first?.displayName else { return }
            
        
        let player1 = Igrac(ime: GKLocalPlayer.local.displayName, pogodjeni: 0)
        
        let player2 = Igrac(ime: player2Name, pogodjeni: 0)
            
        gameModel.igraci = [player1, player2]
        print(gameModel.igraci)
        gameModel.igraci.sort { (player1, player2) -> Bool in
            player1.ime < player2.ime
        }
            
        sendData()
    }
    
    
}

//Na osnovu fje sendData -> When this information is received, the didReceive data method of the GKMatchDelegate is triggered and the other players will receive the GameModel. After receiving the new model, just replace the current one with the new one. This is just what is necessary to carry out the exchange of information that we mentioned earlier.
extension GameViewController: GKMatchDelegate {
    func match(_ match: GKMatch, didReceive data: Data, fromRemotePlayer player: GKPlayer) {
        guard let model = GameModel.decode(data: data) else { return }
        gameModel = model
    }
}
