//
//  SWKSelectionViewController.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/11/25.
//  Copyright © 2016年 airfont. All rights reserved.
//

import UIKit

class SWKSelectionViewController: TableViewController {

  var collectionData = [SelectOption]() { didSet {
    tableView.reloadData() }}

  var selectedData: SelectOption? { didSet {
    tableView.reloadData()
//    let index = collectionData.ids.index(of: (selectedData?.id!)!)
//    tableView.reloadRows(at: [IndexPath(item: index!, section: 0)], with: .fade)
    } }
  let cellHeight: CGFloat = 45

  var didSelect: (_ index: IndexPath, _ selected: SelectOption?) -> () = {_,_  in }

  var titleText: String?
  var levelLimit: Int!

  override func viewDidLoad() {
    super.viewDidLoad()
    titled(titleText!, token: "SWKSel")
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
//    if collectionData.count == 0 { seeds() }
  }

  override func styleUI() {
    super.styleUI()
    tabBarHidden = true
    tableView.separatorStyle = .singleLine
    automaticallyAdjustsScrollViewInsets = false
  }

  @objc override func cellTapped(_ sender: UITapGestureRecognizer) {
    _logForUIMode()
    let index = tableView.indexOfTapped(sender)
    let selected = collectionData[index.row]
    // 以獨立頁面開啟
    if navigationController != nil {
      // 若有子網址，打開下一層選單繼續選 // 或者被限定只選到第幾層
      if selected.children_url != nil && selected.level! < levelLimit {
        selected.getChildren({ (children) in
          let vc = SWKSelectionViewController(title: selected.forHuman)
          vc.collectionData = children!
          if ((selected.family?.contains(selected)) == true) {
            // Important!!!
            vc.selectedData = self.selectedData
            self.selectedData = selected
          } else {
            vc.selectedData = selected
          }
          vc.didSelect = self.didSelect
          self.pushViewController(vc, checked: false)//, delayed: 0.1)
        })
      } else {
        // 退回起始輸入頁面
        self.selectedData = selected
        didSelect(index, selected)
        let vcs = (navigationController?.viewControllers)!
        _ = vcs.index(of: self)
        let back = (vcs.count - (selected.level! + 2))
        self.popToViewController(vcs[back], delayed: 0)
      }
    } else {
      // 以子頁面開啟
      self.selectedData = selected
//      delayedJob({
      self.didSelect(index, selected)
//      })
    }
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return cellHeight
  }

  override func updateViewConstraints() {
    super.updateViewConstraints()
    let h = collectionData.count.cgFloat * cellHeight
    if h > view.viewNetHeight() {
      tableView.fillSuperview()
    } else {
      tableView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: h)
//      let borderBottom = view.addView()
//      borderBottom.alignUnder(tableView, matchingLeftAndRightWithTopPadding: 0, height: 1)
//      let b = borderBottom.bottomBordered()
//      b.bordered(1, color: UIColor.lightGray.lighter(0.1).cgColor)//.shadowed()
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! SelectionCell
    let item = collectionData[indexPath.row]
    let selectCell = (cell as! SelectionCell)
    selectCell.loadData(item)
    if let _ =  selectedData { selectCell.checked = (selectedData?.family?.contains(item))! == true }
    cell.whenTapped(self, action: #selector(cellTapped(_:)))
    cell.layoutIfNeeded()
    return cell
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return collectionData.count }

  func seeds() { }

  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
