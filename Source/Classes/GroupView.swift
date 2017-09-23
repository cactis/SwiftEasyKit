//  GruposView.swift
//

import UIKit
import Neon
import Facade

open class GroupsView: DefaultView {

  public var body: UIView!
  public var groupMargins: [UIView]! = []
  public var groups: [UIView]! = []

  public var count: Int! = 2
  public var padding: CGFloat! = 0
  public var group: Neon.Group! = .horizontal
  public var margin: UIEdgeInsets!

  public var label: UILabel!

  public init(count: Int? = 2, padding: CGFloat? = 0, group: Neon.Group? = .horizontal, margin: UIEdgeInsets? = .zero) {
    self.count = count
    self.padding = padding
    self.group = group!
    self.margin = margin!

    super.init(frame: .zero)

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

  override open func layoutSubviews() {
    super.layoutSubviews()
    body.fillSuperview()
    body.groupAndFill(group: group, views: groupMargins.map({$0 as UIView}) , padding: padding!)
    groups.forEach({ (v) -> () in
      v.fillSuperview(withLeftPadding: margin.left, rightPadding: margin.right, topPadding: margin.top, bottomPadding: margin.bottom)
    })
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
