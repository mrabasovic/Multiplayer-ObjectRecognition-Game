//
//  ViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 1.4.21..
//

import UIKit
import GameKit
import AVKit
import Vision

class ViewController: UIViewController {

    
    @IBOutlet weak var naslovLabela: UILabel!
    @IBOutlet weak var opisLabela: UILabel!
    @IBOutlet weak var hostBtn: UIButton!{
        didSet{
            hostBtn.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var singleBtn: UIButton!{
        didSet{
            singleBtn.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var settingsBtn: UIButton!{
        didSet{
            settingsBtn.layer.cornerRadius = 20
        }
    }
    
    func srediDugmad(){
        hostBtn.backgroundColor = .clear
        hostBtn.layer.cornerRadius = 5
        hostBtn.layer.borderWidth = 1
        hostBtn.layer.borderColor = UIColor.yellow.cgColor
        hostBtn.layer.cornerRadius = 20
        
        
        
        view.bringSubviewToFront(naslovLabela)
        view.bringSubviewToFront(hostBtn)
        view.bringSubviewToFront(singleBtn)
        view.bringSubviewToFront(settingsBtn)
        view.bringSubviewToFront(opisLabela)
        
        opisLabela.text = "Detect as many objects as you can using your camera!"
        opisLabela.numberOfLines = 0
    }
    
    let captureSession = AVCaptureSession()
    private var gameCenterHelper: GameCenterHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        gameCenterHelper = GameCenterHelper()
        gameCenterHelper.delegate = self
        gameCenterHelper.authenticatePlayer()
        
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // tri linije ispod su da bi kamera bila preko celog ekrana
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        let bojaView = UIView(frame: UIScreen.main.bounds)
        bojaView.backgroundColor = UIColor.black
        bojaView.layer.opacity = 0.6
        self.view.addSubview(bojaView)
        
        srediDugmad()
        
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
