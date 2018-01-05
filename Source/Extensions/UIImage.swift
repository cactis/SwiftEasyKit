//
//  UIImage.swift
//
//  Created by ctslin on 5/18/16.
//

import Foundation
import MapKit
import LoremIpsum
import FontAwesome_swift
import Neon
import SwiftRandom
import Kingfisher
import ObjectMapper
//
//open class AppMappable: Mappable {
//  var id: Int?
//  var createdAt: Date?
//  var updatedAt: Date?
//  var state: String?
//  var status: String?
//  var alert: String?
//  var priButton: String?
//  var subButton: String?
//  var nextEvent: String?
//  open func mapping(map: Map) {
//    id <- map["id"]
//    state <- map["attributes.state"]
//    status <- map["attributes.status"]
//    createdAt <- (map["attributes.createdAt"], DateTransform())
//    updatedAt <- (map["attributes.updatedAt"], DateTransform())
//    alert <- map["attributes.alert"]
//    priButton <- map["attributes.priButton"]
//    subButton <- map["attributes.subButton"]
//    nextEvent <- map["attributes.nextEvent"]
//  }
//
//  required public init?(map: Map) {}
//}

//class DateTransform: TransformType {
//
//  public typealias Object = Date
//  public typealias JSON = String
//
//  public init() {}
//
//  func transformFromJSON(_ value: Any?) -> Date? {
//    if value == nil { return nil }
//    return (value as? String)!.toDate()
//  }
//
//  func transformToJSON(_ value: Date?) -> String? {
//    return value?.toString()
//  }
//}


open class UnSplash: AppMappable {
  public var raw: String?
  public var full: String?
  public var regular: String?
  public var small: String?
  public var thumb: String?
  override open func mapping(map: Map) {
    super.mapping(map: map)
    raw <- map["urls.raw"]
    full <- map["urls.full"]
    regular <- map["urls.regular"]
    small <- map["urls.small"]
    thumb <- map["urls.thumb"]
  }

  public class func random(onComplete: @escaping (_ unsplash: UnSplash?) -> ()) {
    let url = "http://api.unsplash.com/photos/random" + "?client_id=" + K.Api.unplashAppKey
    API.get(url) { (response, data) in
      let unsplash = UnSplash(JSON: (response.result.value as? [String: Any])!)!
      onComplete(unsplash)
    }
  }

  public class func query(keyword: String!, onComplete: @escaping (_ unsplash: [UnSplash]?) -> ()) {
    let url = "http://api.unsplash.com/search/photos?query=\(keyword!)" + "&client_id=" + K.Api.unplashAppKey
    API.get(url) { (response, data) in
      switch response.result {
      case .success(let value):
        if let results = (value as! [String: Any])["results"] as? [[String : Any]] {
          let items = Mapper<UnSplash>().mapArray(JSONArray: results)
          onComplete(items)
        }
      case .failure(let error):
        _logForUIMode(error.localizedDescription)
      }

    }
  }

}

extension String {
  public func toUIImage() -> UIImage {
    return UIImage(url: self)!
  }
}

extension UIImage {

  public convenience init?(url: String!) {
    let from = URL(string: url)
    let data = try? Data(contentsOf: from!)
    self.init(data: data!)!
  }

//  open class func loadFromURL(url: String) -> UIImage? {
//    do {
//      let data = try NSData(contentsOf: URL(string: url)!) as Data
//      return UIImage(data: data)!
//    } catch {
//      return nil
//    }
//  }

  open class func sample() -> UIImage {
    return UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.lightGray.lighter(), size: CGSize(width: 300, height: 300))
  }

  public func toJPEG(compressionQuality: CGFloat = K.Image.jpegCompression) -> Data {
    return UIImageJPEGRepresentation(self, compressionQuality)!
  }

//  public func flipped() -> UIImage {
//    return UIImage(CGImage: self.CGImage!, scale: self.scale, orientation: .upMirrored)
//  }

  public func makeImageWithColorAndSize(color: UIColor, size: CGSize = K.Size.barButtonItem) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }

//  public func insetsSize(n: Int = 7) -> UIEdgeInsets {
//    let s = CGFloat(CGImage.height(self.cgImage!) / n)
//    return UIEdgeInsets(top: s, left: s, bottom: s, right: s)
//  }
//  public func inseted(inset: UIEdgeInsets?) -> UIImage {
//    let s = CGFloat(CGImage.height(self.cgImage!)) * 0.3
////    _logForUIMode(s)
//    let inset_ = inset ?? UIEdgeInsets(top: s, left: s, bottom: s, right: s)
//    return resizableImage(withCapInsets: inset_)
//  }

  open class func fromCode(drawText: String, color: UIColor = K.Color.barButtonItem, size: CGFloat = K.BarButtonItem.size) -> UIImage {
    let textColor: UIColor = color
    let textFont: UIFont = UIFont(name: K.Font.icon, size: size)!
    let s = size * 1//.2
    let _size = CGSize(width: s, height: s)
    UIGraphicsBeginImageContext(_size)
    let textFontAttributes = [
      NSAttributedStringKey.font: textFont,
      NSAttributedStringKey.foregroundColor: textColor,
      ]
//    _logForUIMode(textColor.hexString)
    let image = UIImage()
    let rect = CGRect(x: 0, y: 0, width: size, height: size)
    //    let rect = CGRectMake(size * 0.1, size * 0.1, size * 0.8, size * 0.8)
    image.draw(in: rect)
    drawText.draw(in: rect, withAttributes: textFontAttributes)

    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return newImage
  }

  /// Get a FontAwesome image with the given icon name, text color, size and an optional background color.
  ///
  /// - parameter name: The preferred icon name.
  /// - parameter textColor: The text color.
  /// - parameter size: The image size.
  /// - parameter backgroundColor: The background color (optional).
  /// - returns: A string that will appear as icon with FontAwesome
  public static func fontAwesomeIconWithNameWithInset(name: FontAwesome, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clear, inset: CGFloat = 0) -> UIImage {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = NSTextAlignment.center

    // Taken from FontAwesome.io's Fixed Width Icon CSS
    let fontAspectRatio: CGFloat = 1.28571429

    let fontSize = min(size.width / fontAspectRatio, size.height)

    let attributedString = NSAttributedString(string: String.fontAwesomeIcon(name: name), attributes: [NSAttributedStringKey.font: UIFont.fontAwesome(ofSize: fontSize), NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.backgroundColor: backgroundColor, NSAttributedStringKey.paragraphStyle: paragraph])
    var padding: CGFloat = 0
    if inset != 0 { padding = size.width / inset }
    UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width + 2 * padding, height: size.height + 2 * padding), false , 0.0)
    attributedString.draw(in: CGRect(x: padding, y: (size.height - fontSize) / 2 + padding, width: size.width, height: fontSize))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image!
  }
}

