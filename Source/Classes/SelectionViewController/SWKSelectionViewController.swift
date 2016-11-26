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
  var selectData: SelectOption? { didSet {
    _logForUIMode(selectData?.toJSON(), title: "selectData")
    tableView.reloadData()
    } }
  let cellHeight: CGFloat = 60
  
  var didSelect: (index: NSIndexPath, selected: SelectOption?) -> () = {_ in }
  
  var titleText: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    titled(titleText!, token: "SVS")
  }
  
  init(title: String?) {
    super.init(nibName: nil, bundle: nil)
    self.titleText = title
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
    if let _ = selected.children_url {
      selected.children({ (children) in
        let vc = SelectionViewController(title: selected.forHuman)
        vc.collectionData = children!
        if ((selected.family?.contains(selected)) != nil) {
            vc.selectData = self.selectData
        } else {
          vc.selectData = selected
        }
        
        vc.didSelect = self.didSelect
        self.pushViewController(vc, checked: false)
      })
    } else {
      self.selectData = selected
      didSelect(index: index, selected: selected)
      delayedJob(0.5) {
        let vcs = (self.navigationController?.viewControllers)!
        let i = vcs.indexOf(self)
        let back = (vcs.count - (selected.level! + 2))
        self.navigationController?.popToViewController(vcs[back], animated: true)
      }
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
    
    selectCell.checked = selectData?.name == item.name
    selectCell.checked = selectData?.id == item.id
//    _logForUIMode(selectData?.toJSON(), title: "selectData 中文")
//    NSLog("aaa", "bbb")
//    _logForUIMode(selectData?.family?.asJSON(), title: "selectData?.family")
    
    if let family = selectData?.family {
      if (family.map({$0.id!}).indexOf(item.id!) != nil) {
        selectCell.checked = true
      }
    }
    
    
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