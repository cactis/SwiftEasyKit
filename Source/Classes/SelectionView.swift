//
//  SelectionView.swift
//
//  Created by ctslin on 3/23/16.

import Foundation

open class SelectionView: DefaultView {

  let vc = SWKSelectionViewController(title: "", levelLimit: 0)
  public var tableView: UITableView!
  public var view: UIView!
  public var collectionData: [SelectOption]! { didSet { vc.collectionData = collectionData } }
  public var selectedData: SelectOption! { didSet { vc.selectedData = selectedData }}
  public var targetView: UIView!
  public var didSelect: (_ index: NSIndexPath, _ selected: SelectOption?) -> () = {_,_  in } { didSet { vc.didSelect = didSelect } }
//  public var didSelect: (selected: SelectOption) -> () = {_ in } { didSet { vc.didSelect = didSelect } }

  public init(options: [SelectOption], selectedData: SelectOption?, targetView: UIView) {
    self.collectionData = options
    vc.collectionData = options
    vc.selectedData = selectedData
    self.view = vc.view
    super.init(frame: .zero)
  }

  public var expended = false { didSet {
    if expended { self.superview!.bringSubview(toFront: self) } } }

  override open func layoutUI() {
    super.layoutUI()
    layout([view])
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    animate {
      if !self.expended {
        self.alignUnder(self.targetView, withLeftPadding: 0, topPadding: 0, width: screenWidth(), height: 0)
      } else {
        let h = CGFloat([self.collectionData.count * Int(self.vc.cellHeight), Int(screenHeight() / 2)].min()!)
        self.alignUnder(self.targetView, withLeftPadding: 0, topPadding: 40, width: screenWidth(), height: h)
      }
    }
    view.fillSuperview()
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
