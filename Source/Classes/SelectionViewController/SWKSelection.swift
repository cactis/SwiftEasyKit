//
//  SWKSelection.swift
//  
//
//  Created by ctslin on 2016/11/25.
//
//

import UIKit

public class SWKSelection: SWKInput {
  
  public var selectData: SelectOption! { didSet {
    if selectData != nil {
      _logForUIMode(selectData.toJSON(), title: "selectData 33333")
      value.text(selectData.forHuman)
//      didSelect(selected: selected)
    }
    }}
  public var didSelect: (selected: SelectOption?) -> () = {_ in }
  
  public var icon = IconLabel(iconCode: K.Icons.angleRight, iconColor: K.Color.Text.strong)
  
  public var collectionData = [SelectOption]()
  public var selected: SelectOption?

  var vc: SelectionViewController!
  public func setData(collectionData: [SelectOption], selected: SelectOption?) {
    _logForUIMode(selected?.toJSON(), title: "selected 222222")
    self.collectionData = collectionData
    self.selectData = selected
    if let _ = selected?.family {
      self.selected = selected?.family![(collectionData.first?.level)!]
    } else {
      self.selected = selected
    }
  }
  
//  public var cancelableJob: dispatch_cancelable_closure!
  override public func prefix() -> String { return "選取" }
  
  override public func styleUI() {
    super.styleUI()
    value.enabled = false
  }
  
  override public func layoutUI() {
    super.layoutUI()
    layout([icon])
  }
  
  override public func bindUI() {
    super.bindUI()
    whenTapped(self, action: #selector(selfTapped))
  }
  
  public func selfTapped() {
    vc = SelectionViewController(title: self.label.text!)
    vc.didSelect = { index, selected in
      self.selectData = selected
      self.didSelect(selected: selected)
    }
    vc.selectData = selectData
    vc.collectionData = collectionData
    self.pushViewController(vc as! UIViewController)
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    icon.anchorToEdge(.Right, padding: 0, width: label.textHeight(), height: label.textHeight() * 1.5)
  }
  //  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}