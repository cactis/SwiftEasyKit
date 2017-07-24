//
//  TableViewController.swift

import UIKit

public class TableViewController: DefaultViewController, UITableViewDataSource, UITableViewDelegate {

  public var tableView = UITableView()
  public let CellIdentifier = "CELL"
  public var cell: TableViewCell!

  override public func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.translucent = false
//    tableView = view.addTableView(CustomCell, identifier: CellIdentifier)
//    loadData()
  }

  public func headerHeight() -> CGFloat {
    return K.Size.Header.height
  }

  public func cellExtraHeight() -> CGFloat {
    return 30
  }
  
  public func cellTapped(sender: UITapGestureRecognizer) {
    
  }

//  func cellTapped(sender: UITapGestureRecognizer) -> NSIndexPath {
//    return tableView.indexPathForRowAtPoint(sender.view!.convertPoint(CGPointZero, toView: tableView))!
//  }

  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    cell.layoutIfNeeded()
    cell.layoutSubviews()
    return cell.bottomView.bottomEdge() + cellExtraHeight()
  }

  override public func updateViewConstraints() {
    super.updateViewConstraints()
    tableView.fillSuperview(left: 0, right: 0, top: 0, bottom: tabBarHeight())
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)! as UITableViewCell
//    let data = collectionData[indexPath.row]
//    cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! CourseCell
//    cell.loadData(data)
//    cell.layoutIfNeeded()
    cell.whenTapped(self, action: #selector(cellTapped(_:)))
    return cell
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
}
