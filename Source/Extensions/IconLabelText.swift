//
//  IconLabelText.swift
//
//  Created by ctslin on 4/13/16.
//

import UIKit

class IconLabelText: IconLabel {
  var field = UILabel()
  var value = "" { didSet { field.text = value } }

  override func layoutUI() {
    super.layoutUI()
    layout([field])
  }

  override func styleUI() {
    super.styleUI()
    field.styled()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    field.alignToTheRightOf(label, matchingTopAndFillingWidthWithLeftAndRightPadding: paddingBetween, height: label.height)
  }
  
}


