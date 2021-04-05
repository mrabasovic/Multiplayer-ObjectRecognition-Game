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

}
