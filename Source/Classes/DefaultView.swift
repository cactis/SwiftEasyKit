//
//  DefaultView.swift

import UIKit
import Neon

open class DefaultView: UIView {

  public var didFixedConstraints = false
  public var bottomView: UIView?
  public let cellIdentifier = "CELL"

  override public init(frame: CGRect) {
    super.init(frame: frame)
    layoutUI() // 建立 UI 框架
    styleUI() // 視覺化 UI 框架
    bindUI()  // 綁定 UI 事件
    bindData() // 綁定資料
  }

  @discardableResult open func defaultBottomPadding() -> CGFloat {
    return K.Size.Padding.large
  }

  @discardableResult open func autoHeight(_ padding: CGFloat? = nil) -> CGFloat {
//    layoutIfNeeded()
    let _padding = padding ?? defaultBottomPadding()
    if (bottomView != nil) {
      return bottomView!.bottomEdge() + _padding
    } else {
      return 0
    }
  }

  open func layoutUI() {
    // loadData() // 在 initUI 末載入資料
  }

  open func styleUI() {

  }

  open func bindUI() {

  }

  open func bindData() {

  }

  override open func layoutSubviews() {

  }

  @discardableResult override open func layout(_ views: [UIView]) -> UIView {
    views.forEach { (view) -> () in
      addSubview(view)
      bottomView = view
    }
    return self
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
