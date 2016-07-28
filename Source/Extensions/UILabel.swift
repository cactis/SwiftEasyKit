//
//  UILabel.swift
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

extension UILabel {

  func iconFonted(iconCode: String, iconColor: UIColor = K.Color.Segment.deactive, size: CGFloat = K.BarButtonItem.size) -> UILabel {
    self.text(iconCode)
    self.font = UIFont(name: K.Font.icon, size: size)
    self.textColor = iconColor
    return self
  }

  func sized(size: CGFloat) -> UILabel {
    font = UIFont(name: font.fontName , size: size)
    return self
  }

  func smaller(n: CGFloat = 1) -> UILabel {
    font = UIFont(name: font.fontName, size: font.pointSize - n)
    return self
  }

  func larger(n: CGFloat = 1) -> UILabel {
    smaller(-1 * n)
    return self
  }

  func colored(color: UIColor) -> UILabel {
    textColor = color
    return self
  }

  func fontName(name: String) -> String {
    font = UIFont(name: name, size: font.pointSize)
    return font.fontName
  }

  func styled(value: String, options: NSDictionary = NSDictionary()) -> UILabel {
    self.text(value).styled(options)
    return self
  }

  func styled(options: NSDictionary = NSDictionary()) -> UILabel {
    //    text = text ?? Lorem.name()
    let color = options["color"] as? UIColor ?? K.Color.text
    let size: CGFloat = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Text.normal
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clearColor()

    textColor = color
    font = UIFont.systemFontOfSize(size)
    self.backgroundColor = backgroundColor
    return self
  }

  func html(html: NSAttributedString) -> UILabel {
    self.attributedText = html
    return self
  }

  func aligned(align: NSTextAlignment = .Left) -> UILabel {
    textAlignment = align
    return self
  }

  func appendText(value: String) -> UILabel {
    text("\(text!)\(value)")
    return self
  }

  func text(iconCode: String, text: String, size: CGFloat = K.Size.Text.normal) -> UILabel {
//    let iconAttribute = [NSFontAttributeName: UIFont(name: K.Font.icon, size: size)!, NSBaselineOffsetAttributeName: -1 * size / 4  ]
    let iconAttribute = [NSFontAttributeName: UIFont(name: K.Font.icon, size: size)!]
    let iconString = NSMutableAttributedString(string: iconCode, attributes: iconAttribute )
    let textString = NSAttributedString(string: " \(text)", attributes: [
                                          NSFontAttributeName: UIFont(name: font.fontName, size: size * 0.8)!,
                                          NSBaselineOffsetAttributeName: size / 5])
    iconString.appendAttributedString(textString)
    attributedText = iconString
    baselineAdjustment = .AlignBaselines
    return self
  }

  func lighter(diff: CGFloat = 0.2) -> UILabel {
    colored(textColor.lighter(diff))
    return self
  }

  func darker(diff: CGFloat = 0.2) -> UILabel {
    colored(textColor.darker(diff))
    return self
  }

  func text(value: String) -> UILabel {
    text = value
    return self
  }

  func attributedText(value: NSAttributedString) -> UILabel {
    attributedText = value
    return self
  }

  func textWidth() -> CGFloat {
    return intrinsicContentSize().width
  }

  func centered() -> UILabel {
    textAlignment = .Center
    return self
  }

  func multilinized() -> UILabel {
    numberOfLines = 0
    //    setLineHeight(textHeight())
    lineBreakMode = .ByWordWrapping
    return self
  }

  func setLineHeight(size: CGFloat = 6) -> UILabel {
    let text = self.text ?? ""
    let style = NSMutableParagraphStyle()
    style.lineSpacing = size
    //    style.lineHeightMultiple = size
    let attributes = [NSParagraphStyleAttributeName: style]
    self.attributedText = NSAttributedString(string: text, attributes: attributes)
    return self
  }

  func textHeight() -> CGFloat {
    return font.pointSize
  }

  func getHeightBySizeThatFitsWithWidth(width: CGFloat) -> CGFloat {
    return sizeThatFits(CGSizeMake(width, 100000)).height
  }
}