//
//  AppDelegate.swift
//  TaskManagementApp
//
//  Created by Monica Vargas on 2022-07-05.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let defaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if defaults.bool(forKey: "HasLaunched") == false {
            DBHelper.shared.createListTable()
            DBHelper.shared.createTaskTable()
            defaults.set(true, forKey: "HasLaunched")
        }
        
        changeColor()
        
        
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

    func resetApp() {
        UIApplication.shared.windows[0].rootViewController = UIStoryboard(
            name: "Main",
            bundle: nil
            ).instantiateInitialViewController()
    }

    func changeColor(){

        let color = UIColor.appColor(.Dark)
        let tintColor = UIColor.white
        
        if #available(iOS 15, *) {
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : tintColor
            ]
            navigationBarAppearance.backgroundColor = color
            UINavigationBar.appearance().standardAppearance = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
            let tabBarApperance = UITabBarAppearance()
            tabBarApperance.configureWithOpaqueBackground()
            tabBarApperance.backgroundColor = color
            UITabBar.appearance().scrollEdgeAppearance = tabBarApperance
            UITabBar.appearance().standardAppearance = tabBarApperance
            UITabBar.appearance().tintColor = tintColor
            
        }else {
            let navigationController = UINavigationController()
            navigationController.navigationBar.barTintColor = color
            navigationController.navigationBar.tintColor = tintColor
            navigationController.navigationBar.isTranslucent = false
            
            let tabBarApperance = UITabBarAppearance()
            tabBarApperance.configureWithOpaqueBackground()
            tabBarApperance.backgroundColor = color
            UITabBar.appearance().standardAppearance = tabBarApperance
            UITabBar.appearance().tintColor = tintColor
        }
        
    }
}

