//
//  SWKSelectionViewController.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/11/25.
//  Copyright © 2016年 airfont. All rights reserved.
//

import UIKit

class SelectionViewController: TableViewController {
  
  var collectionData = [SelectOption]() { didSet { tableView.reloadData() } }
  var selectData: SelectOption? { didSet { tableView.reloadData() } }
  let cellHeight: CGFloat = 60
  
  var didSelect: (index: NSIndexPath, selected: SelectOption?) -> () = {_ in }
  
  var titleText: String?
  var levelLimit: Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titled(titleText!, token: "SVS")
  }
  
  init(title: String?, levelLimit: Int = 100) {
    super.init(nibName: nil, bundle: nil)
    self.titleText = title
    self.levelLimit = levelLimit
  }
  
  override func layoutUI() {
    super.layoutUI()
    tableView = tableView(SelectionCell.self, identifier: CellIdentifier)
    view.layout([tableView])
    if collectionData.count == 0 { seeds() }
  }
  
  override func styleUI() {
    super.styleUI()
    tabBarHidden = true
    tableView.separatorStyle = .SingleLine
    automaticallyAdjustsScrollViewInsets = false
    let bottomBorder = UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 1))
    tableView.tableFooterView = bottomBorder
  }
  
  func cellTapped(sender: UITapGestureRecognizer) {
    let index = tableView.indexOfTapped(sender)
    let selected = collectionData[index.row]
    if selected.children_url != nil && selected.level < levelLimit {
      selected.children({ (children) in
        let vc = SelectionViewController(title: selected.forHuman)
        vc.collectionData = children!
        if ((selected.family?.contains(selected)) == true) {
          // Important!!!
          vc.selectData = self.selectData
          self.selectData = selected
        } else {
          vc.selectData = selected
        }
        vc.didSelect = self.didSelect
        self.pushViewController(vc, checked: false, delayed: 0.1)
      })
    } else {
      self.selectData = selected
      didSelect(index: index, selected: selected)
      let vcs = (navigationController?.viewControllers)!
      let i = vcs.indexOf(self)
      let back = (vcs.count - (selected.level! + 2))
      self.popToViewController(vcs[back], delayed: 0.4)
    }
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cellHeight
  }
  
  override func updateViewConstraints() {
    super.updateViewConstraints()
    let h = collectionData.count.cgFloat * cellHeight
    if h > view.viewNetHeight() {
      tableView.fillSuperview()
    } else {
      tableView.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: h)
      let borderBottom = view.addView()
      borderBottom.alignUnder(tableView, matchingLeftAndRightWithTopPadding: 0, height: 1)
      let b = borderBottom.bottomBordered()
      b.bordered(1, color: UIColor.lightGrayColor().lighter(0.1).CGColor)//.shadowed()
    }
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! SelectionCell
    let item = collectionData[indexPath.row]
    let selectCell = (cell as! SelectionCell)
    selectCell.loadData(item)
    if let _ =  selectData { selectCell.checked = (selectData?.family?.contains(item))! == true }
    cell.whenTapped(self, action: #selector(cellTapped(_:)))
    cell.layoutIfNeeded()
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }
  
  func seeds() { }
  
  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}