//
//  Label.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/29/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import UIKit

open class Label: UILabel {
  var rectInsets: UIEdgeInsets

  public init(rectInsets: UIEdgeInsets = .zero) {
    self.rectInsets = rectInsets
    super.init(frame: .zero)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func drawText(in rect: CGRect) {
//    padding = height * 0.1
    super.drawText(in: UIEdgeInsetsInsetRect(rect, rectInsets))
  }

  override open func textWidth() -> CGFloat {
    return super.textWidth() + height * 0.4 * 2
  }

  override open func textHeight() -> CGFloat {
    return super.textHeight() + height * 0.4
  }

}
