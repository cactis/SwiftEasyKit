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

open class LabelText: DefaultView {
  public var label = UILabel()
  public var text = UILabel()
  var labelWidth: CGFloat = 0 { didSet { layoutSubviews() }}

  public init(_ label: String, labelWidth: CGFloat = 100) {
    super.init(frame: .zero)
    self.label.texted(label)
    ({self.labelWidth = labelWidth})()
  }

  @discardableResult public func texted(_ text: String) -> LabelText {
    self.text.texted(text)
    return self
  }

  @discardableResult public func texted(_ text: Int) -> LabelText {
    self.text.texted(text.string)
    return self
  }

  public func setSameLabelWidth(_ items: [LabelText]) {
    items.forEach({ $0.labelWidth = labelWidth })
  }

  override open func layoutUI() {
    super.layoutUI()
    layout([label, text])
  }

  override open func styleUI() {
    super.styleUI()
    label.styled()
    text.styled().darker().aligned()
  }

  open override func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: labelWidth)
    text.align(toTheRightOf: label, fillingWidthWithLeftAndRightPadding: 0, topPadding: 0, height: label.height())
  }
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
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
