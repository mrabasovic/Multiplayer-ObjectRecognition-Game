//
//  KrajViewController.swift
//  mobilnoracunarstvo
//
//  Created by mladen on 9.5.21..
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import FirebaseAuth
import FBSDKShareKit
import Firebase
import AVFoundation
import Vision

class KrajViewController: UIViewController, LoginButtonDelegate {
    

    @IBOutlet weak var mainmenuBtn: UIButton!
    @IBOutlet weak var shareBtn: FBShareButton!
    
    @IBOutlet weak var lokalniRezultat: UILabel!
    @IBOutlet weak var protivnikRezultat: UILabel!
    
    @IBOutlet weak var loginButton: FBLoginButton!
    @IBOutlet weak var gameResultsLabel: UILabel!
    
    @IBOutlet weak var matchHistoryBtn: UIButton!
    var protivnikRezultatVar = ""
    var lokalniRezultatVar = ""
    var winner = ""
    
    var ref: DatabaseReference!
    
    let cell = SettingsCell()
    
    //let matchVC = MeceviTableViewController()
    
//    override func viewWillAppear(_ animated: Bool) {
//        setGradientBackground()
//    }
    
    let captureSession = AVCaptureSession()
    
    override func viewWillAppear(_ animated: Bool) {
        if  cell.defaults.bool(forKey: "musicButton") as Bool == true{
            playSound()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    
        prikaziRezultate()
        
        let loginButton = FBLoginButton()
        loginButton.delegate = self
        loginButton.center = view.center
        // ove 2 linije ispod su da promenimo tekst koji pise na buttonu posto je pisalo login to facebook
        let buttonText = NSAttributedString(string: "Share on Facebook")
        loginButton.setAttributedTitle(buttonText, for: .normal)
        view.addSubview(loginButton)
        
        if let accessToken = AccessToken.current{
            // user is already logged in with Facebook
            print("User already logged in")
            print(accessToken)
            firebaseFacebookLogin(accessToken: accessToken.tokenString)
        }
        
        shareBtn.shareContent = getLinkSharingContent()
        
        // upisivanje u bazu
        ref = Database.database().reference().child("matches")
        addMatch()
        
        // citanje iz baze je u mecevi vc
        
        // POZADINA
        gradientBackground()
        
        
        
    }
    
    func addMatch(){
        let key = ref.childByAutoId().key!
        
        let match = ["player1":lokalniRezultat.text! as String, "player2":protivnikRezultat.text! as String, "winner":winner as String]
        print(match)
        ref.child(key).setValue(match)
    }
    
    var player: AVAudioPlayer!
    func playSound(){
        
        let url = Bundle.main.url(forResource: "kraj", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        
        player.play()
    }
    
    @IBAction func mainmenuBtnTouched(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let pocetni = storyBoard.instantiateViewController(withIdentifier: "pocetniVC") as! ViewController
        
        pocetni.modalPresentationStyle = .fullScreen
        self.present(pocetni, animated:true, completion:nil)
        
    }
    
    func getLinkSharingContent() -> SharingContent {
      let shareLinkContent = ShareLinkContent()
      shareLinkContent.contentURL = URL(string: "https://apps.apple.com/us/app/facebook/id284882215")!
      
      // Optional:
      shareLinkContent.hashtag = Hashtag("#FindMe")
      shareLinkContent.quote = "\(protivnikRezultatVar) vs \(lokalniRezultatVar)\nOpen your eyes and find objects quickly!"
      
      return shareLinkContent
    }
    
   
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
       if let error = error {
          print("Facebook login with error: \(error.localizedDescription)")
        } else {
          // User logs in successfully and can continue with Firebase Authentication sign-in
            // `AccessToken` is generated after user logs in through Facebook SDK successfully
            let facebookToken = AccessToken.current!.tokenString
            let credential = FacebookAuthProvider.credential(withAccessToken: facebookToken)
            Auth.auth().signIn(with: credential) { (result, error) in
              if let error = error {
                print("Firebase auth fails with error: \(error.localizedDescription)")
              } else if let result = result {
                print("Firebase login succeeds")
              }
            }
        }
      }
    
//    func loginButtonDidCompleteLogin(_ loginButton: FBLoginButton, result: LoginResult) {
//        print("User logged in")
//
//        switch result {
//        case .failed(let err):
//            print(err)
//        case .cancelled:
//            print("cancelled")
//        case .success(let grantedPermissions, let declinedPermissions, let accessToken):
//            print("success")
//            print(accessToken)
//            firebaseFacebookLogin(accessToken: accessToken!.tokenString)
//        }
//    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out!")
    }
    
    func firebaseFacebookLogin(accessToken: String){
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error{
                print("FIrebase login error")
                print(error)
                return
            }
            // here the User has signed in
            print("Firebase login done")
            print(authResult)
            
        }
    }
    
    
    
    private func prikaziRezultate(){
        protivnikRezultat.text = protivnikRezultatVar
        lokalniRezultat.text = lokalniRezultatVar
        protivnikRezultat.sizeToFit()
        lokalniRezultat.sizeToFit()
    }
    

    @IBAction func matchHistoryBtnTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        let mecevi = storyBoard.instantiateViewController(withIdentifier: "meceviVC") as! MeceviTableViewController
        
        //mecevi.modalPresentationStyle = .fullScreen
        self.present(mecevi, animated:true, completion:nil)
    }
    
    
    func gradientBackground(){
        guard let captureDevice = AVCaptureDevice.default(for: .video) else{return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else{return}
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        // tri linije ispod su da bi kamera bila preko celog ekrana
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        
        let initialColor = UIColor.yellow // our initial color
        let finalColor = initialColor.withAlphaComponent(0.0) // our initial color with transparency
                
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .axial
        gradientLayer.colors = [initialColor.cgColor, finalColor.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.addSublayer(gradientLayer)
        
        protivnikRezultat.layer.zPosition = 1
        lokalniRezultat.layer.zPosition = 1
        mainmenuBtn.layer.zPosition = 1
        matchHistoryBtn.layer.zPosition = 1
        shareBtn.layer.zPosition = 1
        
        mainmenuBtn.layer.cornerRadius = 20
        shareBtn.layer.cornerRadius = 20
        matchHistoryBtn.layer.cornerRadius = 20
        
        mainmenuBtn.backgroundColor = UIColor.yellow
        matchHistoryBtn.backgroundColor = UIColor.yellow
        
        mainmenuBtn.translatesAutoresizingMaskIntoConstraints = false
        mainmenuBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        mainmenuBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        matchHistoryBtn.translatesAutoresizingMaskIntoConstraints = false
        matchHistoryBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        matchHistoryBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        gameResultsLabel.layer.zPosition = 1
        
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        shareBtn.widthAnchor.constraint(equalToConstant: 250).isActive = true
        shareBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        shareBtn.titleLabel?.textAlignment = .center
        let buttonText = NSAttributedString(string: "Share your results!")
        shareBtn.layer.cornerRadius = 20
        shareBtn.contentVerticalAlignment = .center
        shareBtn.setAttributedTitle(buttonText, for: .normal)
    }
    
}

extension KrajViewController: SharingDelegate {
  func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
    print("didCompleteWithResults")
  }

  func sharer(_ sharer: Sharing, didFailWithError error: Error) {
    print("didFailWithError: \(error.localizedDescription)")
  }

  func sharerDidCancel(_ sharer: Sharing) {
    print("sharerDidCancel")
  }
}


