//
//  SingleChoice.swift
//
//  Created by ctslin on 4/8/16.

import UIKit

public class MultipleChoiceTable: ChoiceTable {

  public var value: [Int] = [] {
    didSet { refreshData() }
  }

  public var didChange: (value: [Int]) -> () = { _ in}

  public init(items: [String], value: [Int]) {
    super.init(frame: CGRectZero)
    self.items = items
    self.value = value
    refreshData()
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  public func refreshData() {
    collectionData = []
    (0...items.count - 1).forEach { (index) in
      collectionData.append((title: items[index], checked: value.indexOf(index) != nil))
    }
    tableView.reloadData()
  }

  override public func didSelect(indexPath: NSIndexPath?) {
    if let index = value.indexOf(indexPath!.row) {
      value.removeAtIndex(index)
    } else {
      value.append(indexPath!.row)
    }
    didChange(value: value)
  }
}


public class SingleChoiceTable: ChoiceTable {

  public var value: Int = -1 {
    didSet {
      refreshData()
    }
  }

  public var didChange: (value: Int) -> () = { _ in}

  public init(items: [String]) {
    super.init(frame: CGRectZero)
    self.items = items
    refreshData()
  }

  public init(items: [String], value: Int) {
    super.init(frame: CGRectZero)
    self.items = items
    self.value = value
    refreshData()
  }

  public func refreshData() {
    collectionData = []
    (0...items.count - 1).forEach { (index) in
      collectionData.append((title: items[index], checked: index == value))
    }
    tableView.reloadData()
  }

  override public func didSelect(indexPath: NSIndexPath?) {
    value = indexPath!.row
    didChange(value: value)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

public class ChoiceTable: DefaultView, UITableViewDelegate, UITableViewDataSource {
  public var tableView: UITableView!
  public var CellIdentifier = "CELL"
  public var items: [String] = []
  public var collectionData: [(title: String, checked: Bool)] = []

  override public func layoutUI() {
    super.layoutUI()
    tableView = tableView(ChoiceCell.self, identifier: CellIdentifier)
    layout([tableView])
  }

  override public func styleUI() {
    super.styleUI()
    tableView.separatorStyle = .SingleLine
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as! ChoiceCell
    cell.data = collectionData[indexPath.row]
    cell.whenTapped(self, action: #selector(cellTapped))
    return cell
  }

  public func cellTapped(sender: UIGestureRecognizer) {
    didSelect(sender.indexPathInTableView(tableView))
  }

  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }

  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cellHeight()
  }

  public func didSelect(indexPath: NSIndexPath?) { }

  public func cellHeight() -> CGFloat {
    return K.Size.Text.normal * 3
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    tableView.fillSuperview()
  }

  public class ChoiceCell: TableViewCell {
    public var label = UILabel()
    public var icon = UIImageView()
    public var checked: Bool = false { didSet { refreshIcon() } }
    public var iconSize = 24.em

    public var data: (title: String, checked: Bool) = (title: "", checked: false) {
      didSet {
        label.text(data.title)
        checked = data.checked
      }
    }

    override public func layoutUI() {
      super.layoutUI()
      layout([label, icon])
    }

    override public func styleUI() {
      super.styleUI()
      label.styled()
      backgroundColored(UIColor.whiteColor())
    }

    public func refreshIcon() {
      if checked {
        icon.image = getIcon(.Check, options: ["color": K.Color.buttonBg])
      } else {
        icon.image = UIImage()
      }
    }

    override public func layoutSubviews() {
      super.layoutSubviews()
      label.anchorAndFillEdge(.Left, xPad: 20, yPad: 0, otherSize: label.textWidth())
      icon.anchorToEdge(.Right, padding: 10, width: iconSize, height: iconSize)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

}
