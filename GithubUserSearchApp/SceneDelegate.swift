//
//  SceneDelegate.swift
//  GithubUserSearchApp
//
//  Created by 김윤석 on 2024/02/22.
//

import DependencyInjectionManager
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: Coordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window                = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene   = windowScene
        
        guard let window      = window else { return }
        appCoordinator        = AppCoordinator(window: window)
        appCoordinator?.start()
    }
}
