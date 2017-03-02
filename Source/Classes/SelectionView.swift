//
//  SelectionView.swift
//
//  Created by ctslin on 3/23/16.

import Foundation

public class SelectionView: DefaultView, UITableViewDelegate, UITableViewDataSource {
  
  public var tableView: UITableView!
  public var collectionData = [String]()
  public var cell: SelectionCell!
  public var selected: (index: Int) -> () = {_ in }
  public var expended = false {
    didSet {
      if expended {
        self.superview!.bringSubviewToFront(self)
      }
    }
  }
  
  public var targetView: UIView!
  public var cellHeight: CGFloat = 30
  
  public init(items: [String], targetView: UIView) {
    self.collectionData = items
    self.targetView = targetView
    super.init(frame: CGRectZero)
  }
  
  override public func layoutUI() {
    super.layoutUI()
    tableView = tableView(SelectionCell.self, identifier: cellIdentifier)
    layout([tableView])
  }
  
  override public func styleUI() {
    super.styleUI()
    shadowed()
  }
  
  override public func bindUI() {
    super.bindUI()
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! SelectionCell
    cell.loadData(collectionData[indexPath.row])
    cell.layoutIfNeeded()
    return cell
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return collectionData.count
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return cellHeight
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    _logForUIMode()
  }
  
  public func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
    _logForUIMode()
    return indexPath
  }
  
  override public func layoutSubviews() {
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
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  public class SelectionCell: TableViewCell {
    public var label = UILabel()
    public var checked = UIImageView()
    
    public var checkedIcon = getIcon(.Check, options: ["color": K.Color.checked])
    
    public var isChecked: Bool = false {
      didSet {
        if isChecked {
          checked.image = checkedIcon
        } else {
          checked.image = nil
        }
      }
    }
    
    override public func layoutUI() {
      super.layoutUI()
      layout([checked, label])
      //        bottomView = label
    }
    
    override public func styleUI() {
      super.styleUI()
      label.styled()
      backgroundColor = UIColor.whiteColor()
    }
    
    override public func bindUI() {
      super.bindUI()
      whenTapped(self, action: #selector(SelectionCell.selfTapped))
    }
    
    public func selfTapped() {
      isChecked = !isChecked
      _logForUIMode(isChecked)
    }
    
    public func loadData(data: String) {
      label.text(data)
    }
    
    override public func layoutSubviews() {
      label.anchorAndFillEdge(.Left, xPad: 10, yPad: 5, otherSize: label.textWidth())
      //        checked.alignToTheRightOf(label, matchingTopWithLeftPadding: 10, width: K.barButtonItem.size, height: K.barButtonItem.size)
      checked.anchorToEdge(.Right, padding: 10, width: K.BarButtonItem.size, height: K.BarButtonItem.size)
    }
  }
  
}
