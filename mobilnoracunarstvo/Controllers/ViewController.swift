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
    
    
    
    @IBOutlet weak var settingsBtn: UIButton!{
        didSet{
            settingsBtn.layer.cornerRadius = 20
        }
    }
    
    func srediDugmad(){
//        hostBtn.backgroundColor = .clear
//        hostBtn.layer.cornerRadius = 5
//        hostBtn.layer.borderWidth = 1
//        hostBtn.layer.borderColor = UIColor.yellow.cgColor
        
        hostBtn.layer.cornerRadius = 20
        
        view.bringSubviewToFront(naslovLabela)
        view.bringSubviewToFront(hostBtn)
        
        view.bringSubviewToFront(settingsBtn)
        view.bringSubviewToFront(opisLabela)
        
        opisLabela.text = "Detect as many objects as you can with your camera!"
      
        opisLabela.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        hostBtn.translatesAutoresizingMaskIntoConstraints = false
        hostBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        hostBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        settingsBtn.translatesAutoresizingMaskIntoConstraints = false
        settingsBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        settingsBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
        vc.match = match
    }
}


extension ViewController: GameCenterHelperDelegate {
    
    // ovde implementiramo fje iz protokola
    
    func didChangeAuthStatus(isAuthenticated: Bool) {
        print("usao u didChangeAuthStatus")
        
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
