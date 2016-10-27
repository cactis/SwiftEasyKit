//
//  Label.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/29/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import UIKit

public class Label: UILabel {
  var rectInsets: UIEdgeInsets

  public init(rectInsets: UIEdgeInsets = UIEdgeInsetsZero) {
    self.rectInsets = rectInsets
    super.init(frame: CGRectZero)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override public func drawTextInRect(rect: CGRect) {
//    padding = height * 0.1
    super.drawTextInRect(UIEdgeInsetsInsetRect(rect, rectInsets))
  }

  override public func textWidth() -> CGFloat {
    return super.textWidth() + height * 0.4 * 2
  }

  override public func textHeight() -> CGFloat {
    return super.textHeight() + height * 0.4
  }

}