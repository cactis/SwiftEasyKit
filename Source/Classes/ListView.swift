//
//  ListView.swift

//  Created by ctslin on 3/6/16.


open class ListViewWithSeparator: ListView {

  private func enableSeparator() {
    labels.forEach { (label) in
      if label != labels.last! {
        label.bottomBordered()
      }
    }
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    enableSeparator()
  }
}

open class ListView: DefaultView {

  public var labels = [UILabel]()
  public var icons = [UIImageView]()

  public var list: [String]! {
    didSet {
      layoutUI()
    }
  }


  public init(list: [String] = []) {
    self.list = list
    super.init(frame: .zero)
  }

  override open func layoutUI() {
    super.layoutUI()
    labels = []
    self.removeSubviews()

    list.forEach { (text) -> () in
      labels.append(label(text))
    }
    layout(labels)
  }

  override open func styleUI() {
    super.styleUI()
    labels.forEach { (label) -> () in
      label.styled()
    }
  }

  override open func bindUI() {
    super.bindUI()
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    groupAndFill(group: .vertical, views: labels.map({$0 as UIView}), padding: 5)
  }


  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
