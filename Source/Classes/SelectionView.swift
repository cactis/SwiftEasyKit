//
//  SelectionView.swift
//
//  Created by ctslin on 3/23/16.

import Foundation

open class SelectionView: DefaultView {

  let selectionVC = SWKSelectionViewController(title: "", levelLimit: 0)
  public var view: UIView!
  public var collectionData: [SelectOption]! { didSet { selectionVC.collectionData = collectionData } }
  public var selectedData: SelectOption! { didSet { selectionVC.selectedData = selectedData }}
  public var targetView: UIView!
  public var didSelect: (_ index: NSIndexPath, _ selected: SelectOption?) -> () = {_,_  in } { didSet { selectionVC.didSelect = didSelect } }

  public init(options: [SelectOption], selectedData: SelectOption?, targetView: UIView) {
    self.collectionData = options
    self.selectedData = selectedData

    selectionVC.collectionData = options
    selectionVC.selectedData = selectedData
    self.view = selectionVC.view

    self.targetView = targetView
    super.init(frame: .zero)
  }

  override open func layoutUI() {
    super.layoutUI()
    layout([view])
  }

  open override func styleUI() {
    super.styleUI()
    view.backgroundColored(.clear)
//    backgroundColored(.black)
  }

  open override func bindUI() {
    super.bindUI()
    view.whenTapped(self, action: #selector(viewTapped))
  }

  @objc func viewTapped() { visible = false }

  public var visible = false { didSet { layoutSubviews() } }

  override open func layoutSubviews() {
    super.layoutSubviews()
    animate {
      if self.visible {
        self.isHidden = false
        let h = CGFloat([self.collectionData.count * Int(self.selectionVC.cellHeight), Int(screenHeight() / 2)].min()!)
        self.selectionVC.tableView.alignUnder(self.targetView, withLeftPadding: 0, topPadding: 0, width: screenWidth(), height: h)
      } else {
        self.isHidden = true
        self.selectionVC.tableView.alignUnder(self.targetView, withLeftPadding: 0, topPadding: 0, width: screenWidth(), height: 0)
      }
      self.view.fillSuperview()
    }
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
