//
//  UIResponder.swift
//  SwiftEasyKit
//
//  Created by ctslin on 8/2/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation
import Alamofire

extension UIResponder {

  open func parentViewController() -> UIViewController? {
    if self.next is UIViewController {
      return self.next as? UIViewController
    } else {
      if self.next != nil {
        return (self.next!).parentViewController()
      }
      else {return nil}
    }
  }

  @objc open func bootFrom(_ vc: UIViewController) -> UIWindow? {
    let window: UIWindow?  = UIWindow(frame: UIScreen.main.bounds)
    window!.backgroundColor = K.Color.body
    window!.rootViewController = vc
    window!.makeKeyAndVisible()
    return window!
  }

  open func pushServerAppID() -> String {
    return ""
  }

  open func getDeviceName() -> String {
    let name = UIDevice.current.name
    return name
  }

  open func getDeviceToken() -> String {
    _logForAnyMode(getDeviceName(), title: "getDeviceName()")
    return Session.getValue(key: K.Api.deviceTokenKey)!
  }

  open func saveDeviceInfo(_ token: String, name: String) {
    //    _logForAnyMode("\((token, name))", title: "(token, name)")
    Session.setValue(value: token, key: K.Api.deviceTokenKey)
    Session.setValue(value: name, key: K.Api.deviceNameKey)
  }

  open func application(_ application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings){
    application.registerForRemoteNotifications()
  }

  open func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let token = getDeviceTokenString(deviceToken as Data)
    let name = getDeviceName()
    saveDeviceInfo(token, name: name)
    sendTokenToPushServer(token, name: name)
  }

  func sendTokenToPushServer(_ token: String, name: String, success: @escaping (_ response: DataResponse<Any>) -> () = {_ in }) {
    PushServer.subscribeToken(appid: K.Api.appID, name: name, token: token, success: success)
  }

  open func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
  }

  @nonobjc open func applicationWillResignActive(_ application: UIApplication) {
  }

  @objc open func applicationDidEnterBackground(_ application: UIApplication) {
  }

  @objc open func applicationWillEnterForeground(_ application: UIApplication) {
  }

  @objc open func applicationDidBecomeActive(_ application: UIApplication) {
  }

  @objc open func applicationWillTerminate(_ application: UIApplication) {
  }

  private func getDeviceTokenString(_ deviceToken: Data) -> String {
    return deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//    let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
//    let deviceTokenString: String = ( deviceToken.description as NSString )
//      .stringByTrimmingCharactersInSet( characterSet )
//      .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
//    return deviceTokenString
  }
}
