//
//  ListView.swift

//  Created by ctslin on 3/6/16.


public class ListViewWithSeparator: ListView {

  private func enableSeparator() {
    labels.forEach { (label) in
      if label != labels.last! {
        label.bottomBordered()
      }
    }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    enableSeparator()
  }
}

public class ListView: DefaultView {

  public var labels = [UILabel]()
  public var icons = [UIImageView]()

  public var list: [String]! {
    didSet {
      layoutUI()
    }
  }


  public init(list: [String] = []) {
    self.list = list
    super.init(frame: CGRectZero)
  }

  override public func layoutUI() {
    super.layoutUI()
    labels = []
    self.removeSubviews()

    list.forEach { (text) -> () in
      labels.append(label(text))
    }
    layout(labels)
  }

  override public func styleUI() {
    super.styleUI()
    labels.forEach { (label) -> () in
      label.styled()
    }
  }

  override public func bindUI() {
    super.bindUI()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    groupAndFill(group: .Vertical, views: labels.map({$0 as UIView}), padding: 5)
  }


  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
