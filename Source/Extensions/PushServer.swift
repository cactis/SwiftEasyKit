//
//  PushServer.swift
//
//  Created by ctslin on 3/4/16.

import Alamofire

open class PushServer {

  open class func subscribeToken(name: String?, token: String?) {
    if name != nil && token != nil {
      subscribeToken(appid: K.Api.appID, name: name!, token: token!, success: { (data) in
      })
    }
  }
  
  open class func subscribeToken(appid: String, name: String, token: String, enabled: Bool = true, success: @escaping (_ response: DataResponse<Any>) -> ()) {
    delayedJob(10) {
      
    
    let url = K.Api.pushserverSubscribe
    let params = ["user_device": [
      "token": token,
      "name":  name,
      "enabled": enabled,
      "kind": K.Api.deviceType
      ]]
    _logForAnyMode(params as AnyObject, title: "params")
    API.post(url, parameters: params as [String : AnyObject]) { (response, data) in
      success(response)
    }
    }
  }
}
