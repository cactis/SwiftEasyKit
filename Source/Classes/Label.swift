//
//  Label.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/29/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import UIKit

public class Label: UILabel {

  override public func drawTextInRect(rect: CGRect) {
    let padding = height * 0.1
    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)))
  }

  override public func textWidth() -> CGFloat {
    return super.textWidth() + height * 0.4 * 2
  }

  override public func textHeight() -> CGFloat {
    return super.textHeight() + height * 0.4
  }

}