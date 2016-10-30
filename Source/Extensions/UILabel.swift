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

  public convenience init(text: String) {
    self.init(frame: CGRectZero)
    self.text = text
  }

  public func iconFonted(iconCode: String, iconColor: UIColor = K.Color.Segment.deactive, size: CGFloat = K.BarButtonItem.size) -> UILabel {
    self.text(iconCode)
    self.font = UIFont(name: K.Font.icon, size: size)
    self.textColor = iconColor
    return self
  }

  public func sized(size: CGFloat) -> UILabel {
    font = UIFont(name: font.fontName , size: size)
    return self
  }

  public func smaller(n: CGFloat = 1) -> UILabel {
    font = UIFont(name: font.fontName, size: font.pointSize - n)
    return self
  }

  public func larger(n: CGFloat = 1) -> UILabel {
    smaller(-1 * n)
    return self
  }

  public func colored(color: UIColor) -> UILabel {
    textColor = color
    return self
  }

  public func fontName(name: String) -> String {
    font = UIFont(name: name, size: font.pointSize)
    return font.fontName
  }

  public func styled(value: String, options: NSDictionary = NSDictionary()) -> UILabel {
    self.text(value).styled(options)
    return self
  }

  public func styled(options: NSDictionary = NSDictionary()) -> UILabel {
    //    text = text ?? Lorem.name()
    let color = options["color"] as? UIColor ?? K.Color.text
    let size: CGFloat = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Text.normal
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clearColor()

    textColor = color
    font = UIFont.systemFontOfSize(size)
    self.backgroundColor = backgroundColor
    return self
  }

  public var linesCount: Int {
    let size = sizeThatFits(CGSizeMake(self.frame.size.width, CGFloat.max))
    return [(size.height / self.font.lineHeight).int, 0].maxElement()!
  }

  public func html(html: NSAttributedString) -> UILabel {
    self.attributedText = html
    return self
  }

  public func aligned(align: NSTextAlignment = .Left) -> UILabel {
    textAlignment = align
    return self
  }

  public func appendText(value: String) -> UILabel {
    text("\(text!)\(value)")
    return self
  }

  public func text(iconCode: String, text: String, size: CGFloat = K.Size.Text.normal) -> UILabel {
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

  public func lighter(diff: CGFloat = 0.2) -> UILabel {
    colored(textColor.lighter(diff))
    return self
  }

  public func darker(diff: CGFloat = 0.2) -> UILabel {
    colored(textColor.darker(diff))
    return self
  }

  @available(iOS 8.2, *)
  public func weighted(weight: CGFloat = UIFontWeightLight) -> UILabel {
    font = UIFont.systemFontOfSize(font.pointSize, weight:  weight)
    return self
  }

  public func bold(bolded: Bool = true) -> UILabel {
    if bolded {
      font = UIFont.boldSystemFontOfSize(font.pointSize)
    } else {
      font = UIFont.systemFontOfSize(font.pointSize)
    }
    return self
  }

  public func text(value: String) -> UILabel {
    text = value
    return self
  }

  public func fitTexted(value: String) -> UILabel {
    return text(value).reFit()
  }

  public func reFit() -> UILabel {
    adjustsFontSizeToFitWidth = true
    return self
  }

  public func attributedText(value: NSAttributedString) -> UILabel {
    attributedText = value
    return self
  }

  public func textWidth() -> CGFloat {
    return intrinsicContentSize().width
  }

  public func centered() -> UILabel {
    textAlignment = .Center
    return self
  }

  public func multilinized() -> UILabel {
    numberOfLines = 0
    //    setLineHeight(textHeight())
    lineBreakMode = .ByWordWrapping
    return self
  }

  public func setLineHeight(size: CGFloat = 6) -> UILabel {
    let text = self.text ?? ""
    let style = NSMutableParagraphStyle()
    style.lineSpacing = size
    //    style.lineHeightMultiple = size
    let attributes = [NSParagraphStyleAttributeName: style]
    self.attributedText = NSAttributedString(string: text, attributes: attributes)
    return self
  }

  public func textHeight() -> CGFloat {
    return font.pointSize
  }

  public func getHeightBySizeThatFitsWithWidth(width: CGFloat) -> CGFloat {
    return sizeThatFits(CGSizeMake(width, 100000)).height
  }
}
