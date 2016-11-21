//
//  Tag.swift
//  
//
//  Created by ctslin on 2016/11/21.
//
//

import UIKit

public class Tag: UIButton {
  
  public init(text: String = "") {
    super.init(frame: CGRectZero)
    setTitle(text, forState: .Normal)
    styled().smaller(2).colored(UIColor.whiteColor()).backgroundColored(UIColor.lightGrayColor().lighter(0.1)).radiused(2)
  }
  
  public func autoWidth() -> CGFloat { return textWidth() * 1.25 }
  public func autoHeight() -> CGFloat { return textHeight() * 1.6 }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

