//
//  LabelField.swift
//
//  Created by ctslin on 3/29/16.

import UIKit

public class LabelAndSelectin: LabelWith {

}
public class LabelWithSelection: LabelWith {

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
    label.anchorInCorner(.TopLeft, xPad: 0, yPad: 0, width: width * 0.2, height: estimateHeight())
    field.alignToTheRightOf(label, fillingWidthWithLeftAndRightPadding: 0, topPadding: 0, height: height)
//    label._coloredWithSuperviews(0)
//    field._coloredWithSuperviews(1)
  }
}

public class LabelField: LabelWith {

  public var padding: CGFloat = K.Size.Padding.tiny

  public var field = TextView()
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
