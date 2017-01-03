//
//  API.swift
//  Created by ctslin on 4/20/16.


import Foundation
import Alamofire
//import AlamofireObjectMapper

extension String {
  public func hostUrl() -> String {
    return containsString("http") ? self : "\(K.Api.host)\(self)"
  }
}

public class API {
  
  class public func upload(method: Alamofire.Method = .POST, url: String, data: NSData, name: String = "file", filename: String = "\(Lorem.token()).jpg", mimeType: String = "image/jpg", onComplete: (Response<AnyObject, NSError>) -> () = {_ in}) {
    Alamofire.upload(method, url, multipartFormData: { (multipartFormData) in
      multipartFormData.appendBodyPart(data: data, name: name, fileName: filename, mimeType: mimeType)
      }, encodingCompletion: { (result) in
        switch result {
        case .Success(let upload, _, _):
          upload.responseJSON(completionHandler: onComplete)
        case .Failure(let error):
          //          prompt(result)
          break
        }
    })
  }
  
  class public func get(url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {
    request(url: url, parameters: parameters, run: run)
  }
  
  class public func post(url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {
    request(.POST, url: url, parameters: parameters, run: run)
  }
  
  class public func put(url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {
    request(.PUT, url: url, parameters: parameters, run: run)
  }
  
  class public func delete(url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {
    request(.DELETE, url: url, parameters: parameters, run: run)
  }
  
  class func headers(fileName: String? = #file, funcName: String? = #function) -> [String: String] {
    let appId = K.Api.appID
    var headers_ = ["app_id": appId, "file_name": (fileName! as NSString).lastPathComponent, "func_name": funcName!]
      headers_["Authorization"] = K.Api.userToken
      headers_["token"] = (Session.getValueObject(K.Api.userTokenKey) as? String) ?? K.Api.userToken
      if Development.Log.API.header { _logForAnyMode(headers_, title: "headers") }
      return headers_
  }
  
  class public func request(method: Alamofire.Method = .GET, url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: (response: Response<AnyObject, NSError>) -> ()) {
    _logForAnyMode(url.hostUrl(), title: "url.hostUrl()")
    if Development.Log.API.parameters { _logForAnyMode(parameters, title: "parameters") }
    let indicator = indicatorStart()
    let requestStartTime = NSDate()
    var requestTime: Double = 0
    
    Alamofire.request(method, url.hostUrl(), parameters: parameters, headers: headers()).responseJSON { response in
      requestTime = NSDate().timeIntervalSinceDate(requestStartTime)
      processJSONResponse(response, run: run)
      indicatorEnd(indicator)
    }
    //    delayedJob(5) {
    //      _logForAPIMode("*** make a recall for log server to make sure app not crashed!! ***")
    //    }
    
    delayedJob(Development.delayed) {
      _logForAnyMode(requestTime, title: "本次請求秒數: \(method),  \(url)")
    }
  }
  
  class public func sendBody(url:String, body: String, run: (response: Response<AnyObject, NSError>) -> ()) {
    var headers_ = headers()
    headers_["Content-Type"] = "application/json"
    Alamofire.request(.POST, url.hostUrl() , parameters: [:], headers: headers_, encoding: .Custom({
      (convertible, params) in
      let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
      let data = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
      mutableRequest.HTTPBody = data
      return (mutableRequest, nil)
    })).responseJSON { (response) in
      processJSONResponse(response, run: run)
    }
  }
  
  class func processJSONResponse(response: Response<AnyObject, NSError>, run: (response: Response<AnyObject, NSError>) -> ()) {
    if Development.Log.API.request { _logForAnyMode(response.request!, title: "response.request") }
    if Development.Log.API.statusCode { _logForAnyMode((response.response?.statusCode)!, title: "(response.response?.statusCode)!") }
    if Development.Log.API.processInfo { print("NSProcessInfo.processInfo().environment: ", NSProcessInfo.processInfo().environment)}
    
    switch response.result {
    case .Success(let value):
      if Development.Log.API.response { _logForAnyMode(value, title: "response.result.value") }
      if let items = value as? NSArray {
        run(response: response)
      } else if let item = value as? NSDictionary {
        _logForAPIMode(value, title: "value")
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
  }
  
}

