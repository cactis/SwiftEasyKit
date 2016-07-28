//
//  ScrollableViewController.swift


import UIKit

class ScrollableViewController: DefaultViewController {

  var contentView = UIScrollView()

  init() {
//    _logForUIMode()
    super.init(nibName: nil, bundle: nil)
//    contentView._colored()
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

//    view.addSubview(contentView)
  }

  override func layoutUI() {
    super.layoutUI()
    view.layout([contentView])
  }

  override func styleUI() {
    super.styleUI()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    contentView.fillSuperview()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
