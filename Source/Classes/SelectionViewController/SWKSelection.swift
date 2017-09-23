//
//  SWKSelection.swift
//
//
//  Created by ctslin on 2016/11/25.
//
//

import UIKit

open class SWKSelection: SWKInput {

  public var selectedData: SelectOption! {
    didSet {
      if selectedData != nil {
        value.texted(selectedData.forHuman)
      }
    }}
  public var didSelect: (_ selected: SelectOption?) -> () = {_ in }

  public var icon = IconLabel(iconCode: K.Icons.angleRight, iconColor: K.Color.Text.strong)

  public var collectionData: [SelectOption]? = [SelectOption]()
  public var selected: SelectOption?
  public var levelLimit: Int!

  var vc: SWKSelectionViewController!
  public func setData(_ selectOptions: [SelectOption]?, selected: SelectOption?, levelLimit: Int = 100) {
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

  override open func styleUI() {
    super.styleUI()
    value.isEnabled = false
  }

  override open func layoutUI() {
    super.layoutUI()
    layout([icon])
  }

  override open func bindUI() {
    super.bindUI()
    whenTapped(self, action: #selector(selfTapped))
  }

  public func selfTapped() {
    vc = SWKSelectionViewController(title: self.label.text!, levelLimit: levelLimit)
    vc.didSelect = { index, selected in
      self.selectedData = selected
      self.didSelect(selected)
    }
    vc.selectedData = selectedData
    vc.collectionData = collectionData!
    self.pushViewController(vc as! UIViewController)
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    icon.anchorToEdge(.right, padding: 0, width: label.textHeight(), height: label.textHeight() * 1.5)
  }
}
