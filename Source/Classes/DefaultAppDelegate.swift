//
//  DefaultAppDelegate.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/29/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation

open class DefaultAppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate {

  public var window: UIWindow?
  public var tabBarViewController: UITabBarController?

  open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    UITabBar.appearance().tintColor = K.Color.tabBar
    UITabBar.appearance().barTintColor = K.Color.tabBarBackgroundColor
    enablePushNotification(application)
    return true
  }

  open func enablePushNotification(_ application: UIApplication) {
    let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
    application.registerUserNotificationSettings(settings)
  }

  open func enableTabBarController(_ delegate: UITabBarControllerDelegate, viewControllers: [UIViewController]!, titles: [String]!, images: [UIImage], selectedImages: [UIImage] = []) -> (UIWindow?, UITabBarController?) {
    var _selectedImages = [UIImage]()
    if selectedImages.count > 0 {
      _selectedImages = selectedImages
    } else {
      _selectedImages = images
    }
    let tabBarViewController = UITabBarController()
    let vcs = viewControllers.map({ $0.embededInNavigationController() })
    for (index, vc) in vcs.enumerated() {
      vc.tabBarItem = UITabBarItem(title: titles[index], image: images[index], selectedImage: _selectedImages[index])
      viewControllers[index].titled(titles[index])
    }
    tabBarViewController.viewControllers = vcs
    tabBarViewController.delegate = delegate
    return (bootFrom(tabBarViewController), tabBarViewController)
  }

  open func bootFrom(_ vcs: [UIViewController], liginStatus: Bool) { }

  override open func bootFrom(_ vc: UIViewController) -> UIWindow? {
    let window: UIWindow?  = UIWindow(frame: UIScreen.main.bounds)
    //    window!.backgroundColor = K.Color.body
    window!.rootViewController = vc
    window!.makeKeyAndVisible()
    return window!
  }

  open func redirectToLogin() {
    _logForUIMode()
  }

  open func did500Error() {
    _logForUIMode()
  }

}
