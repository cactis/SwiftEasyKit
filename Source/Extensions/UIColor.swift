//
//  UIColor.swift
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

extension UIColor {

  public var hexString: String {
    let components = CGColorGetComponents(self.CGColor)

    let red = Float(components[0])
    let green = Float(components[1])
    let blue = Float(components[2])
    return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
  }

  public class func fromRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
  }

  public func tinyLighter() -> UIColor {
    return lighter(0.1)
  }

  public func tinyDarker() -> UIColor {
    return darker(0.1)
  }

  public func lighter(diff: CGFloat = 0.2) -> UIColor {
    let color = self
    var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
    if color.getRed(&r, green: &g, blue: &b, alpha: &a){
      return UIColor(red: min(r + diff, 1.0), green: min(g + diff, 1.0), blue: min(b + diff, 1.0), alpha: a)
    }
    return UIColor()
  }

  public func darker(diff: CGFloat = 0.2) -> UIColor {
    let color = self
    var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
    if color.getRed(&r, green: &g, blue: &b, alpha: &a){
      return UIColor(red: max(r - diff, 0.0), green: max(g - diff, 0.0), blue: max(b - diff, 0.0), alpha: a)
    }
    return UIColor()
  }

  public class func fromHex(colorCode: String, alpha: Float = 1.0) -> UIColor {
    let scanner = NSScanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt(&color)
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
    let b = CGFloat(Float(Int(color) & mask) / 255.0)
    return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
  }

}
