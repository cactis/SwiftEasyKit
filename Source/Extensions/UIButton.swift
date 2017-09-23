//
//  UIButton.swift
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

extension UIButton {

  public func textUnderlined(_ text: String, color: UIColor = K.Color.text) -> UIButton {
    let titleString = NSMutableAttributedString(string: text)
    let range = NSMakeRange(0, text.characters.count)
    titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range)
    titleString.addAttributes([NSForegroundColorAttributeName: color], range: range)
    titleString.addAttributes([NSFontAttributeName: UIFont.systemFont(ofSize: K.Size.Text.normal.smaller(3))], range: range)
    self.setAttributedTitle(titleString, for: .normal)
    return self
  }

  public convenience init(text: String) {
    self.init(frame: .zero)
    self.setTitle(text, for: .normal)
  }

  public convenience init(underlinedText: String) {
    self.init(frame: .zero)
//    self.setTitle(text, for: .normal)
    self.textUnderlined(underlinedText)
    self.colored(K.Color.Text.normal).smaller()
  }

  public func imaged(_ image: UIImage) -> UIButton {
    setImage(image, for: .normal)
    return self
  }

  public func clicked() -> UIButton {
    self.sendActions(for: .touchUpInside)
    return self
  }

  public func sized(_ size: CGFloat) -> UIButton {
    titleLabel?.font = UIFont(name: (titleLabel?.font?.fontName)!, size: size)
    return self
  }

  public func colored(_ color: UIColor) -> UIButton {
    self.setTitleColor(color, for: .normal)
    return self
  }

  override open func backgroundColored(_ color: UIColor?) -> UIButton {
    backgroundColor = color
    return self
  }

  public func larger(_ n: CGFloat = 1) -> UIButton {
    smaller(-1 * n)
    return self
  }

  public func smaller(_ n: CGFloat = 1) -> UIButton {
    self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: (self.titleLabel?.font?.pointSize)! - n)
    return self
  }

  public func lighter(_ diff: CGFloat = 0.2) -> UIButton {
    titleLabel?.lighter(diff)
    return self
  }

  public func darker(_ diff: CGFloat = 0.2) -> UIButton {
    titleLabel?.darker(diff)
    return self
  }

  public func styled(_ text: String = Lorem.name(), options: NSDictionary = NSDictionary()) -> UIButton {
    let fontSize = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Submit.size
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clear
    let color: UIColor = options["color"] as? UIColor ?? K.Color.button

    self.backgroundColor = backgroundColor
    setTitleColor(color, for: .normal)
    setTitle(self.titleLabel?.text ?? text, for: UIControlState.normal)
    titleLabel!.font = UIFont.systemFont(ofSize: fontSize)
    return self
  }

  public func texted() -> String {
    return (titleLabel?.text)!
  }

  public func darkered(_ n: CGFloat = 0.2) -> UIButton {
    setTitleColor(currentTitleColor.darker(n), for: .normal)
    return self
  }

  public func buttonWidth() -> CGFloat {
    return textWidth() * 1.5
  }

  public func buttonHeight() -> CGFloat {
    return textHeight() * 2
  }

  public func buttonSize() -> (CGFloat, CGFloat) {
    return (buttonWidth(), buttonHeight())
  }

  public func texted(_ text: String?, options: NSDictionary = NSDictionary()) -> UIButton {
    //    titleLabel!.text = text
    setTitle(text, for: .normal)
    //    setAttributedTitle(NSAttributedString(string: text), for: .normal)
    return self //styled(text, options: options)
  }

  public func styledAsSubmit(_ options: NSDictionary = NSDictionary()) -> UIButton {
    backgroundColor = K.Color.buttonBg
    setTitleColor(K.Color.button, for: .normal)
    titleLabel!.font = UIFont.systemFont(ofSize: options["size"] as? CGFloat ?? K.Size.Submit.size)
    radiused(4)
    return self
  }

  public func styledAsInfo(_ options: NSDictionary = NSDictionary()) -> UIButton {
//    styledAsSubmit()
    backgroundColored(UIColor.white)
    setTitleColor(K.Color.Segment.active, for: .normal)
    titleLabel!.font = UIFont.systemFont(ofSize: options["size"] as? CGFloat ?? K.Size.Submit.size)
    radiused(4).bordered(0, color: K.Color.Segment.active.cgColor)
    return self
  }

  public func disabled() -> UIButton {
    backgroundColor = UIColor.lightGray
    isUserInteractionEnabled = false
    return self
  }

  public func textHeight() -> CGFloat {
    return titleLabel!.font.pointSize
  }

  public func textWidth() -> CGFloat {
    return titleLabel!.intrinsicContentSize.width
  }

  public func tapped() {
    sendActions(for: .touchUpInside)
  }

  public func whenTapped(_ handler: @escaping () -> Void) -> UIButton {
    handleControlEvent(event: .touchUpInside, handler: delayedEvent(handler))
    return self
  }

  public func delayedEvent(_ handler: @escaping () -> ()) -> () -> () {
    asFadable()
    let handlerWithDelayed = {
      self.isUserInteractionEnabled = false
      let color = self.currentTitleColor
      self.setTitleColor(color.isLight() ? color.darker() : color.lighter(), for: .normal)
      delayedJob{
        self.isUserInteractionEnabled = true
        self.setTitleColor(color, for: .normal)
      }
      handler()
    }
    return handlerWithDelayed
  }

  public func imageFromText(_ drawText: NSString, color: UIColor = K.Color.button) -> UIButton {
    let s = height * 0.5
    let textColor: UIColor = color
    let textFont: UIFont = UIFont(name: K.Font.icon, size: s)!
    let size = CGSize(width: s, height: s)
    UIGraphicsBeginImageContext(size)
    let textFontAttributes = [
      NSFontAttributeName: textFont,
      NSForegroundColorAttributeName: textColor,
    ]
    let image = UIImage()
    let rect = CGRect(x: 0, y: 0, width: width, height: height)
    image.draw(in: rect)
    drawText.draw(in: rect, withAttributes: textFontAttributes)

    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    setImage(newImage, for: .normal)
    return self
  }
}
