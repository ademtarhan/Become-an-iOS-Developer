//
//  AppDelegate.swift
//  EggTimer-(Part4)
//
//  Created by Adem Tarhan on 16.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    var rootViewController: UIViewController! {
        get {
            window?.rootViewController
        }
        set {
            window?.rootViewController = newValue
            window?.makeKeyAndVisible()
        }
    }

    private func initWindow() {
        
        let navigation = UINavigationController(nibName: "HomeViewController", bundle: nil)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
    }

    private func initRoot() {
        let home = ViewControllerFactory.shared.home
        
        let root = UINavigationController(rootViewController: home as! UIViewController)
        rootViewController = root
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        initWindow()
        initRoot()
        return true
    }
}
