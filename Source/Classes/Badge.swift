//
//  Badge.swift
//  Created by ctslin on 2/28/16.

import UIKit

public class Badge: DefaultView {

  public var badgeSize: CGFloat! { didSet { styleUI(); } }
  public var label = UILabel()
  public var body = UIView()

  public var size: CGFloat!

  public var color = K.Badge.backgroundColor.colorWithAlphaComponent(0.8) { didSet { styleUI() } }

  public var bordered = true {
    didSet {
      if bordered {
        label.bordered(size! / 12, color: UIColor.whiteColor().CGColor)
      } else {
        label.bordered(size! / 12, color: K.Badge.backgroundColor.CGColor)
      }
    }
  }

  public var value: String! {
    get {
      return label.text
    }
    set {
      label.text = newValue
      if newValue != "" {
        label.hidden = false
      } else {
        label.hidden = true
      }
    }
  }

  public init(size: CGFloat? = K.Badge.size, value: String = "") {
    self.size = size
    self.badgeSize = size! * 1.5
    super.init(frame: CGRectZero)

    self.value = value
    layout([body.layout([label])])
    label.hidden = true
  }

  override public func styleUI() {
    super.styleUI()
    size = badgeSize / 1.5
    bordered = true
    label.textColor = K.Badge.color
    label.font = UIFont.systemFontOfSize(size)
    label.backgroundColor = color
    label.radiused(badgeSize / 2)
    label.textAlignment = .Center
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: badgeSize)
    body.fillSuperview()
    let w = max(badgeSize, label.intrinsicContentSize().width * 1.35)
    var yPad: CGFloat = -3
    if superview?.height > height {
      yPad = 2
    }
    label.anchorInCorner(.TopRight, xPad: (superview!.width - w) / 4.5, yPad: yPad, width: w, height: badgeSize)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
