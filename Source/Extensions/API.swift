//
//  API.swift
//  Created by ctslin on 4/20/16.


import Foundation
import Alamofire

public class API {

  class public func request(method: Alamofire.Method = .GET, url: String, parameters: [String: String] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {

    let appId = K.Api.appID
    var headers = ["app_id": appId, "file_name": (fileName! as NSString).lastPathComponent, "func_name": funcName!]
    if let token = Session.getValueObject(K.Api.userTokenKey) as? String {
      headers["token"] = token
    } else {
      headers["token"] = ""
    }
    Alamofire.request(method, url, parameters: parameters, headers: headers).responseJSON { response in
      run(response: response)
    }
    delayedJob(5) {
      _logForAPIMode("*** make a recall for log server to make sure app not crashed!! ***")
    }
  }

}

