//
//  ScrollableViewController.swift


import UIKit

public class ScrollableViewController: DefaultViewController {

  var contentView = UIScrollView()

  init() {
//    _logForUIMode()
    super.init(nibName: nil, bundle: nil)
//    contentView._colored()
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

//    view.addSubview(contentView)
  }

  override public func layoutUI() {
    super.layoutUI()
    view.layout([contentView])
  }

  override public func styleUI() {
    super.styleUI()
  }

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    contentView.fillSuperview()
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
