//
//  IconLabelText.swift
//
//  Created by ctslin on 4/13/16.
//

import UIKit

public class IconLabelText: IconLabel {
  public var field = UILabel()
  public var value = "" { didSet { field.text = value } }

  override public func layoutUI() {
    super.layoutUI()
    layout([field])
  }

  override public func styleUI() {
    super.styleUI()
    field.styled().bold()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    field.alignToTheRightOf(label, matchingTopAndFillingWidthWithLeftAndRightPadding: paddingBetween, height: label.height)
  }

}


