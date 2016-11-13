//
//  DefaultView.swift

import UIKit
//import Neon

public class DefaultView: UIView {

  public var didFixedConstraints = false
  public var bottomView: UIView?
  public let cellIdentifier = "CELL"

  override public init(frame: CGRect) {
    super.init(frame: frame)

    layoutUI() // 建立 UI 框架
    styleUI() // 視覺化 UI 框架
    bindUI()  // 綁定 UI 事件
  }

  public func bottomPadding() -> CGFloat {
    return K.Size.Padding.large
  }

  public func autoHeight(padding: CGFloat? = nil) -> CGFloat {
//    layoutIfNeeded()
    let _padding = padding ?? bottomPadding()
    if (bottomView != nil) {
      return bottomView!.bottomEdge() + _padding
    } else {
      return 0
    }
  }

  public func layoutUI() {
    // loadData() // 在 initUI 末載入資料
  }

  public func styleUI() {

  }

  public func bindUI() {

  }

  override public func layoutSubviews() {
    
  }

  override public func layout(views: [UIView]) -> UIView {
    views.forEach { (view) -> () in
      addSubview(view)
      bottomView = view
    }
    return self
  }


  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}


