//
//  SWKInput.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/11/25.
//  Copyright © 2016年 airfont. All rights reserved.
//

import UIKit

open class SWKDateInput: SWKInput {
  let datePicker = UIDatePicker()

  override open func layoutUI() {
    super.layoutUI()
    datePicker.datePickerMode = .date
    let toolbar = UIToolbar()
    toolbar.sizeToFit()
    let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
    toolbar.items = [flex, done]
    value.inputAccessoryView = toolbar
    value.inputView = datePicker
  }

  override open func bindUI() {
    super.bindUI()
    value.addTarget(self, action: #selector(valueTapped), for: .editingDidBegin)
  }

  @objc func valueTapped() {
    datePicker.date = (value.text!.toDate("yyyy/MM/dd") ?? Date()) as Date
  }

  @objc func doneTapped() {
    value.endEditing(true)
    value.texted(datePicker.date.toString("yyyy/MM/dd"))
  }
}

open class SWKInput: DefaultView {

  public var label = UILabel()
  public var value = UITextField()
  public var data: String? { didSet { value.texted(data) } }
  public var text: String { get { return value.text! } set { value.text = newValue } }
  public var prefix: String!

  public func valued(_ text: String?) { value.texted(text) }

  public init(label: String, value: String = "", prefix: String = "輸入") {
    super.init(frame: .zero)
    self.label.texted(label)
    self.prefix = prefix
    if self.value.placeholder == nil {self.value.placeholder = "\(prefix)\(label)" }
    ({self.data = value})()
  }

  public init(label: String, placeholder: String) {
    super.init(frame: .zero)
    self.label.texted(label)
    self.value.placeholder = placeholder
  }

  public init(label: String, placeholder: String, secureText: Bool) {
    super.init(frame: .zero)
    value.isSecureTextEntry = secureText
    self.label.texted(label)
    self.value.placeholder = placeholder
  }

  override open func layoutUI() {
    super.layoutUI()
    layout([label, value])
  }

  override open func styleUI() {
    super.styleUI()
    label.styled()
    value.styled().bold()
    value.colored(K.Color.Text.strong).aligned(.right)
  }

  public func estimateHeight() -> CGFloat {
    return 40 + label.textHeight()
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: label.textWidth())
    value.align(toTheRightOf: label, matchingCenterWithLeftPadding: 10, width: width - label.rightEdge() - 30, height: label.height)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}



