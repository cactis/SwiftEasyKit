//
//  PushServer.swift
//
//  Created by ctslin on 3/4/16.

import Alamofire

open class PushServer {

  open class func subscribeToken(appid: String, name: String, token: String, success: @escaping (_ response: DataResponse<Any>) -> ()) {
    let url = K.Api.pushserverSubscribe
    let params = ["user_device": [
      "token": token,
      "name":  name,
      "kind": K.Api.deviceType
      ]]
    _logForAnyMode(params as AnyObject, title: "params")
    API.post(url, parameters: params as [String : AnyObject]) { (response, data) in
      success(response)
    }
  }

}
