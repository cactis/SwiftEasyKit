//
//  API.swift
//  Created by ctslin on 4/20/16.


import Foundation
import Alamofire
//import AlamofireObjectMapper

extension String {
  public func hostUrl() -> String {
    return self.contains("http") ? self : "\(K.Api.host)\(self)"
  }
}

open class API {
  
  class public func upload(_ method: HTTPMethod = .post, url: String, data: Data, name: String = "file", fileName: String = "\(Lorem.token()).jpg", mimeType: String = "image/jpg", onComplete: @escaping (DataResponse<Any>) -> () = {_ in}) {
    Alamofire.upload(multipartFormData: { (form) in
      form.append(data, withName: name, fileName: fileName, mimeType: mimeType)
    }, to: url.hostUrl(), method: method, headers: headers()) { (result) in
      switch result {
      case .success(let upload, _, _):
        upload.responseJSON(completionHandler: onComplete)
      case .failure(let error):
        prompt(error.localizedDescription)
      }
    }
    _logForUIMode(K.Api.userToken, title: "K.Api.userToken")
    _logForUIMode(K.Api.userToken)

    //    Alamofire.upload(method, url.hostUrl(), headers: headers(), multipartFormData: { (multipartFormData) in
    //      multipartFormData.appendBodyPart(data: data, name: name, fileName: filename, mimeType: mimeType)
    //      }, encodingCompletion: { (result) in
    //        switch result {
    //        case .success(let upload, _, _):
    //          upload.responseJSON(completionHandler: onComplete)
    //        case .failure(let error):
    //          //          prompt(result)
    //          break
    //        }
    //    })
  }
  
  class public func get(_ url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>) -> ()) {
    request(url: url, parameters: parameters, run: run)
  }
  
  class public func post(_ url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>) -> ()) {
    request(.post, url: url, parameters: parameters, run: run)
  }
  
  class public func put(_ url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>) -> ()) {
    request(.put, url: url, parameters: parameters, run: run)
  }
  
  class public func delete(_ url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>) -> ()) {
    request(.delete, url: url, parameters: parameters, run: run)
  }
  
  class func headers(_ fileName: String? = #file, funcName: String? = #function) -> [String: String] {
    let appId = K.Api.appID
    var headers_ = ["app_id": appId, "file_name": (fileName! as NSString).lastPathComponent, "func_name": funcName!]
    headers_["Authorization"] = K.Api.userToken
//    headers_["token"] = Session.getValue(key: K.Api.userTokenKey) ?? K.Api.userToken
    //    if Development.Log.API.header { _logForAnyobj: Mode(headers_, title: "headers") }
    return headers_
  }
  
  class public func request(_ method: HTTPMethod = .get, url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>) -> ()) {
    //    _logForAnyMode(url.hostUrl(), title: "url.hostUrl()")
    //    if Development.Log.API.parameters { _logForAnyMode(parameters as AnyObject, title: "parameters") }
    let indicator = indicatorStart()
    let requestStartTime = NSDate()
    var requestTime: Double = 0
    //    let _url = NSURL(string: url.hostUrl().stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
    let _url = URL(string: url.hostUrl().addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
    _logForUIMode(_url, title: "_url")
    Alamofire.request(_url!, method: method, parameters: parameters, headers: headers()).responseJSON { response in
      requestTime = NSDate().timeIntervalSince(requestStartTime as Date)
      processJSONResponse(response, run: run)
      indicatorEnd(indicator: indicator)
    }
    //    delayedJob(5) {
    //      _logForAPIMode("*** make a recall for log server to make sure app not crashed!! ***")
    //    }
    
    delayedJob(Development.delayed) {
      _logForAnyMode(requestTime, title: "本次請求秒數: \(method),  \(url)")
    }
  }
  
  //  class public func sendBody(_ url:String, body: String, run: (_ response: DataResponse<Any>) -> ()) {
  //    var headers_ = headers()
  //    headers_["Content-Type"] = "application/json"
  //    let _url = URL(string: url.hostUrl().addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
  //    Alamofire.request(_url!, method: .post, parameters: [:], encoding: .custom, headers: headers_({
  //      (convertible, params) in
  //      let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
  //      let data = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
  //      mutableRequest.HTTPBody = data
  //      return (mutableRequest, nil)
  //    })).responseJSON { (response) in
  //      processJSONResponse(response, run: run)
  //    }
  //  }
  
  class func processJSONResponse(_ response: DataResponse<Any>, run: (_ response: DataResponse<Any>) -> ()) {
    if Development.Log.API.request { _logForAnyMode(response.request!, title: "response.request") }
    //    if Deve_ lopment.Log.API.statusCode { _logForAnyMode((response.response?.statusCode)!, title: "(response.response?.statusCode)!") }
    //    if Development.Log.API.processInfo { print("NSProcessInfo.processInfo().environment: ", NSProcessInfo.processInfo().environment)}
    
    switch response.result {
    case .success(let value):
      // if Development.Log.API.response { _logForAnyMode(value as AnyObject, title: "response.result.value") }
      if value is NSArray {
        run(response)
      } else if let item = value as? NSDictionary {
        //        _logForAPIMode(value, title: "value" as AnyObject)
        //        _logForAPIMode(response.request?.url as AnyObject, title: "response.request.URL")
        let message = item.value(forKey: K.Api.Response.message) as? String
        switch (response.response?.statusCode)! {
        case 400, 404, 405, 422:
          prompt(message ?? "路徑錯誤!")
        case 440:
          prompt(message)
          delayedJob({
            appDelegate().redirectToLogin()
          })
        case 500:
          prompt(message ?? "伺服器內部錯誤，請稍後再試。")
          appDelegate().did500Error()
        default:
          if let message = item.value(forKey: K.Api.Response.message) as? String {
            //            if let text = message as? String {
            prompt(message)
          } else if let texts = item.value(forKey: K.Api.Response.message) as? NSDictionary {
            let text = texts.map{"\($0.key): \($0.value)"}.join("\n")
            prompt(text)
            //            } else {
            //            }
          }
          run(response)
        }
      } else {
        run(response)
      }
    case .failure:
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

