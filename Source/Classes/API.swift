//
//  API.swift
//  Created by ctslin on 4/20/16.

import Foundation
import Alamofire
import ObjectMapper

extension String {
  public func hostUrl() -> String {
    return self.contains("http") ? self : "\(K.Api.host)\(self)"
  }
}

class PageMeta: Mappable {
  var perPage: Int?
  var totalPages: Int?
  var totalObjects: Int?

  func mapping(map: Map) {
    perPage <- map["per_page"]
    totalPages <- map["total_pages"]
    totalObjects <- map["total_objects"]
  }
  required init?(map: Map) { }
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
    return headers_
  }

  class public func request(_ method: HTTPMethod = .get, url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>) -> ()) {
    let indicator = indicatorStart()
    let requestStartTime = NSDate()
    var requestTime: Double = 0
    let _url = URL(string: url.hostUrl().addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
    _logForUIMode(_url, title: "_url")
    _logForAnyMode(headers(), title: "headers")
    Alamofire.request(_url!, method: method, parameters: parameters, headers: headers()).responseJSON { response in
      requestTime = NSDate().timeIntervalSince(requestStartTime as Date)
      processJSONResponse(response, run: run)
      indicatorEnd(indicator: indicator)
    }
    delayedJob(Development.delayed) {
      _logForAnyMode(requestTime, title: "本次請求秒數: \(method),  \(url)")
    }
  }

  class func processJSONResponse(_ response: DataResponse<Any>, run: (_ response: DataResponse<Any>) -> ()) {
    if Development.Log.API.request { _logForAnyMode(response.request!, title: "response.request") }
    switch response.result {
    case .success(let value):
      if value is NSArray { // 傳回陣列
        run(response)
      } else if let item = value as? NSDictionary { // 傳回 JSON
        if let debug = item.value(forKey: "debug") as? String { if _isWho("CT") { prompt(debug) } }
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
          // 處理訊息
          if let message = item.value(forKey: K.Api.Response.message) as? String {
            prompt(message)
          } else if let texts = item.value(forKey: K.Api.Response.message) as? NSDictionary {
            let text = texts.map{"\($0.key): \($0.value)"}.join("\n")
            prompt(text)
          }
          run(response)
        }
      } else {
        run(response)
      }
    case .failure:
      prompt((response.result.error?.localizedDescription)!)
    }
  }
  
}

