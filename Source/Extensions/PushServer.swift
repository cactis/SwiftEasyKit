//
//  PushServer.swift
//
//  Created by ctslin on 3/4/16.

//

import Foundation

class PushServer {

  class func saveToken(appid: String, user: String, success: (deviceTokenString: String) -> ()) {
    let deviceTokenString = "anytokenstring"
    saveToken(appid, user: user, deviceToken: deviceTokenString, success: success)
  }

  class func saveToken(appid: String, user: String, deviceToken: NSData, success: (deviceTokenString: String) -> ()) {
    let deviceTokenString = getDeviceTokenString(deviceToken)

    _logForAnyMode(appid, title: "appid")
    _logForAnyMode(user, title: "user")
    _logForAnyMode(deviceTokenString, title: "deviceTokenString")

    saveToken(appid, user: user, deviceToken: deviceTokenString, success: success)
  }

  class func saveToken(appid: String, user: String, deviceToken: String, success: (deviceTokenString: String) -> ()) {
    let url = K.Api.pushserverSubscribe
    let params = ["deviceName":  user, "deviceToken": deviceToken, "deviceType": "ios"]

    _logForAnyMode(params, title: "params")

    API.request(.POST, url: url, parameters: params) { (response) in
      _logForAnyMode(response.request!, title: "response.request!")
      
//      Session.setValue(deviceToken, key: "session_deviceToken")

    }
    
//    let manager = HttpManager.getManager()
//    manager.requestSerializer = AFJSONRequestSerializer()
//    var url: String!
//    if UIHelper.isSimulator() {
//      url = Configure.APP.Host.PushServerTest.rawValue
//    } else {
//      url = Configure.APP.Host.PushServer.rawValue
//    }
//
//    log("url: \(url)")
//
//    //    var pushServerAppID: String!
//    //    if UIHelper.isSimulator() {
//    //      pushServerAppID = "Simulator Device"
//    //    } else {
//    //      pushServerAppID = "NmQ05fUS3zqe4zdOCMGGpqs3I1HUHoTC"
//    //    }
//    let params: NSDictionary = [
//      "appid": appid,
//      "user": user,
//      "type":"ios",
//      "token": deviceToken
//    ]
//    manager.POST(url, parameters: params as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation!, data: AnyObject!) -> Void in
//      success(deviceTokenString: deviceToken)
//      }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//        log(operation, title: "operation: saveToToken.Failure()")
//        log(error.localizedDescription, title: "error.localizedDescription: saveToToken.Failure()")
//    })
  }

  class func getDeviceTokenString(deviceToken: NSData) -> String {
    let characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
    let deviceTokenString: String = ( deviceToken.description as NSString )
      .stringByTrimmingCharactersInSet( characterSet )
      .stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
    return deviceTokenString
  }
}
