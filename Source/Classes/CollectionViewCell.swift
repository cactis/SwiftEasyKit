//
//  CollectionViewCell.swift
//
//  Created by ctslin on 3/2/16.

import UIKit

open class CollectionViewCell: UICollectionViewCell {
  public var didFixedConstraints = false
  public var bottomView: UIView!

  public override init(frame: CGRect) {
    super.init(frame: frame)
    layoutUI() // 建立 UI 框架
    styleUI() // 視覺化 UI 框架
    bindUI()  // 綁定 UI 事件
  }

  open func layoutUI() {
    // loadData() // 在 initUI 末載入資料
  }

  open func styleUI() {

  }

  open func bindUI() {

  }

  override open func layoutSubviews() {
    super.layoutSubviews()
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
