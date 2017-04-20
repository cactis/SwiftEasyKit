//
//  PushServer.swift
//
//  Created by ctslin on 3/4/16.

//

import SwiftEasyKit
import Alamofire

public class PushServer {
  
  public class func subscribeToken(appid: String, name: String, token: String, success: (response: Response<AnyObject, NSError>) -> ()) {
    let url = K.Api.pushserverSubscribe
    let params = ["user_device": [
      "token": token,
      "name":  name,
      "kind": K.Api.deviceType
      ]]
    _logForAnyMode(params, title: "params")
    API.post(url, parameters: params) { (response) in
      success(response: response)
    }
  }
  
}
