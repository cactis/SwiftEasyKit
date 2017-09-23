//
//  ScrollableViewController.swift


import UIKit

open class ScrollableViewController: DefaultViewController {

  var contentView = UIScrollView()

  init() {
//    _logForUIMode()
    super.init(nibName: nil, bundle: nil)
//    contentView._colored()
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

//    view.addSubview(contentView)
  }

  override open func layoutUI() {
    super.layoutUI()
    view.layout([contentView])
  }

  override open func styleUI() {
    super.styleUI()
  }

  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    contentView.fillSuperview()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
