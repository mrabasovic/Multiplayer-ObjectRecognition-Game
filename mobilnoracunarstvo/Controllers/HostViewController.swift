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
              let match = sender as? GKMatch else { return }
        
        vc.match = match
    }
}

extension HostViewController: GameCenterHelperDelegate {
    func didChangeAuthStatus(isAuthenticated: Bool) {
        btnStart.isEnabled = isAuthenticated
    }
    
    func presentGameCenterAuth(viewController: UIViewController?) {
        guard let vc = viewController else {return}
        self.present(vc, animated: true)
    }
    
    func presentMatchmaking(viewController: UIViewController?) {
        guard let vc = viewController else {return}
        self.present(vc, animated: true)
    }
    
    func presentGame(match: GKMatch) {
        performSegue(withIdentifier: "showGame", sender: match)
    }
}


