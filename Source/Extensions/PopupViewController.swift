//
//  PopupView.swift

import UIKit

class PopupViewController: UIViewController {

  var maskView: UIView!
  var contentView: UIView!

  override func viewDidLoad() {
    super.viewDidLoad()

    maskView = view.addView()

    view.addSubview(contentView)
    maskView.whenTapped(self, action: #selector(PopupViewController.closeTapped)).blured(view)
  }

  func closeTapped() {
    self.dismissViewControllerAnimated(true) { () -> Void in
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    maskView.fillSuperview()
  }

}
