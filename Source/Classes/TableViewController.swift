//
//  TableViewController.swift

import UIKit

open class TableViewController: DefaultViewController, UITableViewDataSource, UITableViewDelegate {

  public var tableView = UITableView()
  public let CellIdentifier = "CELL"
  public var cell: TableViewCell!

  override open func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isTranslucent = false
//    tableView = view.addTableView(CustomCell, identifier: CellIdentifier)
//    loadData()
  }

  open func headerHeight() -> CGFloat {
    return K.Size.Header.height
  }

  open func cellExtraHeight() -> CGFloat {
    return 30
  }

  open func cellTapped(_ sender: UITapGestureRecognizer) {

  }

//  func cellTapped(sender: UITapGestureRecognizer) -> NSIndexPath {
//    return tableView.indexPathForRowAtPoint(sender.view!.convertPoint(.zero, toView: tableView))!
//  }

  open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    cell.layoutIfNeeded()
    cell.layoutSubviews()
    return cell.bottomView.bottomEdge() + cellExtraHeight()
  }

  override open func updateViewConstraints() {
    super.updateViewConstraints()
    tableView.fillSuperview(left: 0, right: 0, top: 0, bottom: tabBarHeight())
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)! as UITableViewCell
//    let data = collectionData[indexPath.row]
//    cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! CourseCell
//    cell.loadData(data)
//    cell.layoutIfNeeded()
    cell.whenTapped(self, action: #selector(cellTapped(_:)))
    return cell
  }

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
}
