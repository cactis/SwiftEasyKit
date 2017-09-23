//
//  IconLabelText.swift
//
//  Created by ctslin on 4/13/16.
//

import UIKit

open class IconLabelText: IconLabel {
  public var field = UILabel()
  public var value = "" { didSet { field.text = value } }

  override open func layoutUI() {
    super.layoutUI()
    layout([field])
  }

  override open func styleUI() {
    super.styleUI()
    field.styled().bold()
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    field.align(toTheRightOf: label, matchingTopAndFillingWidthWithLeftAndRightPadding: paddingBetween, height: label.height)
  }

}


