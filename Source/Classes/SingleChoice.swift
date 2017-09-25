//
//  SingleChoice.swift
//
//  Created by ctslin on 4/8/16.

import UIKit

open class MultipleChoiceTable: ChoiceTable {

  public var value: [Int] = [] {
    didSet { refreshData() }
  }

  public var didChange: (_ value: [Int]) -> () = { _ in}

  public init(items: [String], value: [Int]) {
    super.init(frame: .zero)
    self.items = items
    self.value = value
    refreshData()
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

  public func refreshData() {
    collectionData = []
    (0...items.count - 1).forEach { (index) in
      collectionData.append((title: items[index], checked: value.index(of: index) != nil))
    }
    tableView.reloadData()
  }

  override open func didSelect(_ indexPath: NSIndexPath?) {
    if let index = value.index(of: indexPath!.row) {
      value.remove(at: index)
    } else {
      value.append(indexPath!.row)
    }
    didChange(value)
  }
}


open class SingleChoiceTable: ChoiceTable {

  public var value: Int = -1 {
    didSet {
      refreshData()
    }
  }

  public var didChange: (_ value: Int) -> () = { _ in}

  public init(items: [String]) {
    super.init(frame: .zero)
    self.items = items
    refreshData()
  }

  public init(items: [String], value: Int) {
    super.init(frame: .zero)
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

  override open func didSelect(_ indexPath: NSIndexPath?) {
    value = indexPath!.row
    didChange(value)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

open class ChoiceTable: DefaultView, UITableViewDelegate, UITableViewDataSource {
  public var tableView: UITableView!
  public var CellIdentifier = "CELL"
  public var items: [String] = []
  public var collectionData: [(title: String, checked: Bool)] = []

  override open func layoutUI() {
    super.layoutUI()
    tableView = tableView(ChoiceCell.self, identifier: CellIdentifier)
    layout([tableView])
  }

  override open func styleUI() {
    super.styleUI()
    tableView.separatorStyle = .singleLine
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as!  ChoiceCell
    cell.data = collectionData[indexPath.row]
    cell.whenTapped(self, action: #selector(cellTapped))
    return cell
  }

  @objc public func cellTapped(_ sender: UIGestureRecognizer) {
//    didSelect(sender.indexPathInTableView(tableView))
  }

  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }

  @nonobjc public func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cellHeight()
  }

  public func didSelect(_ indexPath: NSIndexPath?) { }

  public func cellHeight() -> CGFloat {
    return K.Size.Text.normal * 3
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    tableView.fillSuperview()
  }

  open class ChoiceCell: TableViewCell {
    public var label = UILabel()
    public var icon = UIImageView()
    public var checked: Bool = false { didSet { refreshIcon() } }
    public var iconSize = 24.em

    public var data: (title: String, checked: Bool) = (title: "", checked: false) {
      didSet {
        label.texted(data.title)
        checked = data.checked
      }
    }

    override open func layoutUI() {
      super.layoutUI()
      layout([label, icon])
    }

    override open func styleUI() {
      super.styleUI()
      label.styled()
      backgroundColored(UIColor.white)
    }

    public func refreshIcon() {
      if checked {
        icon.image = getIcon(.check, options: ["color": K.Color.buttonBg])
      } else {
        icon.image = UIImage()
      }
    }

    override open func layoutSubviews() {
      super.layoutSubviews()
      label.anchorAndFillEdge(.left, xPad: 20, yPad: 0, otherSize: label.textWidth())
      icon.anchorToEdge(.right, padding: 10, width: iconSize, height: iconSize)
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

}
