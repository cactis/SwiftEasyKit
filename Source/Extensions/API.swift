//
//  API.swift
//  Created by ctslin on 4/20/16.


import Foundation
import Alamofire

public class API {

  class func getUserToken() -> String {
    return K.Api.userToken  //"/* override getUserToken() */"
  }

  class public func request(method: Alamofire.Method = .GET, url: String, parameters: [String: String] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {

    _logForAPIMode(url, title: "url")

    var params = [String: String]()
    params = parameters
    let token = getUserToken()
    let appId = "appid-specified-by-server"
    Alamofire.request(method, url, parameters: params, headers: ["app_id": appId, "token": token, "file_name": (fileName! as NSString).lastPathComponent, "func_name": funcName!]).responseJSON { response in
      run(response: response)
    }
    delayedJob(5) { 
      _logForAPIMode("*** make a recall for log server to make sure app not crashed!! ***")
    }
  }
}

