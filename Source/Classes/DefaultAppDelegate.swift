//
//  DefaultAppDelegate.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/29/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation

public class DefaultAppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

  public func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    UITabBar.appearance().tintColor = K.Color.tabBar
    UITabBar.appearance().barTintColor = K.Color.tabBarBackgroundColor
    return true
  }


}