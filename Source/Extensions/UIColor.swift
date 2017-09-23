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
// import RandomKit
import SwiftRandom

extension UIColor {

  public var hexString: String {
    let components = self.cgColor.components!

    let red = Float(components[0])
    let green = Float(components[1])
    let blue = Float(components[2])
    return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
  }

  open class func fromRGB(_ red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
  }

  public func tinyLighter() -> UIColor {
    return lighter(0.1)
  }

  public func tinyDarker() -> UIColor {
    return darker(0.1)
  }

  public func lighter(_ diff: CGFloat = 0.2) -> UIColor {
    let color = self
    var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
    if color.getRed(&r, green: &g, blue: &b, alpha: &a){
      return UIColor(red: min(r + diff, 1.0), green: min(g + diff, 1.0), blue: min(b + diff, 1.0), alpha: a)
    }
    return self
  }

  public func darker(_ diff: CGFloat = 0.2) -> UIColor {
    let color = self
    var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
    if color.getRed(&r, green: &g, blue: &b, alpha: &a){
      return UIColor(red: max(r - diff, 0.0), green: max(g - diff, 0.0), blue: max(b - diff, 0.0), alpha: a)
    }
    return self
  }

  open class func fromHex(_ colorCode: String, alpha: Float = 1.0) -> UIColor {
    let scanner = Scanner(string:colorCode)
    var color:UInt32 = 0;
    scanner.scanHexInt32(&color)
    let mask = 0x000000FF
    let r = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
    let g = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
    let b = CGFloat(Float(Int(color) & mask) / 255.0)
    return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
  }

  func isLight() -> Bool {
    var white: CGFloat = 0
    getWhite(&white, alpha: nil)
    return white > 0.5
  }

}

//extension UIColor {
//
//  func lighter(by percentage:CGFloat=30.0) -> UIColor? {
//    return self.adjust(by: abs(percentage) )
//  }
//
//  func darker(by percentage:CGFloat=30.0) -> UIColor? {
//    return self.adjust(by: -1 * abs(percentage) )
//  }
//
//  func adjust(by percentage:CGFloat=30.0) -> UIColor? {
//    var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
//    if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
//      return UIColor(red: min(r + percentage/100, 1.0),
//                     green: min(g + percentage/100, 1.0),
//                     blue: min(b + percentage/100, 1.0),
//                     alpha: a)
//    }else{
//      return nil
//    }
//  }
//}

