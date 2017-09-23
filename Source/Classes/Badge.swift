//
//  Badge.swift
//  Created by ctslin on 2/28/16.

import UIKit

open class Badge: DefaultView {

  public var badgeSize: CGFloat! { didSet { styleUI(); } }
  public var label = UILabel()
  public var body = UIView()

  public var size: CGFloat!

  public var color = K.Badge.backgroundColor.withAlphaComponent(0.8) { didSet { styleUI() } }

  public var bordered = true {
    didSet {
      if bordered {
        label.bordered(size! / 12, color: UIColor.white.cgColor)
      } else {
        label.bordered(size! / 12, color: K.Badge.backgroundColor.cgColor)
      }
    }
  }

  public var value: String! {
    get {
      return label.text
    }
    set {
      animate {
        self.label.text = newValue
      }

      if newValue != "" && newValue != "0" {
        label.isHidden = false
      } else {
        label.isHidden = true
      }
    }
  }

  public init(size: CGFloat? = K.Badge.size, value: String = "") {
    self.size = size
    self.badgeSize = size! * 1.5
    super.init(frame: .zero)

    self.value = value
    layout([body.layout([label])])
    label.isHidden = true
  }

  override open func styleUI() {
    super.styleUI()
    size = badgeSize / 1.5
    bordered = true
    label.textColor = K.Badge.color
    label.font = UIFont.systemFont(ofSize: size)
    label.backgroundColor = color
    label.radiused(badgeSize / 2)
    label.textAlignment = .center
  }

  override public init(frame: CGRect) {
    super.init(frame: frame)
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: badgeSize)
    body.fillSuperview()
    let w = max(badgeSize, label.intrinsicContentSize.width * 1.35)
    var yPad: CGFloat = -3
    if (superview?.height)! > height {
      yPad = 2
    }
    label.anchorInCorner(.topRight, xPad: (superview!.width - w) / 4.5, yPad: yPad, width: w, height: badgeSize)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
