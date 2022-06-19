import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: - UISceneSession Lifecycle
    
    var currentDownload : SongDownload?
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    private func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completitionHandler: @escaping() -> Void) async {
        print("background session -> \(identifier)")
        if currentDownload == nil{
            currentDownload = SongDownload()
        }
        
        currentDownload?.completionHandler = completitionHandler
        
    }
}
