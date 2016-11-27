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
    if selectData != nil { value.text(selectData.forHuman) } }}
  public var didSelect: (selected: SelectOption?) -> () = {_ in }
  
  public var icon = IconLabel(iconCode: K.Icons.angleRight, iconColor: K.Color.Text.strong)
  
  public var collectionData: [SelectOption]? = [SelectOption]()
  public var selected: SelectOption?

  var vc: SelectionViewController!
  public func setData(selectOptions: [SelectOption]?, selected: SelectOption?) {
    self.collectionData = selectOptions
    self.selectData = selected
    
    guard let _ = selected else { return }
    guard let _ = collectionData else { return }
    if let _ = selected!.family {
      self.selected = selected!.family![(collectionData!.first?.level)!]
    } else {
      self.selected = selected
    }
  }
  
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
    _logForUIMode()
    vc = SelectionViewController(title: self.label.text!)
    vc.didSelect = { index, selected in
      self.selectData = selected
      self.didSelect(selected: selected)
    }
    vc.selectData = selectData
    vc.collectionData = collectionData!
    self.pushViewController(vc as! UIViewController)
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    icon.anchorToEdge(.Right, padding: 0, width: label.textHeight(), height: label.textHeight() * 1.5)
  }
}