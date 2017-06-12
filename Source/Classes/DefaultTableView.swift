//  DefaultTableView.swift
//
//  Created by ctslin on 6/27/16.

import UIKit

public class DefaultTableView: DefaultView {

  public var tableView: UITableView!
  public var cell: TableViewCell!

  public var collectionData = [AnyObject]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  public func removeCell(tableView: UITableView, indexPath: NSIndexPath, onComplete: () -> ()) {
    collectionData.removeAtIndex(indexPath.row)
    delayedJob { tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade) }
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return collectionData.count }

  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if cell != nil {
      cell.layoutIfNeeded()
      cell.layoutSubviews()
      return cell.bottomView.bottomEdge() + defaultBottomPadding()
    } else {
      return 0
    }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    tableView.fillSuperview()
  }

}

