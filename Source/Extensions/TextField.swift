//
//  TextField.swift
//
//  Created by ctslin on 3/31/16.

import UIKit


public class TextField: UITextField {

  // placeholder position
  override public func textRectForBounds(bounds: CGRect) -> CGRect {
    rightViewMode = .Always
    let inset = bounds.height * 0.01
    return CGRectInset(bounds, inset * 10, inset)
    //    var rect: CGRect = super.textRectForBounds(bounds)
    //    var insets: UIEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
    //    return UIEdgeInsetsInsetRect(rect, insets)
  }

  // text position
  override public func editingRectForBounds(bounds: CGRect) -> CGRect {
    let inset = bounds.height * 0.01
    return CGRectInset(bounds , inset * 10 , inset)
    //    var rect: CGRect = super.editingRectForBounds(bounds)
    //    var insets: UIEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
    //    return UIEdgeInsetsInsetRect(rect, insets)
  }

  override public func clearButtonRectForBounds(bounds: CGRect) -> CGRect {
    let rect: CGRect = super.clearButtonRectForBounds(bounds)
    return CGRectOffset(rect, -5, 0)
  }

  public func text(value: String) -> TextField {
    text = value
    return self
  }

  public func colored(color: UIColor) -> TextField {
    textColor = color
    return self
  }

  public func aligned(align: NSTextAlignment = .Left) -> TextField {
    textAlignment = align
    return self
  }

}


public class TextView: UITextView {
  public func text(value: String) -> TextView {
    text = value
    return self
  }
}

private var kAssociationKeyNextField: UInt8 = 0
extension UITextField {
  public var nextField: UIView? {
    get {
      return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UIView
    }
    set(newField) {
      objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  public func styled(options: NSDictionary = NSDictionary()) -> UITextField {
    text = text ?? Lorem.name()
    let color = options["color"] as? UIColor ?? K.Color.text
    let size: CGFloat = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Text.normal
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clearColor()

    textColor = color
    font = UIFont.systemFontOfSize(size)
    self.backgroundColor = backgroundColor
    return self
  }
}

extension UITextView {
  public var nextField: UIView? {
    get {
      return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UIView
    }
    set(newField) {
      objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, .OBJC_ASSOCIATION_RETAIN)
    }
  }

//
//  public func texted(text: String) -> UITextView {
//    return self
//  }

//  public func styled(options: NSDictionary = NSDictionary()) -> UITextView {
//    let lineHeight = options["lineHeight"] as? CGFloat ?? K.Size.Text.normal * 1.5
//    let size: CGFloat = options["size"] as? CGFloat ?? K.Size.Text.normal
//
//    let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
//    paragraphStyle.lineHeightMultiple = lineHeight
//    paragraphStyle.maximumLineHeight = lineHeight
//    paragraphStyle.minimumLineHeight = lineHeight
//    let ats = [NSFontAttributeName: UIFont.systemFontOfSize(size), NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: K.Color.text]
//    attributedText = NSAttributedString(string: text, attributes: ats)
//    return self
//  }

  public func getHeightBySizeThatFitsWithWidth(width: CGFloat) -> CGFloat {
    return sizeThatFits(CGSizeMake(width, 100000)).height
  }


  public func styled(options: NSDictionary = NSDictionary()) -> UITextView {
    text = text ?? Lorem.name()
    let color = options["color"] as? UIColor ?? K.Color.text
    let size: CGFloat = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Text.normal
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clearColor()

    textColor = color
    font = UIFont.systemFontOfSize(size)
    self.backgroundColor = backgroundColor
    return self
  }
}

