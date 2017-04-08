//
//  AppDelegate.swift
//  Tindergram
//
//  Created by thomas on 3/31/15.
//  Copyright (c) 2015 thomas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    Parse.setApplicationId(parseAppID, clientKey: parseClientKey)
    PFFacebookUtils.initializeFacebook()
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    var initialViewController: UIViewController
    
    if PFUser.current() != nil {
      initialViewController = pageController
    } else {
      initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") 
    }
    
    window?.rootViewController = initialViewController
    window?.makeKeyAndVisible()
    
    return true
  }
  
  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    return FBAppCall.handleOpen(url, sourceApplication: sourceApplication, with: PFFacebookUtils.session())
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    FBAppCall.handleDidBecomeActive(with: PFFacebookUtils.session())
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    PFFacebookUtils.session()?.close()
  }
  
}

