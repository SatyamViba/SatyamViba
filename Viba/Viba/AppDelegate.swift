//
//  AppDelegate.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        UserDefaults.standard.register(defaults: [
            UserDefaultsKeys.selectedMenu.value: -1,
            UserDefaultsKeys.firstTime.value: true
        ])

        FirebaseApp.configure()

        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
