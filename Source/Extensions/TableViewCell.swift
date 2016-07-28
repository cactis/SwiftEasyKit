//
//  TableViewCell.swift

import UIKit

public class TableViewCell: UITableViewCell {

  public var didFixedConstraints = false
  public var bottomView = UIView()

  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutUI()
    styleUI()
    bindUI()
  }

  public func layoutUI() {
    bottomView = self
  }

  public func styleUI() {
    backgroundColor = K.Color.table
  }

  public func bindUI() {

  }

  public func bottomPadding() -> CGFloat {
    return K.Size.Padding.large
  }

  public func autoHeight(padding: CGFloat? = nil) -> CGFloat {
    let _padding = padding ?? bottomPadding()
    return bottomView.bottomEdge() + _padding
  }

//
//  public func loadData(data: NSDictionary) {
//
//  }

  override public func layout(views: [UIView]) -> UIView {
    views.forEach { (view) -> () in
      addSubview(view)
      bottomView = view
    }
    return self
  }


  override public func awakeFromNib() {
    super.awakeFromNib()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    contentView.fillSuperview(left: 10, right: 10, top: 10, bottom: 10)
  }

  override public func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
