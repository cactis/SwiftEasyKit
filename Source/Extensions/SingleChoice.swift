//
//  SingleChoice.swift
//
//  Created by ctslin on 4/8/16.

import UIKit

class MultipleChoiceTable: ChoiceTable {

  var value: [Int] = [] {
    didSet { refreshData() }
  }

  var didChange: (value: [Int]) -> () = { _ in}

  init(items: [String], value: [Int]) {
    super.init(frame: CGRectZero)
    self.items = items
    self.value = value
    refreshData()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func refreshData() {
    collectionData = []
    (0...items.count - 1).forEach { (index) in
      collectionData.append((title: items[index], checked: value.indexOf(index) != nil))
    }
    tableView.reloadData()
  }

  override func didSelect(indexPath: NSIndexPath?) {
    if let index = value.indexOf(indexPath!.row) {
      value.removeAtIndex(index)
    } else {
      value.append(indexPath!.row)
    }
    didChange(value: value)
  }
}


class SingleChoiceTable: ChoiceTable {

  var value: Int = -1 {
    didSet {
      refreshData()
    }
  }

  var didChange: (value: Int) -> () = { _ in}

  init(items: [String]) {
    super.init(frame: CGRectZero)
    self.items = items
    refreshData()
  }

  init(items: [String], value: Int) {
    super.init(frame: CGRectZero)
    self.items = items
    self.value = value
    refreshData()
  }

  func refreshData() {
    collectionData = []
    (0...items.count - 1).forEach { (index) in
      collectionData.append((title: items[index], checked: index == value))
    }
    tableView.reloadData()
  }

  override func didSelect(indexPath: NSIndexPath?) {
    value = indexPath!.row
    didChange(value: value)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

class ChoiceTable: DefaultView, UITableViewDelegate, UITableViewDataSource {
  var tableView: UITableView!
  var CellIdentifier = "CELL"
  var items: [String] = []
  var collectionData: [(title: String, checked: Bool)] = []

  override func layoutUI() {
    super.layoutUI()
    tableView = tableView(ChoiceCell.self, identifier: CellIdentifier)
    layout([tableView])
  }

  override func styleUI() {
    super.styleUI()
    tableView.separatorStyle = .SingleLine
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ChoiceCell
    cell.data = collectionData[indexPath.row]
    cell.whenTapped(self, action: #selector(ChoiceTable.cellTapped))
    return cell
  }

  func cellTapped(sender: UIGestureRecognizer) {
    didSelect(sender.indexPathInTableView(tableView))
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }

  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cellHeight()
  }

  func didSelect(indexPath: NSIndexPath?) { }

  func cellHeight() -> CGFloat {
    return K.Size.Text.normal * 3
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    tableView.fillSuperview()
  }

  class ChoiceCell: TableViewCell {
    var label = UILabel()
    var icon = UIImageView()
    var checked: Bool = false { didSet { refreshIcon() } }
    var iconSize = 24.em

    var data: (title: String, checked: Bool) = (title: "", checked: false) {
      didSet {
        label.text(data.title)
        checked = data.checked
      }
    }

    override func layoutUI() {
      super.layoutUI()
      layout([label, icon])
    }

    override func styleUI() {
      super.styleUI()
      label.styled()
      backgroundColored(UIColor.whiteColor())
    }

    func refreshIcon() {
      if checked {
        icon.image = getIcon(.Check, options: ["color": K.Color.buttonBg])
      } else {
        icon.image = UIImage()
      }
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      label.anchorAndFillEdge(.Left, xPad: 20, yPad: 0, otherSize: label.textWidth())
      icon.anchorToEdge(.Right, padding: 10, width: iconSize, height: iconSize)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

}
