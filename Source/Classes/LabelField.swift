//
//  LabelField.swift
//
//  Created by ctslin on 3/29/16.

import UIKit

open class LabelAndSelectin: LabelWith {

}
open class LabelWithSelection: LabelWith {

}

open class LabelAndValue: LabelWith {
  public var value = UILabel()
  public var padding: CGFloat = K.Size.Padding.tiny
  override open func layoutUI() {
    super.layoutUI()
    layout([value])
  }
  override open func styleUI() {
    super.styleUI()
    value.styled()
  }
  override open func autoHeight(_ padding: CGFloat? = K.Size.Padding.small) -> CGFloat {
    return value.textHeight() + label.bottomEdge() + padding!
  }
  override open func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: label.textHeight())
    value.alignUnder(label, matchingLeftAndRightFillingHeightWithTopPadding: 0, bottomPadding: 0)
  }
}

open class LabelAndField: LabelField {
  override open func styleUI() {
    super.styleUI()
    field.bordered(1.0, color: UIColor.lightGray.lighter().cgColor)
  }

  public func estimateHeight() -> CGFloat {
    return label.textHeight() * 2 + 3 * padding
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: label.textHeight())
    field.alignUnder(label, matchingLeftAndRightFillingHeightWithTopPadding: padding, bottomPadding: 0)
  }
}

open class LabelWithField: LabelField {

  public func estimateHeight() -> CGFloat {
    return label.textHeight() * 2.5
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
//    label.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: width * 0.2)
//    label.anchorInCorner(.topLeft, xPad: 0, yPad: 0, width: label.textWidth() * 1.1, height: estimateHeight())
    label.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: label.textWidth() * 1.2)
    field.align(toTheRightOf: label, fillingWidthWithLeftAndRightPadding: 0, topPadding: 0, height: label.height)
//    label._coloredWithSuperviews(0)
//    field._coloredWithSuperviews(1)
  }
}

open class LabelField: LabelWith {

  public var padding: CGFloat = K.Size.Padding.tiny

  public var input = TextView()
  public var field: UITextView! { get { return input.field } }
  public var value: String? { get { return field.text } set {
    if let _ = newValue { field.text = newValue } } }
  public override init(label: String) {
    super.init(label: label)
    // !!!set placeholder
  }

  override open func layoutUI() {
    super.layoutUI()
    layout([field])
  }

  override open func styleUI() {
    super.styleUI()
    field.styled()
  }
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


open class LabelWith: DefaultView {

  public var label = UILabel()

  public init(label: String) {
    super.init(frame: .zero)
    self.label.texted(label)
  }

  override open func layoutUI() {
    super.layoutUI()
    layout([label])
  }

  override open func styleUI() {
    super.styleUI()
    label.styled()
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }


}
