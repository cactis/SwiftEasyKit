//
//  ListView.swift

//  Created by ctslin on 3/6/16.


class ListViewWithSeparator: ListView {

  private func enableSeparator() {
    labels.forEach { (label) in
      if label != labels.last! {
        label.bottomBordered()
      }
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    enableSeparator()
  }
}

class ListView: DefaultView {

  var labels = [UILabel]()
  var icons = [UIImageView]()

  var list: [String]! {
    didSet {
      layoutUI()
    }
  }


  init(list: [String] = []) {
    self.list = list
    super.init(frame: CGRectZero)
  }

  override func layoutUI() {
    super.layoutUI()
    labels = []
    self.removeSubviews()

    list.forEach { (text) -> () in
      labels.append(label(text))
    }
    layout(labels)
  }

  override func styleUI() {
    super.styleUI()
    labels.forEach { (label) -> () in
      label.styled()
    }
  }

  override func bindUI() {
    super.bindUI()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    groupAndFill(group: .Vertical, views: labels.map({$0 as UIView}), padding: 5)
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
