//
//  LabelField.swift
//
//  Created by ctslin on 3/29/16.

import UIKit

class LabelAndSelectin: LabelWith {
  
}
class LabelWithSelection: LabelWith {

}

class LabelAndField: LabelField {

  override func styleUI() {
    super.styleUI()
    field.bordered(1.0, color: UIColor.lightGrayColor().lighter().CGColor)
  }

  func estimateHeight() -> CGFloat {
    return label.textHeight() * 2 + 3 * padding
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: label.textHeight())
    field.alignUnder(label, matchingLeftAndRightFillingHeightWithTopPadding: padding, bottomPadding: 0)
  }
}

class LabelWithField: LabelField {

  func estimateHeight() -> CGFloat {
    return label.textHeight() * 2.5
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
//    label.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: width * 0.2)
    label.anchorInCorner(.TopLeft, xPad: 0, yPad: 0, width: width * 0.2, height: estimateHeight())
    field.alignToTheRightOf(label, fillingWidthWithLeftAndRightPadding: 0, topPadding: 0, height: height)
//    label._coloredWithSuperviews(0)
//    field._coloredWithSuperviews(1)
  }
}

class LabelField: LabelWith {

  var padding: CGFloat = K.Size.Padding.tiny

  var field = TextView()
  override func layoutUI() {
    super.layoutUI()
    layout([field])
  }

  override func styleUI() {
    super.styleUI()
    field.styled()
  }
}


class LabelWith: DefaultView {

  var label = UILabel()

  init(label: String) {
    super.init(frame: CGRectZero)
    self.label.text(label)
  }

  override func layoutUI() {
    super.layoutUI()
    layout([label])
  }

  override func styleUI() {
    super.styleUI()
    label.styled()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


}