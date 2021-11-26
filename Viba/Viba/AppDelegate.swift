//
//  AppDelegate.swift
//  Viba
//
//  Created by Satyam Sutapalli on 08/11/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        #if DEBUG
        UserDefaults.standard.register(defaults: [
            UserDefaultsKeys.companyId.value: "615c95bffa612356f5f09267",
            UserDefaultsKeys.userId.value: "6190d96f7f1f181b93eab0da",
            UserDefaultsKeys.selectedMenu.value: -1
        ])
        #endif
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
