//
//  PopupView.swift

import UIKit

open class PopupView: DefaultView {

  public var delegate: UIView!

  public var contentView = UIScrollView()
  public var closeBtn: UIImageView!

  public var padding: CGFloat = 10
  public var closeBtnSize: CGFloat = 25
  public var radius: CGFloat = 6

  public var didDismiss: (_ popupView: PopupView) -> () = {_ in }
  public var didSuccess: (_ popupView: PopupView) -> () = {_ in }
  override public init(frame: CGRect) {
    super.init(frame: frame)
    layout([contentView])
    closeBtn = contentView.addImageView(UIImage.fontAwesomeIcon(name: .close, textColor: K.Color.buttonBg, size: CGSize(width: closeBtnSize, height: closeBtnSize)))
    closeBtn.whenTapped(self, action: #selector(closeBtnTapped(_:)))
  }

  public init(didDismiss: @escaping (_ popupView: PopupView) -> () = {_ in }) {
    super.init(frame: .zero)
    self.didDismiss = didDismiss
  }

  @objc open func closeBtnTapped(_ sender: AnyObject?) {
    parentViewController()!.dismiss(animated: true) { () -> Void in
      self.didDismiss(self)
    }
  }

  @objc open func closeBtnTapped(didDismiss: @escaping () -> () = {}) {
    parentViewController()!.dismiss(animated: true) {
      didDismiss()
    }
  }

  override open func styleUI() {
    super.styleUI()
    radiused(radius)
    backgroundColor = K.Color.popup
  }

  override open func bindUI() {
    super.bindUI()
    contentView.whenTapped(self, action: #selector(contentViewTapped))
  }

  @objc open func contentViewTapped() {
    contentView.endEditing(true)
  }

  open func layoutBase() {
    anchorInCenter(withWidth: UIScreen.main.bounds.width / 5 * 4, height: UIScreen.main.bounds.height / 2)
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    layoutBase()
    fixedConstraints()
    contentView.fillSuperview(left: padding, right: padding, top: padding, bottom: padding)
  }

  open func fixedConstraints() {
    closeBtn.anchorTopRight(withRightPadding: 10, topPadding: 10, width: closeBtnSize , height: closeBtnSize)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
