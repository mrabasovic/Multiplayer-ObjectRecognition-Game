//
//  ViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 1.4.21..
//

import UIKit
import GameKit

class ViewController: UIViewController {

    @IBOutlet weak var hostBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var singleBtn: UIButton!
    

    func srediDugmad(){
        hostBtn.backgroundColor = .clear
        hostBtn.layer.cornerRadius = 5
        hostBtn.layer.borderWidth = 1
        hostBtn.layer.borderColor = UIColor.black.cgColor
        //hostBtn.layer
    }
    
    
    private var gameCenterHelper: GameCenterHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //srediDugmad()
        
        gameCenterHelper = GameCenterHelper()
        gameCenterHelper.delegate = self
        gameCenterHelper.authenticatePlayer()
    }

    
    @IBAction func hostPressed(_ sender: UIButton) {
        gameCenterHelper.presentMatchmaker()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        guard let vc = segue.destination as? GameViewController,
              let match = sender as? GKMatch
        else { return }
        
        //gameCenterHelper.delegate = self // OBISI ovo ako ne treba. nisam siguran. mislim da ne mora jer vec ima u viewdidload
        
        vc.match = match
    }
}


extension ViewController: GameCenterHelperDelegate {
    
    // ovde implementiramo fje iz protokola
    
    func didChangeAuthStatus(isAuthenticated: Bool) {
        print("usao u didChangeAuthStatus")
        //btnStart.isEnabled = isAuthenticated
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
        
        // MISLIM DA OVO ISPOD NE MOZE AL NEKA GA TU ZA SVAKI SLUCAJ
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//
//        // for programmatically presenting view controller
//        // present(viewController, animated: true, completion: nil)
//
//        //For Story board segue. you will also have to setup prepare segue for this to work.
//         self?.performSegue(withIdentifier: "Identifier", sender: nil)
//          }
        
        
        performSegue(withIdentifier: "showGame", sender: match)
    }
}
