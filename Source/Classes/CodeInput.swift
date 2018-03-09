//
//  CodeInput.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/10/28.
//  Copyright © 2016年 airfont. All rights reserved.
//

import UIKit

open class CodeInput: DefaultView {
  public var inputs = [UITextField]()
  var num: Int { didSet { layoutUI() } }
  var limit: Int!
  
  public var data: String? {
    didSet {
      let times = ((data?.length())! / limit) - 1
      (0...times).forEach({ index in
        let pos = index * limit
        let text = String(data![pos..<pos + limit - 1])
        //        data![pos...pos + limit - 1]
        inputs[index].texted(text)
      })
    }
  }
  
  public var value: String {
    get {
      return inputs.map({$0.text!}).join()
    }
  }
  
  public init(num: Int = 1, limit: Int) {
    self.num = num
    self.limit = limit
    super.init(frame: .zero)
  }
  
  override open func layoutUI() {
    super.layoutUI()
    removeSubviews()
    (0...num - 1).forEach { (i) in
      inputs.append(UITextField())
    }
    layout(inputs)
  }
  
  override open func styleUI() {
    super.styleUI()
    inputs.forEach { (input) in
      input.textAlignment = .center
      input.borderStyle = .roundedRect
      //      input.rightViewMode = .Never
      //      input.clearButtonMode = .Never
    }
  }
  
  open override func bindUI() {
    super.bindUI()
    inputs.forEach{ input in
      input.addTarget(self, action: #selector(textChanged(sender:)), for: .editingChanged)
    }
  }
  
  @objc func textChanged(sender: UITextField) {
    let index = inputs.index(of: sender)!
    if sender == inputs.last {
      sender.endEditing(true)
    } else {
      let target = inputs[index + 1]
      target.becomeFirstResponder()
      if !(target.text?.isEmpty)! {
        let pos = target.position(from: target.beginningOfDocument, offset: 1)!
        target.selectedTextRange = target.textRange(from: pos, to: pos)
      }
      //      target.texted("")
    }
    
    if !(sender.text?.isEmpty)! {
      sender.texted(String(describing: sender.text!.characters.last!))
    }
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    groupAndFill(group: .horizontal, views: inputs.map({$0 as UIView}), padding: 10)
  }
  
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
}
