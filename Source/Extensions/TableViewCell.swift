//
//  TableViewCell.swift

import UIKit

class TableViewCell: UITableViewCell {

  var didFixedConstraints = false
  var bottomView = UIView()

  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutUI()
    styleUI()
    bindUI()
  }

  func layoutUI() {
    bottomView = self
  }

  func styleUI() {
    backgroundColor = K.Color.table
  }

  func bindUI() {
    
  }

  func bottomPadding() -> CGFloat {
    return K.Size.Padding.large
  }

  func autoHeight(padding: CGFloat? = nil) -> CGFloat {
    let _padding = padding ?? bottomPadding()
    return bottomView.bottomEdge() + _padding
  }

//
//  func loadData(data: NSDictionary) {
//    
//  }

  override func layout(views: [UIView]) -> UIView {
    views.forEach { (view) -> () in
      addSubview(view)
      bottomView = view
    }
    return self
  }


  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    contentView.fillSuperview(left: 10, right: 10, top: 10, bottom: 10)
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
