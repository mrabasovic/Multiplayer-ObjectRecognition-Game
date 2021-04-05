//
//  ViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 1.4.21..
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var hostBtn: UIButton!
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var singleBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        srediDugmad()
        GameCenterHelper.helper.viewController = self

    }


    func srediDugmad(){
        hostBtn.backgroundColor = .clear
        hostBtn.layer.cornerRadius = 5
        hostBtn.layer.borderWidth = 1
        hostBtn.layer.borderColor = UIColor.black.cgColor
        //hostBtn.layer
    }
}

