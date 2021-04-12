//
//  HostViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 1.4.21..
//

import UIKit
import GameKit

class HostViewController: UIViewController {


    @IBOutlet weak var btnStart: UIButton!
    private var gameCenterHelper: GameCenterHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        btnStart.isEnabled = false
        btnStart.layer.cornerRadius = 10
        
        gameCenterHelper = GameCenterHelper()
        gameCenterHelper.delegate = self
        gameCenterHelper.authenticatePlayer()
    }

    @IBAction func startPressed(_ sender: UIButton) {
        gameCenterHelper.presentMatchmaker()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let vc = segue.destination as? GameViewController,
              let match = sender as? GKMatch
        else { return }
        
        gameCenterHelper.delegate = self // OBISI ovo ako ne treba. nisam siguran. mislim da ne mora jer vec ima u viewdidload
        
        vc.match = match
    }
    
    
}

extension HostViewController: GameCenterHelperDelegate {
    
    // ovde implementiramo fje iz protokola
    
    func didChangeAuthStatus(isAuthenticated: Bool) {
        print("usao u didChangeAuthStatus")
        btnStart.isEnabled = isAuthenticated
    }
    
    func presentGameCenterAuth(viewController: UIViewController?) {
        print("usao u presentGameCenterAuth")
        guard let vc = viewController else {return}
        self.present(vc, animated: true)
    }
    
    func presentMatchmaking(viewController: UIViewController?) {
        print("usao u presentMatchmaking")
        guard let vc = viewController else {return}
        self.present(vc, animated: true)
    }
    
    func presentGame(match: GKMatch) {
        print("usao u present game")
        performSegue(withIdentifier: "showGame", sender: match)
    }
}


