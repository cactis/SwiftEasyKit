//
//  DefaultAppDelegate.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/29/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation
import UserNotifications

open class DefaultAppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate {

  public var window: UIWindow?
  public var tabBarViewController: UITabBarController?

  @discardableResult open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    _logForAnyMode("1-2")
    UITabBar.appearance().tintColor = K.Color.tabBar
    UITabBar.appearance().barTintColor = K.Color.tabBarBackgroundColor

    if #available(iOS 10.0, *) {
      let center = UNUserNotificationCenter.current()
      center.delegate = self
      center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
        if granted {
          _logForAnyMode("success!")
          center.getNotificationSettings(completionHandler: { (settings) in
            _logForAnyMode(settings, title: "settings")
          })
          DispatchQueue.main.async(execute: {
            UIApplication.shared.registerForRemoteNotifications()
          })
        } else {
          _logForAnyMode("ios 10+ request fail")
        }
      })
//      application.registerForRemoteNotifications()
    } else {
      let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    return true
  }

  @available(iOS 10.0, *)
  public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    _logForAnyMode()
  }

  @available(iOS 10.0, *)
  public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    _logForAnyMode()
  }

//  open override func application(_ application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
//    _logForAnyMode()
//  }

  open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    _logForAnyMode("work!")
    let token = getDeviceTokenString(deviceToken as Data)
    let name = getDeviceName()
    saveDeviceInfo(token, name: name)
    sendTokenToPushServer(token, name: name)
  }

  open func enableTabBarController(_ delegate: UITabBarControllerDelegate, viewControllers: [UIViewController]!, titles: [String]!, images: [UIImage], selectedImages: [UIImage] = []) -> (UIWindow?, UITabBarController?) {
    _logForAnyMode("work!")
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
    _logForAnyMode("work!")
    let window: UIWindow?  = UIWindow(frame: UIScreen.main.bounds)
    window!.rootViewController = vc
    window!.makeKeyAndVisible()
    return window!
  }

  open func redirectToLogin() {
    _logForAnyMode()
  }

  open func did500Error() {
    _logForAnyMode()
  }

}
