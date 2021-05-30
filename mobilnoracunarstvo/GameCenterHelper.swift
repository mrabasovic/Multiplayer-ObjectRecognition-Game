import Foundation
import GameKit

protocol GameCenterHelperDelegate: class {
    func didChangeAuthStatus(isAuthenticated: Bool)
    func presentGameCenterAuth(viewController: UIViewController?)
    func presentMatchmaking(viewController: UIViewController?)
    func presentGame(match: GKMatch)
}


final class GameCenterHelper: NSObject, GKLocalPlayerListener {
    
    weak var delegate: GameCenterHelperDelegate?
    
    private let minPlayers: Int = 2
    private let maxPlayers: Int = 2
    private let inviteMessage = "Do you want to play Find Me with me?"
    
    private var currentVC: GKMatchmakerViewController?
    
    var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { (gameCenterAuthViewController, error) in
            self.delegate?.didChangeAuthStatus(isAuthenticated: self.isAuthenticated)
            
            guard GKLocalPlayer.local.isAuthenticated else {
                self.delegate?.presentGameCenterAuth(viewController: gameCenterAuthViewController)
                return
            }

            GKLocalPlayer.local.register(self)
        }
    }
    
    func presentMatchmaker(withInvite invite: GKInvite? = nil) {
        guard GKLocalPlayer.local.isAuthenticated else {return}
                
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        request.inviteMessage = inviteMessage
                
        guard let vc = GKMatchmakerViewController(matchRequest: request) else {return}
        
        
        vc.matchmakerDelegate = self
        delegate?.presentMatchmaking(viewController: vc)
    }
    
    private func createMatchmaker(withInvite invite: GKInvite? = nil) -> GKMatchmakerViewController? {
        
        //If there is an invite, create the matchmaker vc with it
        if let invite = invite {
            print("usao u invite")
            return GKMatchmakerViewController(invite: invite)
        }
        
        return GKMatchmakerViewController(matchRequest: createRequest())
    }
    
    private func createRequest() -> GKMatchRequest {
        let request = GKMatchRequest()
        request.minPlayers = minPlayers
        request.maxPlayers = maxPlayers
        request.inviteMessage = inviteMessage
        
        print("napravio request")
        return request
    }
}


extension GameCenterHelper: GKMatchmakerViewControllerDelegate {
    
    // ova fja je crna tacka markerom
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFind match: GKMatch) {
       
        delegate?.presentGame(match: match)
    }
    
//    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
//        currentVC?.dismiss(animated: true, completion: {
//            self.presentMatchmaker(withInvite: invite)
//            print("Uspelo didacceptinvite")
//        })
//    }
    
    // mozda je bolja fja iznad umesto ove
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        // Present the view controller in the invitation state
        let viewController = GKMatchmakerViewController(invite: invite)
        viewController?.matchmakerDelegate = self
        let rootViewController = UIApplication.shared.windows.first!.rootViewController
        rootViewController?.present(viewController!, animated: true, completion: nil)
    }
    
    func matchmakerViewControllerWasCancelled(_ viewController: GKMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func matchmakerViewController(_ viewController: GKMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
  
}
