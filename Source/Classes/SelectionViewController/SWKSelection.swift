//
//  SWKSelection.swift
//  
//
//  Created by ctslin on 2016/11/25.
//
//

import UIKit

public class SWKSelection: SWKInput {
  
  public var selectedData: SelectOption! {
    didSet {
      if selectedData != nil {
        value.text(selectedData.forHuman)
      }
    }}
  public var didSelect: (selected: SelectOption?) -> () = {_ in }
  
  public var icon = IconLabel(iconCode: K.Icons.angleRight, iconColor: K.Color.Text.strong)
  
  public var collectionData: [SelectOption]? = [SelectOption]()
  public var selected: SelectOption?
  public var levelLimit: Int!
  
  var vc: SelectionViewController!
  public func setData(selectOptions: [SelectOption]?, selected: SelectOption?, levelLimit: Int = 100) {
    self.collectionData = selectOptions
    self.selectedData = selected
    self.levelLimit = levelLimit
    
    guard let _ = selected else { return }
    guard let _ = collectionData else { return }
    if let _ = selected!.family {
      self.selected = selected!.family![(collectionData!.first?.level)!]
    } else {
      self.selected = selected
    }
  }
  //  
  //  override init(label: String, value: String, prefix: String) {
  //    super.init(label: label, prefix: "選取")
  //  }
  
  //  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
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
    vc = SelectionViewController(title: self.label.text!, levelLimit: levelLimit)
    vc.didSelect = { index, selected in
      self.selectedData = selected
      self.didSelect(selected: selected)
    }
    vc.selectedData = selectedData
    vc.collectionData = collectionData!
    self.pushViewController(vc as! UIViewController)
  }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    icon.anchorToEdge(.Right, padding: 0, width: label.textHeight(), height: label.textHeight() * 1.5)
  }
}