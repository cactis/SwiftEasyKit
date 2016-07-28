//
//  BadgeLabel.swift
//
//  Created by ctslin on 2/28/16.

import UIKit

class BadgeLabel: DefaultView {
  var label = UILabel()
  var badge = Badge(size: 10, value: "")

  var size: CGFloat! = K.Size.Text.small { didSet { label.font = UIFont.systemFontOfSize(size); badge.badgeSize = size } }
  var text: String! { didSet { label.text(text) } }
  var value: String! {
    didSet {
      badge.value = value
    }
  }

  init(text: String, size: CGFloat = 12, value: String = "") {
    super.init(frame: CGRectZero)
    ({ self.size = size })()
    ({ self.value = value })()
    ({ self.text = text })()
  }

  override func layoutUI() {
    super.layoutUI()
    layout([label, badge])
  }

  override func styleUI() {
    super.styleUI()
    label.textAlignment = .Center
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    label.anchorInCenter(width: width, height: label.textHeight())
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}