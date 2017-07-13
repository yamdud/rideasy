//
//  AppDelegate.swift
//  rideasy
//
//  Created by Siraprapha Suayngam on 23/01/2017.
//  Copyright © 2017 Gurung. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        // Override point for customization after application launch.
        
        GMSPlacesClient.provideAPIKey("AIzaSyC_XhKkkHB6FRMg2nNIP00jSrAQFZSkh8k")
        //setting the status bar style ligh
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        //removing nav bar border 
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        //navigation bar customisation
        UINavigationBar.appearance().tintColor =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 63/255, green: 94/255, blue: 90/255, alpha: 1.0)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().isTranslucent = false
        
        
       
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func SwitchrootViewController(identifier: String){
        //setting swrevealViewController as intial view controller.
        var controllerIdentifier = ""
        if identifier == "SignInPassengers" {
                controllerIdentifier = "RevealViewController"
        }
        else {
            controllerIdentifier = "RevealViewControllerForDrivers"
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let Storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let viewController = Storyboard.instantiateViewController(withIdentifier: controllerIdentifier)
        //driverHandler.Instance.delegate = viewController as? RideController
//        SWRevealViewController.setRear(<#T##SWRevealViewController#>)
        self.window?.rootViewController = viewController
        self.window?.makeKey()
        //self.window?.becomeKey()
        self.window?.alpha = 0.1
    }

}

