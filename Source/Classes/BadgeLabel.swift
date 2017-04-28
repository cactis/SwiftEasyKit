//
//  BadgeLabel.swift
//
//  Created by ctslin on 2/28/16.

import UIKit

public class BadgeLabel: DefaultView {
  public var label = UILabel()
  public var badge = Badge(size: 10, value: "")
  
  public var size: CGFloat! = K.Size.Text.small { didSet { label.font = UIFont.systemFontOfSize(size); badge.badgeSize = size } }
  public var text: String! { didSet { label.text(text) } }
  public var value: String! {
    didSet {
      badge.value = value
    }
  }
  
  public init(text: String, size: CGFloat = 12, value: String = "") {
    super.init(frame: CGRectZero)
    ({ self.size = size })()
    ({ self.value = value })()
    ({ self.text = text })()
  }
  
  override public func layoutUI() {
    super.layoutUI()
    layout([label, badge])
  }
  
  override public func styleUI() {
    super.styleUI()
    label.textAlignment = .Center
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    label.anchorInCenter(width: width, height: label.textHeight())
    if text != nil && text.length() < 5 {
      badge.anchorInCorner(.TopRight, xPad: -30, yPad: 0, width: badge.width, height: badge.height)
    }
  }
  
  override init(frame: CGRect) { super.init(frame: frame) }
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
