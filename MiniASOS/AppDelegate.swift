//
//  AppDelegate.swift
//  MiniASOS
//
//  Created by Carlo Pascoli on 06/11/2016.
//  Copyright © 2016 Carlo Pascoli. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let appBuilder = AppBuilder()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.lightGray
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.black
        
        // show splash screen
        let splashScreen = self.appBuilder.newSplashScreen()
        self.window?.rootViewController = splashScreen;
        
        self.appBuilder.api.fetchAllProductCategories(onCompletion: { categories in
            // show main app screen
            let mainScreen = self.appBuilder.newMainScreenViewController(productCategories: categories)
            self.window?.rootViewController = mainScreen;            
        })
        
        return true
    }
    
}

