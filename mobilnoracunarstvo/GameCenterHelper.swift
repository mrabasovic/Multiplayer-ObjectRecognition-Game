import GameKit

final class GameCenterHelper: NSObject {
  typealias CompletionBlock = (Error?) -> Void
    
    // 1
    static let helper = GameCenterHelper()

    // 2
    var viewController: UIViewController?

    override init() {
      super.init()
      
      GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
        
        NotificationCenter.default
          .post(name: .authenticationChanged, object: GKLocalPlayer.local.isAuthenticated)

        if GKLocalPlayer.local.isAuthenticated {
          print("Authenticated to Game Center!")
        } else if let vc = gcAuthVC {   // ako korisnik treba da se uloguje u game center prosledjujemo mu viewContr
          self.viewController?.present(vc, animated: true)
        }
        else {
          print("Error authentication to GameCenter: " +
            "\(error?.localizedDescription ?? "none")")
        }
      }
    }
    
    func presentMatchmaker() {
      // 1 Ensure the player is authenticated.
      guard GKLocalPlayer.local.isAuthenticated else {
        return
      }
      
      // 2 Create a match request to send an invite using the matchmaker view controller.
      let request = GKMatchRequest()
      
      request.minPlayers = 2
      request.maxPlayers = 2
      // 3 Customize the request. Set the invite message to personalize the invitation.
      request.inviteMessage = "Da li hocete da igrate Find Me?"
      
      // 4 Pass the request to the matchmaker view controller and present it.
      let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
      viewController?.present(vc, animated: true)
        
        //add this to assign the delegate in presentMatchmaker(), before presenting the view controller:
        vc.turnBasedMatchmakerDelegate = self

    }



}

extension Notification.Name {
    // presentGame notifies the menu scene to present an online game.
  static let presentGame = Notification.Name(rawValue: "presentGame")
    // authenticationChanged notifies the app of any authentication state changes.
  static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}




//Initially, the matchmaker view controller shows a new game view. If you try to cancel and dismiss the view or create a new game, the view controller doesn’t dismiss. This is because the matchmaker’s delegate isn’t set.

//To fix this, first add the following extension at the bottom of GameCenterHelper.swift to conform the helper class to GKTurnBasedMatchmakerViewControllerDelegate:

extension GameCenterHelper: GKTurnBasedMatchmakerViewControllerDelegate {
  func turnBasedMatchmakerViewControllerWasCancelled(
    _ viewController: GKTurnBasedMatchmakerViewController) {
      viewController.dismiss(animated: true)
  }
  
  func turnBasedMatchmakerViewController(
    _ viewController: GKTurnBasedMatchmakerViewController,
    didFailWithError error: Error) {
      print("Matchmaker vc did fail with error: \(error.localizedDescription).")
  }
}
