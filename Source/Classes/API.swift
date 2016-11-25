//
//  API.swift
//  Created by ctslin on 4/20/16.


import Foundation
import Alamofire

extension String {
  public func hostUrl() -> String {
    return containsString("http") ? self : "\(K.Api.host)\(self)"
  }
}

public class API {
  
  class public func request(method: Alamofire.Method = .GET, url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {
    
    let appId = K.Api.appID
    var headers = ["app_id": appId, "file_name": (fileName! as NSString).lastPathComponent, "func_name": funcName!]
    headers["Authorization"] = K.Api.userToken
    headers["token"] = (Session.getValueObject(K.Api.userTokenKey) as? String) ?? K.Api.userToken
    //    _logForUIMode(headers, title: "headers")
    let indicator = indicatorStart()
    //    _logForUIMode(url.hostUrl(), title: "url.hostUrl()")
    let requestStartTime = NSDate()
    var requestTime: Double = 0
    Alamofire.request(method, url.hostUrl(), parameters: parameters, headers: headers).responseJSON { response in
      //      _logForUIMode(response.request!, title: "response.request")
      //      print("NSProcessInfo.processInfo().environment: ", NSProcessInfo.processInfo().environment)
      requestTime = NSDate().timeIntervalSinceDate(requestStartTime)
      switch response.result {
      case .Success(let value):
//        _logForUIMode(value, title: "response.result.value!")
        if let items = value as? NSArray {
          run(response: response)
        } else if let item = value as? NSDictionary {
          _logForUIMode((response.response?.statusCode)!, title: "(response.response?.statusCode)!")
          switch (response.response?.statusCode)! {
          case 404:
            prompt(value.objectForKey(K.Api.Response.message) as? String ?? "路徑錯誤!")
          case 400:
            prompt(value.objectForKey(K.Api.Response.message) as? String)
          case 440:
            prompt(value.objectForKey(K.Api.Response.message) as? String)
            delayedJob({
              appDelegate().redirectToLogin()
            })
          case 422:
            prompt(value.objectForKey(K.Api.Response.message) as? String)
          case 500:
            prompt("伺服器內部錯誤，請稍後再試。")
            appDelegate().did500Error()
          default:
            if let message = value.objectForKey(K.Api.Response.message) as? String {
              if let text = message as? String {
                prompt(text)
                response.result.value?.code
              } else if let texts = message as? NSDictionary {
                let text = texts.map{"\($0.key): \($0.value)"}.join("\n")
                prompt(text)
              } else {
              }
            }
            run(response: response)
          }
        } else {
          print(value, "value in API")
          run(response: response)
        }
      case .Failure:
        //        print("response:", response)
        prompt((response.result.error?.localizedDescription)!)
        //        #if DEBUG
        //          prompt((response.result.error?.localizedDescription)!)
        //        #else
        //          if _isSimulator() {
        //          }
        //        #endif
      }
      indicatorEnd(indicator)
    }
    delayedJob(5) {
      _logForAPIMode("*** make a recall for log server to make sure app not crashed!! ***")
    }
    
//    delayedJob(20) {
//      _logForUIMode(requestTime, title: "本次請求秒數: \(method),  \(url)")
//    }
  }
  
}
