//
//  CollectionViewCell.swift
//  gff
//
//  Created by ctslin on 3/2/16.
//  Copyright © 2016 GFF. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  var didFixedConstraints = false
  var bottomView: UIView!
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    layoutUI() // 建立 UI 框架
    styleUI() // 視覺化 UI 框架
    bindUI()  // 綁定 UI 事件

  }

  func layoutUI() {
    // loadData() // 在 initUI 末載入資料
  }

  func styleUI() {

  }

  func bindUI() {

  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
