//
//  PopupView.swift

import UIKit

open class PopupViewController: DefaultViewController { //UIViewController {

  public var easyDismiss: Bool = false
  public var maskView: UIView!
  public var contentView: UIView!

  override open func viewDidLoad() {
    super.viewDidLoad()

    maskView = view.addView()
    view.addSubview(contentView)
    maskView.blured(view)

    if easyDismiss {
      maskView.whenTapped(self, action: #selector(closeTapped))
    }
  }

  @objc override open func closeTapped() {
    self.dismiss(animated: true) { () -> Void in
    }
  }

  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    maskView.fillSuperview()
  }

}
