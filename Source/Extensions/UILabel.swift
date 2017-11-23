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
// import RandomKit
import SwiftRandom

extension UILabel {

  public convenience init(_ text: String) {
    self.init(frame: .zero)
    self.text = text
  }

  @discardableResult public func iconFonted(_ iconCode: String, iconColor: UIColor = K.Color.Segment.deactive, size: CGFloat = K.BarButtonItem.size) -> UILabel {
    self.texted(iconCode)
    self.font = UIFont(name: K.Font.icon, size: size)
    self.textColor = iconColor
    return self
  }

  @discardableResult public func sized(_ size: CGFloat) -> UILabel {
    font = UIFont(name: font.fontName , size: size)
    return self
  }

  @discardableResult public func smaller(_ n: CGFloat = 1) -> UILabel {
    font = UIFont(name: font.fontName, size: font.pointSize - n)
    return self
  }

  @discardableResult public func larger(_ n: CGFloat = 1) -> UILabel {
    smaller(-1 * n)
    return self
  }

  @discardableResult public func colored(_ color: UIColor) -> UILabel {
    textColor = color
    return self
  }

  @discardableResult public func fontName(_ name: String) -> String {
    font = UIFont(name: name, size: font.pointSize)
    return font.fontName
  }

  @discardableResult public func styled(_ value: String, options: NSDictionary = NSDictionary()) -> UILabel {
    self.texted(value).styled(options)
    return self
  }

  @discardableResult public func styled(_ options: NSDictionary = NSDictionary()) -> UILabel {
    //    text = text ?? Lorem.name()
    let color = options["color"] as? UIColor ?? K.Color.text
    let size: CGFloat = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Text.normal
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clear

    textColor = color
    font = UIFont.systemFont(ofSize: size)
    self.backgroundColor = backgroundColor
    return self
  }

  public var linesCount: Int {
    let size = sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
    return [(size.height / self.font.lineHeight).int, 0].max()!
  }

  @discardableResult public func html(_ html: NSAttributedString) -> UILabel {
    self.attributedText = html
    return self
  }

  @discardableResult public func aligned(_ align: NSTextAlignment = .left) -> UILabel {
    textAlignment = align
    return self
  }

  @discardableResult public func updateNumberWrappedIn(_ number: AnyObject) -> UILabel {
    return texted(text?.updateNumberWrappedIn(number))
  }

  @discardableResult public func appendText(_ value: String) -> UILabel {
    texted("\(text!)\(value)")
    return self
  }

  @discardableResult public func texted(_ iconCode: String, text: String, size: CGFloat = K.Size.Text.normal) -> UILabel {
//    let iconAttribute = [NSFontAttributeName: UIFont(name: K.Font.icon, size: size)!, NSBaselineOffsetAttributeName: -1 * size / 4  ]
    let iconAttribute = [NSAttributedStringKey.font: UIFont(name: K.Font.icon, size: size)!]
    let iconString = NSMutableAttributedString(string: iconCode, attributes: iconAttribute )
    let textString = NSAttributedString(string: " \(text)", attributes: [
      NSAttributedStringKey.font: UIFont(name: font.fontName, size: size * 0.8)!,
      NSAttributedStringKey.baselineOffset: size / 5])
    iconString.append(textString)
    attributedText = iconString
    baselineAdjustment = .alignBaselines
    return self
  }

  @discardableResult public func lighter(_ diff: CGFloat = 0.2) -> UILabel {
    colored(textColor.lighter(diff))
    return self
  }

  @discardableResult public func coloredLike(_ label: UILabel) -> UILabel {
    return colored(label.textColor)
  }

  @discardableResult public func darker(_ diff: CGFloat = 0.2) -> UILabel {
    colored(textColor.darker(diff))
    return self
  }

  @available(iOS 8.2, *)
  @discardableResult public func weighted(_ weight: CGFloat = UIFont.Weight.light.rawValue) -> UILabel {
    font = UIFont.systemFont(ofSize: font.pointSize, weight:  UIFont.Weight(rawValue: weight))
    return self
  }

  @discardableResult public func bold(_ bolded: Bool = true) -> UILabel {
    if bolded {
      font = UIFont.boldSystemFont(ofSize: font.pointSize)
    } else {
      font = UIFont.systemFont(ofSize: font.pointSize)
    }
    return self
  }

  @discardableResult public func texted(_ value: String?) -> UILabel {
    text = value
    return self
  }

  @discardableResult public func fitTexted(_ value: String?) -> UILabel {
    return texted(value).reFit()
  }

  @discardableResult public func reFit() -> UILabel {
    adjustsFontSizeToFitWidth = true
    return self
  }

  @discardableResult public func attributedText(_ value: NSAttributedString) -> UILabel {
    attributedText = value
    return self
  }

  @objc @discardableResult public func textWidth() -> CGFloat {
    return self.intrinsicContentSize.width
  }

  @objc @discardableResult public func textHeight() -> CGFloat {
    return font.pointSize
  }

  @discardableResult public func centered() -> UILabel {
    textAlignment = .center
    return self
  }

  @discardableResult public func multilinized(_ lineHeight: CGFloat = 6) -> UILabel {
    numberOfLines = 0
    //    setLineHeight(textHeight())
    lineBreakMode = .byWordWrapping
    setLineHeight(lineHeight)
    return self
  }

  @discardableResult public func setLineHeight(_ size: CGFloat = 6) -> UILabel {
    let text = self.text ?? ""
    let style = NSMutableParagraphStyle()
    style.lineSpacing = size
    //    style.lineHeightMultiple = size
    let attributes = [NSAttributedStringKey.paragraphStyle: style]
    self.attributedText = NSAttributedString(string: text, attributes: attributes)
    return self
  }

  @discardableResult public func getHeightBySizeThatFitsWithWidth(_ width: CGFloat) -> CGFloat {
    return sizeThatFits(CGSize(width: width, height: 100000)).height
  }
}
