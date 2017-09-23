//  DefaultTableView.swift
//
//  Created by ctslin on 6/27/16.

import UIKit

open class DefaultTableView: DefaultView, UITableViewDataSource, UITableViewDelegate {

  public var tableView: UITableView!
  public var cell: TableViewCell!

  public var collectionData = [AnyObject]() { didSet { tableView.reloadData() } }

  open func removeCell(tableView: UITableView, indexPath: NSIndexPath, onComplete: () -> ()) {
    tableView.beginUpdates()
    collectionData.remove(at: indexPath.row)
    tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
    tableView.endUpdates()
  }

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return TableViewCell()
  }

  open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if cell != nil {
      cell.layoutIfNeeded()
      cell.layoutSubviews()
      return cell.bottomView.bottomEdge() + defaultBottomPadding()
    } else {
      return 0
    }
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    tableView.fillSuperview()
  }

}

