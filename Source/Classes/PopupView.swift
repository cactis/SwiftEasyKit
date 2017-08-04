//
//  PopupView.swift

import UIKit

public class PopupView: DefaultView {

  public var delegate: UIView!
  
  public var contentView = UIScrollView()
  public var closeBtn: UIImageView!

  public var padding: CGFloat = 40
  public var closeBtnSize: CGFloat = 25
  public var radius: CGFloat = 10

  public var didDismiss: (popupView: PopupView) -> () = {_ in }
  override public init(frame: CGRect) {
    super.init(frame: frame)

    closeBtn = addImageView(UIImage.fontAwesomeIconWithName(.Close, textColor: K.Color.barButtonItem, size: CGSizeMake(closeBtnSize, closeBtnSize)))
    closeBtn.whenTapped(self, action: #selector(PopupView.closeBtnTapped(_:)))

//    contentView = addView()
    layout([contentView])
    contentView.whenTapped(self, action: #selector(contentViewTapped))
    backgroundColor = K.Color.popup
  }
  
  public init(didDismiss: (popupView: PopupView) -> () = {_ in }) {
    super.init(frame: CGRectZero)
    self.didDismiss = didDismiss
  }

  public func closeBtnTapped(sender: AnyObject?) {
    parentViewController()!.dismissViewControllerAnimated(true) { () -> Void in
      self.didDismiss(popupView: self)
    }
  }

  public func closeBtnTapped(disDidmiss didDismiss: () -> () = {}) {
    parentViewController()!.dismissViewControllerAnimated(true) { 
      didDismiss()
    }
  }
  
  public override func styleUI() {
    super.styleUI()
    radiused(radius)
  }

  public func layoutBase() {
    anchorInCenter(width: UIScreen.mainScreen().bounds.width / 5 * 4, height: UIScreen.mainScreen().bounds.height / 2)
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    layoutBase()
    fixedConstraints()
    contentView.fillSuperview(left: padding, right: padding, top: padding, bottom: padding)
  }
  
  public func contentViewTapped() {
    contentView.endEditing(true)
  }

  public func fixedConstraints() {
    closeBtn.anchorTopRightWithRightPadding(10, topPadding: 10, width: closeBtnSize , height: closeBtnSize)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
