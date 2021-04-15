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
        //btnStart.isEnabled = false
        btnStart.layer.cornerRadius = 10
        
       
    }

    @IBAction func startPressed(_ sender: UIButton) {
        gameCenterHelper.presentMatchmaker()
    }


}




