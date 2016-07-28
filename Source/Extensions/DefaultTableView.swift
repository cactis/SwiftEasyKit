//  DefaultTableView.swift
//
//  Created by ctslin on 6/27/16.

import UIKit

class DefaultTableView: DefaultView {

  var tableView: UITableView!
  var cell: TableViewCell!

  var collectionData = [AnyObject]() {
    didSet {
      tableView.reloadData()
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return collectionData.count }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if cell != nil {
      cell.layoutIfNeeded()
      cell.layoutSubviews()
      return cell.bottomView.bottomEdge() + bottomPadding()
    } else {
      return 0
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.fillSuperview()
  }
  
}

