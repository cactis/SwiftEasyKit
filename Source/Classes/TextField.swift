//
//  TextField.swift
//
//  Created by ctslin on 3/31/16.

import UIKit

open class Password: TextField {
  override open func textRect(forBounds bounds: CGRect) -> CGRect {
    isSecureTextEntry = true
    return super.textRect(forBounds: bounds)
  }
}

open class TextField: UITextField {

  public var dx: CGFloat = 10
  public var bordered = false {
    didSet {
      if bordered { borderStyle = .roundedRect } else { borderStyle = .none }
    }
  }

  public init(placeholder: String = "", bordered: Bool = false) {
    super.init(frame: .zero)
    self.placeholder = placeholder
    ({ self.bordered = bordered })()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func inset(bounds: CGRect) -> CGRect {
    let b = CGRect(origin: bounds.origin, size: CGSize(width: bounds.width - 20, height: bounds.height))
//    return CGRectInset(b, bounds.width * 0.05, bounds.height * -0.03)
    return b.insetBy(dx: dx, dy: bounds.height * -0.03)
  }

  // placeholder position
//  override open func textRect(forBounds bounds: CGRect) -> CGRect {
//    if bounds.width > 100 {
//      rightViewMode = .always
//      clearButtonMode = .whileEditing
//    }
//    return inset(bounds: bounds)
//    //    var rect: CGRect = super.textRectForBounds(bounds)
//    //    var insets: UIEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
//    //    return UIEdgeInsetsInsetRect(rect, insets)
//  }

  // text position
//  override open func editingRect(forBounds _ bounds: CGRect) -> CGRect {
//    return inset(bounds)
//    //    var rect: CGRect = super.editingRectForBounds(bounds)
//    //    var insets: UIEdgeInsets = UIEdgeInsetsMake(inset, inset, inset, inset)
//    //    return UIEdgeInsetsInsetRect(rect, insets)
//  }

  override open func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    let rect: CGRect = super.clearButtonRect(forBounds: bounds)
    return rect.offsetBy(dx: -5, dy: 0)
  }
}


//open class TextView: UITextView {
//  @discardableResult public func texted(value: String) -> TextView {
//    text = value
//    return self
//  }
//}

open class TextView: DefaultView, UITextViewDelegate {

  public var field = UITextView()
  public var clearButton = UIButton()

  var text: String! { get { return field.text } }

  override open func layoutUI() {
    super.layoutUI()
    layout([field, clearButton])
  }

  override open func styleUI() {
    super.styleUI()
    clearButton.imaged(getIcon(.remove)).isHidden = true
  }

  @discardableResult public func texted(_ value: String) -> TextView {
    field.text = value
    return self
  }

  override open func bindUI() {
    super.bindUI()
    field.delegate = self
    clearButton.whenTapped {
      self.field.text = ""
    }
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    clearButton.anchorToEdge(.right, padding: 0, width: 14, height: 14)
    if field.isEditable {
      field.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: clearButton.leftEdge())
    } else {
      field.fillSuperview()
    }
  }

  public func textViewDidBeginEditing(_ textView: UITextView) {
    clearButton.isHidden = false
  }

  public func textViewDidEndEditing(_ textView: UITextView) {
    clearButton.isHidden = true
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

  @discardableResult public func styled(_ options: NSDictionary = NSDictionary()) -> UITextField {
    text = text ?? Lorem.name()
    let color = options["color"] as? UIColor ?? K.Color.text
    let size: CGFloat = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Text.normal
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clear

    textColor = color
    font = UIFont.systemFont(ofSize: size)
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
// @discardableResult public func texted(text: String) -> UITextView {
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
//    let ats = [NSFontAttributeName: UIFont.systemFont(ofSize: size), NSParagraphStyleAttributeName: paragraphStyle, NSForegroundColorAttributeName: K.Color.text]
//    attributedText = NSAttributedString(string: text, attributes: ats)
//    return self
//  }

  public func getHeightByWidth(_ width: CGFloat) -> CGFloat {
    return sizeThatFits(CGSize(width: width, height: 100000)).height
  }

  @discardableResult public func styled(options: NSDictionary = NSDictionary()) -> UITextView {
    text = text ?? Lorem.name()
    let color = options["color"] as? UIColor ?? K.Color.text
    let size: CGFloat = options["fontSize"] as? CGFloat ?? options["size"] as? CGFloat ?? K.Size.Text.normal
    let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clear

    textColor = color
    font = UIFont.systemFont(ofSize: size)
    self.backgroundColor = backgroundColor
    return self
  }
}

