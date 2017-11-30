//
//  TableViewCell.swift

import UIKit

open class TableView: UITableView {

}

open class TableViewCell: UITableViewCell {

  public var didFixedConstraints = false
  public var bottomView = UIView()
  public var tableView: UITableView?
  public var delegate: UIViewController?
  public var didDataUpdated: (_ data: AnyObject?) -> () = {_ in }
  public var didDataDeleted: () -> () = { }

  override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutUI()
    styleUI()
    bindUI()
  }

  open func layoutUI() {
    bottomView = self
  }

  open func styleUI() {
    backgroundColor = K.Color.table
  }

  open func bindUI() {

  }

  open func defaultBottomPadding() -> CGFloat {
    return K.Size.Padding.large
  }

  open func autoHeight(padding: CGFloat? = nil) -> CGFloat {
    let _padding = padding ?? defaultBottomPadding()
    return bottomView.bottomEdge() + _padding
  }

  @discardableResult override open func layout(_ views: [UIView]) -> UIView {
    views.forEach { (view) -> () in
      addSubview(view)
      bottomView = view
    }
    return self
  }


  override open func awakeFromNib() {
    super.awakeFromNib()
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
//    _logForAnyMode()
//    contentView.fillSuperview(left: 10, right: 10, top: 10, bottom: 10)
    contentView.fillSuperview()
  }

  override open func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
