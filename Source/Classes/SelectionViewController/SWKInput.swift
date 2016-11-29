//
//  SWKInput.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/11/25.
//  Copyright © 2016年 airfont. All rights reserved.
//

import UIKit


public class SWKInput: DefaultView {
  
  public var label = UILabel()
  public var value = UITextField()
  public var data: String? { didSet { value.text(data) } }
  public var text: String { get { return value.text! } set { value.text = newValue } }
  public func prefix() -> String { return "輸入" }
  
  public func valued(text: String?) { value.text(text) }
  
  public init(label: String, value: String = "") {
    super.init(frame: CGRectZero)
    self.label.text(label)
    if self.value.placeholder == nil {self.value.placeholder = "\(prefix())\(label)" }
    ({self.data = value})()
  }
  
  public init(label: String, placeholder: String) {
    super.init(frame: CGRectZero)
    self.label.text(label)
    self.value.placeholder = placeholder
  }
  
  public init(label: String, placeholder: String, secureText: Bool) {
    super.init(frame: CGRectZero)
    value.secureTextEntry = secureText
    self.label.text(label)
    self.value.placeholder = placeholder
  }
  
  override public func layoutUI() {
    super.layoutUI()
    layout([label, value])
  }
  
  override public func styleUI() {
    super.styleUI()
    label.styled()
    value.styled().bold()
    value.colored(K.Color.Text.strong).aligned(.Right)
  }
  
  public func estimateHeight() -> CGFloat {
    return 40 + label.textHeight()
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: label.textWidth())
    value.alignToTheRightOf(label, matchingCenterWithLeftPadding: 10, width: width - label.rightEdge() - 30, height: label.height)
  }
  
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}



