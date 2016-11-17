//
//  PushServer.swift
//
//  Created by ctslin on 3/4/16.

//

import Foundation

class PushServer {

  class func subscribeToken(appid: String, user: String, deviceToken: String, success: (deviceTokenString: String) -> ()) {
    let url = K.Api.pushserverSubscribe
    let params = ["deviceName":  user, "deviceToken": deviceToken, "deviceType": K.Api.deviceType]
    _logForAnyMode(params, title: "params")
    API.request(.POST, url: url, parameters: params) { (response) in
//      Session.setValue(deviceToken, key: "deviceToken")

    }
  }
  
}
