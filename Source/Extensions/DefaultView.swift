//
//  DefaultView.swift

import UIKit
//import Neon

class DefaultView: UIView {

  var didFixedConstraints = false
  var bottomView: UIView?
  let cellIdentifier = "CELL"

  override init(frame: CGRect) {
    super.init(frame: frame)

    layoutUI() // 建立 UI 框架
    styleUI() // 視覺化 UI 框架
    bindUI()  // 綁定 UI 事件
  }

  func bottomPadding() -> CGFloat {
    return K.Size.Padding.large
  }

  func autoHeight(padding: CGFloat? = nil) -> CGFloat {
//    layoutIfNeeded()
    let _padding = padding ?? bottomPadding()
    if (bottomView != nil) {
      return bottomView!.bottomEdge() + _padding
    } else {
      return 0
    }
  }

  func layoutUI() {
    // loadData() // 在 initUI 末載入資料
  }

  func styleUI() {

  }

  func bindUI() {

  }

  override func layoutSubviews() {
  }

  override func layout(views: [UIView]) -> UIView {
    views.forEach { (view) -> () in
      addSubview(view)
      bottomView = view
    }
    return self
  }


  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}


