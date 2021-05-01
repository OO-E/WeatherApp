//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by OO E on 1.05.2021.
//

import UIKit
import Networking

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        RestClient.setBaseUrl(url: "http://api.openweathermap.org/data/2.5/")
        Loader.initializeLoader()

        
        
        return true
    }


    func applicationWillEnterForeground(_ application: UIApplication) {
        ReachabilityManager.shared.stopMonitoring()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        ReachabilityManager.shared.startMonitoring()
    }

}

extension UIApplication {
    var visibleViewController: UIViewController? {
        
        guard var rootViewController = keyWindow?.rootViewController else {
            return nil
        }
//        if let _side = rootViewController as? SideMenuController {
//            rootViewController = _side.contentViewController
//        }
        
        return getVisibleViewController(rootViewController)
    }
    
    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
        
        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }
        
        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }
        
        return rootViewController
    }
}
