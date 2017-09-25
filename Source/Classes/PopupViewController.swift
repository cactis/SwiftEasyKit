//
//  PopupView.swift

import UIKit

open class PopupViewController: UIViewController {

  public var autoDismiss: Bool = false
  public var maskView: UIView!
  public var contentView: UIView!

  override open func viewDidLoad() {
    super.viewDidLoad()

    maskView = view.addView()
    view.addSubview(contentView)
    maskView.blured(view)

    if autoDismiss {
      maskView.whenTapped(self, action: #selector(closeTapped))
    }
  }

  @objc func closeTapped() {
    self.dismiss(animated: true) { () -> Void in
    }
  }

  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    maskView.fillSuperview()
  }

}
