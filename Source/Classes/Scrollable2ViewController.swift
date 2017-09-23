//
//  Scrollable2ViewController.swift

import UIKit

open class Scrollable2ViewController: DefaultViewController {

  public var contentView = UIScrollView()

  override open func viewDidLoad() {
    super.viewDidLoad()
  }

  override open func layoutUI() {
    super.layoutUI()
    contentView = view.addScrollView()
    view.layout([contentView])
  }

  override open func bindUI() {
    super.bindUI()
    //    registerKeyboardNotifications()
  }

  override open func updateViewConstraints() {
    super.updateViewConstraints()
    contentView.fillSuperview()
  }
  //
  //  override func viewWillDisappear(animated: Bool) {
  //    super.viewWillDisappear(animated)
  //    unregisterKeyboardNotifications()
  //  }
  //

  override open func keyboardDidShow(_ notification: NSNotification) {
    super.keyboardDidShow(notification)
    //    let userInfo: NSDictionary = notification.userInfo!
    //    let
    //    keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
    let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
    contentView.contentInset = contentInsets
    contentView.scrollIndicatorInsets = contentInsets
  }

  override open func keyboardWillHide(_ notification: NSNotification) {
    super.keyboardWillHide(notification)
    contentView.contentInset = .zero
    contentView.scrollIndicatorInsets = .zero
  }

  func textViewDidBeginEditing(textView: UITextView) {
    makeTargetVisible(textView.superview!)
  }

  private func makeTargetVisible(_ target: UIView) {
    //    var viewRect = view.frame
    //    viewRect.size.height -= keyboardSize.height
    //    let y = target.frame.origin.y
    var y: CGFloat = 0
    if target.bottomEdge() > 200 { y = target.bottomEdge() - 100 }
    let scrollPoint = CGPoint(x: 0, y: y)
    contentView.setContentOffset(scrollPoint, animated: true)
  }

  func textFieldDidBeginEditing(textField: UITextField) {
    makeTargetVisible(textField.superview!)
  }
  //
  //
  //  func registerKeyboardNotifications() {
  //    NSNotificationCenter.default().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
  //    NSNotificationCenter.default().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  //  }
  //
  //  func unregisterKeyboardNotifications() {
  //    NSNotificationCenter.default().removeObserver(self)
  //  }
}
