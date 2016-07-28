//
//  SelectionView.swift
//
//  Created by ctslin on 3/23/16.

import Foundation

class SelectionView: DefaultView, UITableViewDelegate, UITableViewDataSource {

  var tableView: UITableView!
  var collectionData = [String]()
  var cell: SelectionCell!
  var selected: (index: Int) -> () = {_ in }
  var expended = false {
    didSet {
      if expended {
        self.superview!.bringSubviewToFront(self)
      }
    }
  }

  var targetView: UIView!
  var cellHeight: CGFloat = 30

  init(items: [String], targetView: UIView) {
    self.collectionData = items
    self.targetView = targetView
    super.init(frame: CGRectZero)
  }

  override func layoutUI() {
    super.layoutUI()
    tableView = tableView(SelectionCell.self, identifier: cellIdentifier)
    layout([tableView])
  }

  override func styleUI() {
    super.styleUI()
    shadowed()
  }

  override func bindUI() {
    super.bindUI()
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SelectionCell
    cell.loadData(collectionData[indexPath.row])
    cell.layoutIfNeeded()
    return cell
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cellHeight
  }

  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    _logForUIMode()
  }

  func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    _logForUIMode()
    return indexPath
  }

  override func layoutSubviews() {
    animate {
      if !self.expended {
        self.alignUnder(self.targetView, withLeftPadding: 0, topPadding: 0, width: screenWidth(), height: 0)
      } else {
        let h = CGFloat([self.collectionData.count * Int(self.cellHeight), Int(screenHeight() / 2)].minElement()!)
        self.alignUnder(self.targetView, withLeftPadding: 0, topPadding: 0, width: screenWidth(), height: h)
      }
    }
    tableView.fillSuperview()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

    class SelectionCell: TableViewCell {
      var label = UILabel()
      var checked = UIImageView()

      var checkedIcon = getIcon(.Check, options: ["color": K.Color.checked])

      var isChecked: Bool = false {
        didSet {
          if isChecked {
            checked.image = checkedIcon
          } else {
            checked.image = nil
          }
        }
      }

      override func layoutUI() {
        super.layoutUI()
        layout([checked, label])
//        bottomView = label
      }

      override func styleUI() {
        super.styleUI()
        label.styled()
        backgroundColor = UIColor.whiteColor()
      }

      override func bindUI() {
        super.bindUI()
        whenTapped(self, action: #selector(SelectionCell.selfTapped))
      }

      func selfTapped() {
        isChecked = !isChecked
        _logForUIMode(isChecked)
      }

      func loadData(data: String) {
        label.text(data)
      }

      override func layoutSubviews() {
        label.anchorAndFillEdge(.Left, xPad: 10, yPad: 5, otherSize: label.textWidth())
//        checked.alignToTheRightOf(label, matchingTopWithLeftPadding: 10, width: K.barButtonItem.size, height: K.barButtonItem.size)
        checked.anchorToEdge(.Right, padding: 10, width: K.BarButtonItem.size, height: K.BarButtonItem.size)
      }
    }

}
