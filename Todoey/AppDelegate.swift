
import UIKit

import RealmSwift
 
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
 
var window: UIWindow?
    
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
   // print(Realm.Configuration.defaultConfiguration.fileURL)
    
    do{
    _=try Realm()
        }catch{
    print("Error \(error) ")
    }
    
return true
}
 
func applicationWillTerminate(_ application: UIApplication) {


}
}



