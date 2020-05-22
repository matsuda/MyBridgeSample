//
//  AppDelegate.swift
//  MyBridgeSample
//
//  Created by Kosuke Matsuda on 2020/05/20.
//  Copyright © 2020 Kosuke Matsuda. All rights reserved.
//

import UIKit
import API

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if let dict = Bundle.main.infoDictionary {
            if let token = dict["GitHubAPIToken"] as? String {
                print("GitHub API auth token: \(token)")
                GitHubConfig.shared.token = token
            }
        }
        if GitHubConfig.shared.token == nil {
            print("======================================")
            print("== GitHub API auth token is not set ==")
            print("======================================")
        }

        #if DEBUG
//        URLCache.shared.removeAllCachedResponses()
        if let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            print("documentDirectory >>>>>", path)
        }
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
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

