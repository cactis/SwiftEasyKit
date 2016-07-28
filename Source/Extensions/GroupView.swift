//  GruposView.swift
//

import UIKit
import Neon
import Facade

class GroupsView: DefaultView {

  var body: UIView!
  var groupMargins: [UIView]! = []
  var groups: [UIView]! = []

  var count: Int! = 2
  var padding: CGFloat! = 0
  var group: Neon.Group! = .Horizontal
  var margin: UIEdgeInsets!

  var label: UILabel!

  init(count: Int? = 2, padding: CGFloat? = 0, group: Neon.Group? = .Horizontal, margin: UIEdgeInsets? = UIEdgeInsetsZero) {
    self.count = count
    self.padding = padding
    self.group = group!
    self.margin = margin!

    super.init(frame: CGRectZero)

    body = addView()
    for _ in 0...count! - 1 {
      let v = body.addView()
      groupMargins.append(v)
      let g = v.addView()
      groups.append(g)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    body.fillSuperview()
    body.groupAndFill(group: group, views: groupMargins.map({$0 as UIView}) , padding: padding!)
    groups.forEach({ (v) -> () in
      v.fillSuperviewWithLeftPadding(margin.left, rightPadding: margin.right, topPadding: margin.top, bottomPadding: margin.bottom)
    })

  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
