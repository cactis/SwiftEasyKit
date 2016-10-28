//
//  CodeInput.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/10/28.
//  Copyright © 2016年 airfont. All rights reserved.
//

import UIKit

public class CodeInput: DefaultView {
  public var inputs = [UITextField]()
  var num: Int { didSet { layoutUI() } }
  var limit: Int!

  public init(num: Int = 1, limit: Int) {
    self.num = num
    self.limit = limit
    super.init(frame: CGRectZero)
  }

  public override func layoutUI() {
    super.layoutUI()
    removeSubviews()
    (1...num).forEach { (i) in
      inputs.append(UITextField())
    }
    layout(inputs)
  }

  public override func styleUI() {
    super.styleUI()
    inputs.forEach { (input) in
      input.textAlignment = .Center
      input.borderStyle = .RoundedRect
      //      input.rightViewMode = .Never
      //      input.clearButtonMode = .Never
    }
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    groupAndFill(group: .Horizontal, views: inputs.map({$0 as UIView}), padding: 10)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
}