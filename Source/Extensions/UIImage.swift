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
import RandomKit
import SwiftRandom

extension UIImage {
  public class func sample() -> UIImage {
    return UIImage.fontAwesomeIconWithName(.ClockO, textColor: UIColor.lightGrayColor().lighter(), size: CGSize(width: 300, height: 300))
  }

  public func toJPEG(compressionQuality: CGFloat = K.Image.jpegCompression) -> NSData {
    return UIImageJPEGRepresentation(self, compressionQuality)!
  }

  public func flipped() -> UIImage {
    return UIImage(CGImage: self.CGImage!, scale: self.scale, orientation: .UpMirrored)
  }

  public func makeImageWithColorAndSize(color: UIColor, size: CGSize = K.Size.barButtonItem) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(CGRectMake(0, 0, size.width, size.height))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }

  public func insetsSize(n: Int = 7) -> UIEdgeInsets {
    let s = CGFloat(CGImageGetHeight(self.CGImage) / n)
    return UIEdgeInsets(top: s, left: s, bottom: s, right: s)
  }
  public func inseted(inset: UIEdgeInsets?) -> UIImage {
    let s = CGFloat(CGImageGetHeight(self.CGImage)) * 0.3
//    _logForUIMode(s)
    let inset_ = inset ?? UIEdgeInsets(top: s, left: s, bottom: s, right: s)
    return resizableImageWithCapInsets(inset_)
  }

  public class func fromCode(drawText: String, color: UIColor = K.Color.barButtonItem, size: CGFloat = K.BarButtonItem.size) -> UIImage {
    let textColor: UIColor = color
    let textFont: UIFont = UIFont(name: K.Font.icon, size: size)!
    let s = size * 1//.2
    let _size = CGSize(width: s, height: s)
    UIGraphicsBeginImageContext(_size)
    let textFontAttributes = [
      NSFontAttributeName: textFont,
      NSForegroundColorAttributeName: textColor,
      ]
//    _logForUIMode(textColor.hexString)
    let image = UIImage()
    let rect = CGRectMake(0, 0, size, size)
    //    let rect = CGRectMake(size * 0.1, size * 0.1, size * 0.8, size * 0.8)
    image.drawInRect(rect)
    drawText.drawInRect(rect, withAttributes: textFontAttributes)

    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
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
  public static func fontAwesomeIconWithNameWithInset(name: FontAwesome, textColor: UIColor, size: CGSize, backgroundColor: UIColor = UIColor.clearColor(), inset: CGFloat = 0) -> UIImage {
    let paragraph = NSMutableParagraphStyle()
    paragraph.alignment = NSTextAlignment.Center

    // Taken from FontAwesome.io's Fixed Width Icon CSS
    let fontAspectRatio: CGFloat = 1.28571429

    let fontSize = min(size.width / fontAspectRatio, size.height)
    let attributedString = NSAttributedString(string: String.fontAwesomeIconWithName(name), attributes: [NSFontAttributeName: UIFont.fontAwesomeOfSize(fontSize), NSForegroundColorAttributeName: textColor, NSBackgroundColorAttributeName: backgroundColor, NSParagraphStyleAttributeName: paragraph])
    var padding: CGFloat = 0
    if inset != 0 { padding = size.width / inset }
    UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width + 2 * padding, height: size.height + 2 * padding), false , 0.0)
    attributedString.drawInRect(CGRectMake(padding, (size.height - fontSize) / 2 + padding, size.width, fontSize))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}

