//
//  PopupView.swift

import UIKit

public class PopupViewController: UIViewController {

  public var maskView: UIView!
  public var contentView: UIView!

  override public func viewDidLoad() {
    super.viewDidLoad()

    maskView = view.addView()

    view.addSubview(contentView)
    maskView.whenTapped(self, action: #selector(PopupViewController.closeTapped)).blured(view)
  }

  func closeTapped() {
    self.dismissViewControllerAnimated(true) { () -> Void in
    }
  }

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    maskView.fillSuperview()
  }

}
