//
//  DefaultAppDelegate.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/29/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation
import FontAwesome_swift
import UserNotifications
import IQKeyboardManagerSwift

open class DefaultAppDelegate: UIResponder, UIApplicationDelegate, UITabBarControllerDelegate, UNUserNotificationCenterDelegate {

  open func preLoad() {}

  public var window: UIWindow?
  public var tabBarViewController: UITabBarController?

  @discardableResult open func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
    UITabBar.appearance().tintColor = K.Color.tabBar
//    UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: K.Color.tabBar], for: .selected)
//        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: K.Color.tabBar], for: .unsel)
    UITabBar.appearance().barTintColor = K.Color.tabBarBackgroundColor
    if #available(iOS 10.0, *) {
      UITabBar.appearance().unselectedItemTintColor = K.Color.tabBarUnselected
    } else {
      // Fallback on earlier versions
    }
    // 請求推播授權
    requestToAllowUserNotification(application)
    IQKeyboardManager.sharedManager().enable = true
    return true
  }

  // 請求推播授權
  public func requestToAllowUserNotification(_ application: UIApplication) {
    if _isSimulator() {
      let name = "Simulator - \(Development.developer)"
      setDeviceInfo(name: name, token: name)
      sendTokenToPushServer(name, name: name, enabled: false)
    }
    if #available(iOS 10.0, *) {
      let center = UNUserNotificationCenter.current()
      center.delegate = self
      center.requestAuthorization(options: [.alert, .badge, .sound], completionHandler: { (granted, error) in
        if granted {
          center.getNotificationSettings(completionHandler: { (settings) in
//            _logForAnyMode(settings, title: "settings")
          })
          DispatchQueue.main.async(execute: { UIApplication.shared.registerForRemoteNotifications() })
        } else {
          _logForAnyMode("ios 10+ request fail")
        }
      })
    } else {
      let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
  }
  
  open func setDeviceInfo(name: String, token: String) {}


  // 前景/背景時，用戶點擊推播切回時
  @available(iOS 10.0, *)
  open func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    didNotificationTapped(userInfo: response.notification.request.content.userInfo)
  }

  // 專門處理用戶點擊推播後的控制
  open func didNotificationTapped(userInfo: [AnyHashable: Any]) { }

  open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let token = getDeviceTokenString(deviceToken)
    let name = getDeviceName()
    sendTokenToPushServer(token, name: name)
  }

  open func enableTabBarController(_ delegate: UITabBarControllerDelegate, viewControllers: [UIViewController]!, titles: [String]!, images: [UIImage], selectedImages: [UIImage] = []) -> (UIWindow?, UITabBarController?) {
//    _logForAnyMode("work!")
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

//  open func bootFrom(_ vcs: [UIViewController], liginStatus: Bool) { }

  open func bootFrom(_ vc: UIViewController) -> UIWindow? {
//    _logForAnyMode("work!")
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


//  public func icon(_ name: FontAwesome, selected: Bool = false) -> UIImage {
//    let size = 30
//    let color = selected ? K.Color.tabBar : K.Color.tabBarUnselected
//    return getIcon(name, options: ["color": color, "size": size])
//  }

}
