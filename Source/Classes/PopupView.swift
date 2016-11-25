//
//  PopupView.swift

import UIKit

public class PopupView: DefaultView {

  public var delegate: UIView!
  
  public var wrapper: UIView!
  public var closeBtn: UIImageView!

  public var padding: CGFloat = 40
  public var closeBtnSize: CGFloat = 25

  override public init(frame: CGRect) {
    super.init(frame: frame)

    closeBtn = addImageView(UIImage.fontAwesomeIconWithName(.Close, textColor: K.Color.barButtonItem, size: CGSizeMake(closeBtnSize, closeBtnSize)))
    closeBtn.whenTapped(self, action: #selector(PopupView.closeBtnTapped(_:)))

    wrapper = addView()
    backgroundColor = K.Color.popup
  }

  public func closeBtnTapped(sender: AnyObject?) {
    parentViewController()!.dismissViewControllerAnimated(true) { () -> Void in }
  }

  public func closeBtnTapped(disDidmiss didDismiss: () -> () = {}) {
    parentViewController()!.dismissViewControllerAnimated(true) { 
      didDismiss()
    }
  }


  public func layoutBase() {
    anchorInCenter(width: UIScreen.mainScreen().bounds.width / 5 * 4, height: UIScreen.mainScreen().bounds.height / 2)
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    layoutBase()
    fixedConstraints()
    wrapper.fillSuperview(left: padding, right: padding, top: padding, bottom: padding)
  }

  public func fixedConstraints() {
    closeBtn.anchorTopRightWithRightPadding(10, topPadding: 10, width: closeBtnSize , height: closeBtnSize)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}
