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
import RandomKit
import SwiftRandom

extension UIButton {
  
  public func textUnderlined(text: String, color: UIColor = K.Color.text) -> UIButton {
    let titleString = NSMutableAttributedString(string: text)
    let range = NSMakeRange(0, text.characters.count)
    titleString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: range)
    titleString.addAttributes([NSForegroundColorAttributeName: color], range: range)
    titleString.addAttributes([NSFontAttributeName: UIFont.systemFontOfSize(K.Size.Text.normal.smaller(3))], range: range)
    self.setAttributedTitle(titleString, forState: .Normal)
    return self
  }

  public convenience init(text: String) {
    self.init(frame: CGRectZero)
    self.setTitle(text, forState: .Normal)
  }
  
  public convenience init(underlinedText: String) {
    self.init(frame: CGRectZero)
//    self.setTitle(text, forState: .Normal)
    self.textUnderlined(underlinedText)
    self.colored(K.Color.Text.normal).smaller()
  }

  public func imaged(image: UIImage) -> UIButton {
    setImage(image, forState: .Normal)
    return self
  }

  public func clicked() -> UIButton {
    self.sendActionsForControlEvents(.TouchUpInside)
    return self
  }

  public func sized(size: CGFloat) -> UIButton {
    titleLabel?.font = UIFont(name: (titleLabel?.font?.fontName)!, size: size)
    return self
  }

  public func colored(color: UIColor) -> UIButton {
    self.setTitleColor(color, forState: .Normal)
    return self
  }

  override public func backgroundColored(color: UIColor?) -> UIButton {
    backgroundColor = color
    return self
  }

  public func larger(n: CGFloat = 1) -> UIButton {
    smaller(-1 * n)
    return self
  }

  public func smaller(n: CGFloat = 1) -> UIButton {
    self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: (self.titleLabel?.font?.pointSize)! - n)
    return self
  }

  public func lighter(diff: CGFloat = 0.2) -> UIButton {
    titleLabel?.lighter(diff)
    return self
  }

  public func darker(diff: CGFloat = 0.2) -> UIButton {
    titleLabel?.darker(diff)
    return self
  }

  public func styled(text: String = Lorem.name(), options: NSDictionary = NSDictionary()) -> UIButton {
    let fontSize = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Submit.size
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clearColor()
    let color: UIColor = options["color"] as? UIColor ?? K.Color.button

    self.backgroundColor = backgroundColor
    setTitleColor(color, forState: .Normal)
    setTitle(self.titleLabel?.text ?? text, forState: UIControlState.Normal)
    titleLabel!.font = UIFont.systemFontOfSize(fontSize)
    return self
  }

  public func text() -> String {
    return (titleLabel?.text)!
  }

  public func darkered(n: CGFloat = 0.2) -> UIButton {
    setTitleColor(currentTitleColor.darker(n), forState: .Normal)
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

  public func text(text: String, options: NSDictionary = NSDictionary()) -> UIButton {
    //    titleLabel!.text = text
    setTitle(text, forState: .Normal)
    //    setAttributedTitle(NSAttributedString(string: text), forState: .Normal)
    return self //styled(text, options: options)
  }

  public func styledAsSubmit(options: NSDictionary = NSDictionary()) -> UIButton {
    backgroundColor = K.Color.buttonBg
    setTitleColor(K.Color.button, forState: .Normal)
    titleLabel!.font = UIFont.systemFontOfSize(options["size"] as? CGFloat ?? K.Size.Submit.size)
    radiused(4)
    return self
  }
  
  public func styledAsInfo(options: NSDictionary = NSDictionary()) -> UIButton {
    styledAsSubmit()
    backgroundColored(UIColor.whiteColor())
    setTitleColor(K.Color.Segment.active, forState: .Normal)
    radiused(4).bordered(1, color: K.Color.Segment.active.CGColor)
    return self
  }

  public func disabled() -> UIButton {
    backgroundColor = UIColor.lightGrayColor()
    return self
  }

  public func textHeight() -> CGFloat {
    return titleLabel!.font.pointSize
  }

  public func textWidth() -> CGFloat {
    return titleLabel!.intrinsicContentSize().width
  }

  public func tapped() {
    sendActionsForControlEvents(.TouchUpInside)
  }

  public func whenTapped(handler: () -> Void) -> UIButton {
    handleControlEvent(.TouchUpInside, handler: delayedEvent(handler))
    return self
  }
  
  public func delayedEvent(handler: () -> ()) -> () -> () {
    asFadable()
    let handlerWithDelayed = {
      self.userInteractionEnabled = false
      let color = self.currentTitleColor
      self.setTitleColor(color.isLight() ? color.darker() : color.lighter(), forState: .Normal)
      delayedJob{
        self.userInteractionEnabled = true
        self.setTitleColor(color, forState: .Normal)
      }
      handler()
    }
    return handlerWithDelayed
  }

  public func imageFromText(drawText: NSString, color: UIColor = K.Color.button) -> UIButton {
    let s = height * 0.5
    let textColor: UIColor = color
    let textFont: UIFont = UIFont(name: K.Font.icon, size: s)!
    let size = CGSize(width: s, height: s)
    UIGraphicsBeginImageContext(size)
    let textFontAttributes = [
      NSFontAttributeName: textFont,
      NSForegroundColorAttributeName: textColor,
      //      NSBackgroundColorAttributeName: UIColor.blackColor()
    ]
    let image = UIImage()
    let rect = CGRectMake(0, 0, width, height)
    image.drawInRect(rect)
    drawText.drawInRect(rect, withAttributes: textFontAttributes)

    let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    setImage(newImage, forState: .Normal)
    return self
  }
}
