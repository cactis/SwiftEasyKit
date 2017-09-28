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
// import RandomKit
import SwiftRandom

extension UIImage {

  open class func loadFromURL(url: String) -> UIImage? {
    do {
      let data = try NSData(contentsOf: URL(string: url)!) as Data
      return UIImage(data: data)!
    } catch {
      return nil
    }

  }

  open class func sample() -> UIImage {
    return UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.lightGray.lighter(), size: CGSize(width: 300, height: 300))
  }

  public func toJPEG(compressionQuality: CGFloat = K.Image.jpegCompression) -> NSData {
    return UIImageJPEGRepresentation(self, compressionQuality)! as NSData
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
    _logForUIMode(K.Font.icon, title: "K.Font.icon")
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

