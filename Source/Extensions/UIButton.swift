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

  func imaged(image: UIImage) -> UIButton {
    setImage(image, forState: .Normal)
    return self
  }

  func clicked() -> UIButton {
    self.sendActionsForControlEvents(.TouchUpInside)
    return self
  }

  func sized(size: CGFloat) -> UIButton {
    titleLabel?.font = UIFont(name: (titleLabel?.font?.fontName)!, size: size)
    return self
  }

  func colored(color: UIColor) -> UIButton {
    self.setTitleColor(color, forState: .Normal)
    return self
  }

  override func backgroundColored(color: UIColor) -> UIButton {
    backgroundColor = color
    return self
  }

  func smaller(n: CGFloat = 1) -> UIButton {
    self.titleLabel?.font = UIFont(name: (self.titleLabel?.font.fontName)!, size: (self.titleLabel?.font?.pointSize)! - n)
    return self
  }

  func styled(text: String = Lorem.name(), options: NSDictionary = NSDictionary()) -> UIButton {
    let fontSize = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Submit.size
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clearColor()
    let color: UIColor = options["color"] as? UIColor ?? K.Color.button

    self.backgroundColor = backgroundColor
    setTitleColor(color, forState: .Normal)
    setTitle(self.titleLabel?.text ?? text, forState: UIControlState.Normal)
    titleLabel!.font = UIFont.systemFontOfSize(fontSize)
    return self
  }

  func text() -> String {
    return (titleLabel?.text)!
  }

  func darkered(n: CGFloat = 0.2) -> UIButton {
    setTitleColor(currentTitleColor.darker(n), forState: .Normal)
    return self
  }

  func buttonWidth() -> CGFloat {
    return textWidth() * 1.5
  }

  func buttonHeight() -> CGFloat {
    return textHeight() * 2
  }

  func buttonSize() -> (CGFloat, CGFloat) {
    return (buttonWidth(), buttonHeight())
  }

  func text(text: String, options: NSDictionary = NSDictionary()) -> UIButton {
    //    titleLabel!.text = text
    setTitle(text, forState: .Normal)
    //    setAttributedTitle(NSAttributedString(string: text), forState: .Normal)
    return self //styled(text, options: options)
  }

  func styledAsSubmit(options: NSDictionary = NSDictionary()) -> UIButton {
    backgroundColor = K.Color.buttonBg
    setTitleColor(K.Color.button, forState: .Normal)
    titleLabel!.font = UIFont.systemFontOfSize(options["size"] as? CGFloat ?? K.Size.Submit.size)
    radiused(2)
    return self
  }

  func disabled() -> UIButton {
    backgroundColor = UIColor.lightGrayColor()
    return self
  }

  func textHeight() -> CGFloat {
    return titleLabel!.font.pointSize
  }

  func textWidth() -> CGFloat {
    return titleLabel!.intrinsicContentSize().width
  }

  func tapped() {
    sendActionsForControlEvents(.TouchUpInside)
  }

  func whenTapped(handler: () -> Void) -> UIButton {
    handleControlEvent(.TouchUpInside, handler: handler)
    return self
  }

  func imageFromText(drawText: NSString, color: UIColor = K.Color.button) -> UIButton {
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
