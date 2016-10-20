//
//  API.swift
//  Created by ctslin on 4/20/16.


import Foundation
import Alamofire

public class API {

  class public func request(method: Alamofire.Method = .GET, url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {

    let appId = K.Api.appID
    var headers = ["app_id": appId, "file_name": (fileName! as NSString).lastPathComponent, "func_name": funcName!]
    if let token = Session.getValueObject(K.Api.userTokenKey) as? String {
      headers["token"] = token
    } else {
      headers["token"] = ""
    }
    let path = url.containsString("http") ? url : "\(K.Api.host)\(url)"
    print("path", path)


    let indicator = indicatorStart()
    Alamofire.request(method, path, parameters: parameters, headers: headers).responseJSON { response in
      print("reponse.request", response.request)
      print("NSProcessInfo.processInfo().environment: ", NSProcessInfo.processInfo().environment)
      switch response.result {
      case .Success(let value):
        print("response: ", response)
        if let items = value as? NSArray {
          run(response: response)
        } else {
          if let message = value.objectForKey(K.Api.Response.message) {
            prompt(message as! String)
          } else {
            print("response:", response)
            run(response: response)
          }
        }
      case .Failure:
        print("response:", response)
        //        #if DEBUG
        //          prompt((response.result.error?.localizedDescription)!)
        //        #else
        //          if _isSimulator() {
        prompt((response.result.error?.localizedDescription)!)
        //          }
        //        #endif

      }
      //      if let value = response.result.value {
      ////      if let value = (response.result.value as? NSDictionary) {
      //        if let error = value.objectForKey(K.Api.Response.error) {
      //          prompt(error as! String)
      //        } else {
      //          print("response:", response)
      //          run(response: response)
      //        }
      //      } else {
      //        print("response:", response)
      ////        run(response: response)
      //      }
      indicatorEnd(indicator)
    }
    delayedJob(5) {
      _logForAPIMode("*** make a recall for log server to make sure app not crashed!! ***")
    }
  }
  
}

