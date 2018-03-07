//
//  API.swift
//  Created by ctslin on 4/20/16.

import Foundation
import Alamofire
import ObjectMapper
import SwiftyUserDefaults

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

  class public func getHtml(url: String, cached: Bool = true, onSuccess: @escaping (_ response: String) -> ()) {
    if cached == true, let text = Defaults.object(forKey: url) as? String {
//      _logForUIMode("load from cache")
      onSuccess(text)
    } else {
//      _logForUIMode("load from web")
//      _logForUIMode(url, title: "url")
      URLCache.shared.removeAllCachedResponses()
      Alamofire.request(url).responseString { (response) in
        onSuccess(response.result.value!)
      }
    }
  }

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
  }

  class public func get(_ url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>, _ data: Any?) -> () = {_,_ in }) {
    request(url: url, parameters: parameters, run: run)
  }

  class public func post(_ url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>, _ data: Any?) -> ()) {
    request(.post, url: url, parameters: parameters, run: run)
  }

  class public func put(_ url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>, _ data: Any?) -> ()) {
    request(.put, url: url, parameters: parameters, run: run)
  }

  class public func delete(_ url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>, _ data: Any?) -> ()) {
    request(.delete, url: url, parameters: parameters, run: run)
  }

  class func headers(_ fileName: String? = #file, funcName: String? = #function) -> [String: String] {
    let appId = K.Api.appID
    var headers_ = ["app_id": appId, "file_name": (fileName! as NSString).lastPathComponent, "func_name": funcName!]
    headers_["Authorization"] = K.Api.userToken
    headers_["userDeviceName"] = K.Api.userDeviceName
    headers_["userDeviceToken"] = K.Api.userDeviceToken
    headers_["extra"] = K.Api.extra
    headers_["device"] = K.Api.device
    return headers_
  }

  class public func request(_ method: HTTPMethod = .get, url: String, parameters: [String: AnyObject] = [:], fileName: String? = #file, funcName: String? = #function, run: @escaping (_ response: DataResponse<Any>, _ data: Any?) -> ()) {
    let indicator = indicatorStart()
    let requestStartTime = NSDate()
    var requestTime: Double = 0
    _logForUIMode(url, title: "url")
    let _url = URL(string: url.hostUrl().addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)
    _logForUIMode(_url, title: "_url")
//    _logForAnyMode(headers(), title: "headers")
    Alamofire.request(_url!, method: method, parameters: parameters, headers: headers()).responseJSON { response in
//      requestTime = NSDate().timeIntervalSince(requestStartTime as Date)
      processJSONResponse(response, run: run)
      indicatorEnd(indicator: indicator)
    }
//    delayedJob(Development.delayed) {
//      _logForAnyMode(requestTime, title: "本次請求秒數: \(method),  \(url)")
//    }
  }

  class func asciiEscape(s: String) -> String {
    var out : String = ""
    for char in s.unicodeScalars {
      var esc = "\(char)"
      if !char.isASCII {
        esc = NSString(format:"\\u%04x", char.value) as String
      } else {
        esc = "\(char)"
      }
      out += esc
    }
    return out
  }

  class func processJSONResponse(_ response: DataResponse<Any>, run: (_ response: DataResponse<Any>, _ data: Any?) -> ()) {
    if Development.Log.API.request { _logForAnyMode(response.request!, title: "response.request") }
    switch response.result {
    case .success(let value):
      if value is NSArray { // 傳回陣列
        run(response, nil)
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
          switch K.Api.adapter {
          case "json_api":
            run(response, (response.result.value as! [String: Any])["data"])
          default:
            run(response, response.result.value)
          }
        }
      } else {
        run(response, nil)
      }
    case .failure:
      prompt((response.result.error?.localizedDescription)!)
    }
  }

}
//
//extension String {
//
//  func encodeURIComponent() -> String? {
//    var characterSet = NSMutableCharacterSet.alphanumeric()
//    characterSet.addCharacters(in: "-_.!~*'()")
//
//    return NSString(self).stringByAddingPercentEncodingWithAllowedCharacters(characterSet)
//  }
//}

extension String.UnicodeScalarView {
  public init<S: Sequence>(ascii: S) where S.Iterator.Element == UInt8 {
    var _self = String.UnicodeScalarView()
    _self.append(contentsOf: ascii.map(UnicodeScalar.init))
    self = _self
  }

  public init(ascii: UInt8...) {
    self.init(ascii: ascii)
  }
}

extension String {
  public init(ascii: UInt8...) {
    self = String(UnicodeScalarView(ascii: ascii))
  }
}

