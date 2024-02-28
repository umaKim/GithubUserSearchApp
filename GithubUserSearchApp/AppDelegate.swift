//
//  AppDelegate.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}


//{(
//    DomainLayer.UserDomain(name: "antiface", id: 1619852, avatarUrl: "https://avatars.githubusercontent.com/u/1619852?v=4", htmlUrl: "https://github.com/antiface", isFavorite: false),
//    DomainLayer.UserDomain(name: "magician11", id: 3735849, avatarUrl: "https://avatars.githubusercontent.com/u/3735849?v=4", htmlUrl: "https://github.com/magician11", isFavorite: false)
//)}'
