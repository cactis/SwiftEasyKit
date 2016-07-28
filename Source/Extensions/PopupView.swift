//
//  PopupView.swift

import UIKit

class PopupView: DefaultView {

  var wrapper: UIView!
  var closeBtn: UIImageView!

  var padding: CGFloat = 40
  var closeBtnSize: CGFloat = 25

  override init(frame: CGRect) {
    super.init(frame: frame)

    closeBtn = addImageView(UIImage.fontAwesomeIconWithName(.Close, textColor: K.Color.barButtonItem, size: CGSizeMake(closeBtnSize, closeBtnSize)))
    closeBtn.whenTapped(self, action: #selector(PopupView.closeBtnTapped(_:)))

    wrapper = addView()
    backgroundColor = K.Color.popup
  }

  func closeBtnTapped(sender: AnyObject?) {

    parentViewController()!.dismissViewControllerAnimated(true) { () -> Void in
      
    }
  }

  func layoutBase() {
    anchorInCenter(width: UIScreen.mainScreen().bounds.width / 5 * 4, height: UIScreen.mainScreen().bounds.height / 2)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    layoutBase()
    fixedConstraints()
    wrapper.fillSuperview(left: padding, right: padding, top: padding, bottom: padding)
  }

  func fixedConstraints() {
    closeBtn.anchorTopRightWithRightPadding(10, topPadding: 10, width: closeBtnSize , height: closeBtnSize)
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
}
