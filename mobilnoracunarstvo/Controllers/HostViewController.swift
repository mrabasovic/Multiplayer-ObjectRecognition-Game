//
//  HostViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 1.4.21..
//

import UIKit


class HostViewController: UIViewController {

    @IBOutlet weak var imeTxt: UITextField!
    @IBOutlet weak var tabelaImena: UITableView!
    @IBOutlet weak var startBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        pokreniGameCenter()
        

        
    }
    

    @IBAction func startPressed(_ sender: UIButton) {
        
        // ovo hocu da se pokrene cim udjem u online game ane na dodir dugmeta start al smisli lepo kako ces
        GameCenterHelper.helper.presentMatchmaker()
    }
    
    func pokreniGameCenter(){
        GameCenterHelper.helper.viewController = self
    }

}
