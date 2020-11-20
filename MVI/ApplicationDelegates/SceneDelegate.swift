//
//  SceneDelegate.swift
//  MVI
//
//  Created by Sima Vlad Grigore on 02/08/2020.
//  Copyright © 2020 Sima Vlad Grigore. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}
