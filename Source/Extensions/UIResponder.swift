//
//  UIResponder.swift
//  SwiftEasyKit
//
//  Created by ctslin on 8/2/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation

extension UIResponder {

  public func parentViewController() -> UIViewController? {
    if self.nextResponder() is UIViewController {
      return self.nextResponder() as? UIViewController
    } else {
      if self.nextResponder() != nil {
        return (self.nextResponder()!).parentViewController()
      }
      else {return nil}
    }
  }

  public func bootFrom(vc: UIViewController) -> UIWindow? {
    let window: UIWindow?  = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.backgroundColor = K.Color.body
    window!.rootViewController = vc
    window!.makeKeyAndVisible()
    return window!
  }

  public func pushServerAppID() -> String {
    return ""
  }

  public func getDeviceName() -> String {
    let name = UIDevice.currentDevice().name
    return name
  }

  public func getDeviceToken() -> String {
    _logForAnyMode(getDeviceName(), title: "getDeviceName()")
    return Session.getValue(K.Api.deviceTokenKey)!
  }

  public func saveDeviceInfo(token token: String, name: String) {
    _logForAnyMode("\((token, name))", title: "(token, name)")
    Session.setValue(token, key: K.Api.deviceTokenKey)
    Session.setValue(name, key: K.Api.deviceNameKey)
  }

  public func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings){
    application.registerForRemoteNotifications()
  }

  public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    saveDeviceInfo(token: getDeviceTokenString(deviceToken), name: getDeviceName())
//    PushServer.saveToken(pushServerAppID(), user: getDeviceName(), deviceToken: deviceToken, success: { (deviceTokenString) -> () in
////      self.saveDeviceToken(PushServer.getDeviceTokenString(deviceToken), name: self.getDeviceName())
//    })
  }

  public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
  }

  public func applicationWillResignActive(application: UIApplication) {
  }

  public func applicationDidEnterBackground(application: UIApplication) {
  }

  public func applicationWillEnterForeground(application: UIApplication) {
  }

  public func applicationDidBecomeActive(application: UIApplication) {
  }

  public func applicationWillTerminate(application: UIApplication) {
  }

  private func getDeviceTokenString(deviceToken: NSData) -> String {
    let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
    let deviceTokenString: String = ( deviceToken.description as NSString )
      .stringByTrimmingCharactersInSet( characterSet )
      .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
    return deviceTokenString
  }
  
  
}