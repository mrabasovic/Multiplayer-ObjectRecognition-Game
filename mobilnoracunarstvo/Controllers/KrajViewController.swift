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


class KrajViewController: UIViewController, LoginButtonDelegate {
    

    @IBOutlet weak var mainmenuBtn: UIButton!
    @IBOutlet weak var shareBtn: FBShareButton!
    
    @IBOutlet weak var lokalniRezultat: UILabel!
    @IBOutlet weak var protivnikRezultat: UILabel!
    
    @IBOutlet weak var loginButton: FBLoginButton!

    @IBOutlet weak var matchHistoryBtn: UIButton!
    var protivnikRezultatVar = ""
    var lokalniRezultatVar = ""
    
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
        
        mecevi.modalPresentationStyle = .fullScreen
        self.present(mecevi, animated:true, completion:nil)
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


