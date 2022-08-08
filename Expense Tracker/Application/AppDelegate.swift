//
//  AppDelegate.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        Application.shared.prepareDataForChart()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        Application.shared.configureAppInterfaceInitial(window!)
        
        return true
    }

}

