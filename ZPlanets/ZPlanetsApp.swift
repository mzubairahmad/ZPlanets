//
//  ZPlanetsApp.swift
//  ZPlanets
//
//  Created by Zubair Ahmad on 10/05/2023.
//

import SwiftUI

@available(iOS 14.0, *)
@main
struct ZPlanetsApp: App {
    let persistenceController = CoreDataManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.mainContext)
        }
    }
}

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let persistenceController = CoreDataManager.shared
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: ContentView().environment(\.managedObjectContext, persistenceController.mainContext))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
}
