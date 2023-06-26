import SwiftUI
import FirebaseCore
import Firebase
import FirebaseCrashlytics
import FirebasePerformance
import FirebaseAppDistribution

class AppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: "HasLaunchedBefore")
        if isFirstLaunch {
            UserDefaults.standard.set(true, forKey: "HasLaunchedBefore")
            showDataCollectionAlert()
        } else {
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        }
        
        return true
    }
    
    private func showDataCollectionAlert() {
        let alert = UIAlertController(title: "Data Collection",
                                      message: "We collect crash data to improve the app. Are you okay with that?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in
            Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(false)
        }))
        
        guard let rootViewController = window?.rootViewController else { return }
        rootViewController.present(alert, animated: true, completion: nil)
    }
    
    @main
    struct CatsAndModulesApp: App {
        @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }
    
}
