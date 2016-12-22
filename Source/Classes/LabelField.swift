//
//  LabelField.swift
//
//  Created by ctslin on 3/29/16.

import UIKit

public class LabelAndSelectin: LabelWith {

}
public class LabelWithSelection: LabelWith {

}

public class LabelAndValue: LabelWith {
  public var value = UILabel()
  public var padding: CGFloat = K.Size.Padding.tiny
  public override func layoutUI() {
    super.layoutUI()
    layout([value])
  }
  public override func styleUI() {
    super.styleUI()
    value.styled()
  }
  public override func autoHeight(padding: CGFloat? = K.Size.Padding.small) -> CGFloat {
    return value.textHeight() + label.bottomEdge() + padding!
  }
  public override func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: label.textHeight())
    value.alignUnder(label, matchingLeftAndRightFillingHeightWithTopPadding: 0, bottomPadding: 0)    
  }
}

public class LabelAndField: LabelField {
  override public func styleUI() {
    super.styleUI()
    field.bordered(1.0, color: UIColor.lightGrayColor().lighter().CGColor)
  }

  public func estimateHeight() -> CGFloat {
    return label.textHeight() * 2 + 3 * padding
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: label.textHeight())
    field.alignUnder(label, matchingLeftAndRightFillingHeightWithTopPadding: padding, bottomPadding: 0)
  }
}

public class LabelWithField: LabelField {

  public func estimateHeight() -> CGFloat {
    return label.textHeight() * 2.5
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
//    label.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: width * 0.2)
//    label.anchorInCorner(.TopLeft, xPad: 0, yPad: 0, width: label.textWidth() * 1.1, height: estimateHeight())
    label.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: label.textWidth() * 1.2)
    field.alignToTheRightOf(label, fillingWidthWithLeftAndRightPadding: 0, topPadding: 0, height: label.height)
//    label._coloredWithSuperviews(0)
//    field._coloredWithSuperviews(1)
  }
}

public class LabelField: LabelWith {

  public var padding: CGFloat = K.Size.Padding.tiny

  public var input = TextView()
  public var field: UITextView! { get { return input.field } }
  public var value: String? { get { return field.text } set {
    if let _ = newValue { field.text = newValue } } }
  override public func layoutUI() {
    super.layoutUI()
    layout([field])
  }

  override public func styleUI() {
    super.styleUI()
    field.styled()
  }
}


public class LabelWith: DefaultView {

  public var label = UILabel()

  public init(label: String) {
    super.init(frame: CGRectZero)
    self.label.text(label)
  }

  override public func layoutUI() {
    super.layoutUI()
    layout([label])
  }

  override public func styleUI() {
    super.styleUI()
    label.styled()
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }


}
