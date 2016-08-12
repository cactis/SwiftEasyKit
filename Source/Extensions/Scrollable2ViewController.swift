//
//  Scrollable2ViewController.swift

import UIKit

public class Scrollable2ViewController: DefaultViewController {

  public var contentView = UIScrollView()

  override public func viewDidLoad() {
    super.viewDidLoad()
  }

  override public func layoutUI() {
    super.layoutUI()
    contentView = view.addScrollView()
    view.layout([contentView])
  }

  override public func bindUI() {
    super.bindUI()
    //    registerKeyboardNotifications()
  }

  override public func updateViewConstraints() {
    super.updateViewConstraints()
    contentView.fillSuperview()
  }
  //
  //  override func viewWillDisappear(animated: Bool) {
  //    super.viewWillDisappear(animated)
  //    unregisterKeyboardNotifications()
  //  }
  //

  override public func keyboardDidShow(notification: NSNotification) {
    super.keyboardDidShow(notification)
    //    let userInfo: NSDictionary = notification.userInfo!
    //    let
    //    keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
    let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
    contentView.contentInset = contentInsets
    contentView.scrollIndicatorInsets = contentInsets
  }

  override public func keyboardWillHide(notification: NSNotification) {
    super.keyboardWillHide(notification)
    contentView.contentInset = UIEdgeInsetsZero
    contentView.scrollIndicatorInsets = UIEdgeInsetsZero
  }

  func textViewDidBeginEditing(textView: UITextView) {
    makeTargetVisible(textView.superview!)
  }

  private func makeTargetVisible(target: UIView) {
    //    var viewRect = view.frame
    //    viewRect.size.height -= keyboardSize.height
    //    let y = target.frame.origin.y
    var y: CGFloat = 0
    if target.bottomEdge() > 200 { y = target.bottomEdge() - 100 }
    let scrollPoint = CGPointMake(0, y)
    contentView.setContentOffset(scrollPoint, animated: true)
  }

  func textFieldDidBeginEditing(textField: UITextField) {
    makeTargetVisible(textField.superview!)
  }
  //
  //
  //  func registerKeyboardNotifications() {
  //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
  //    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
  //  }
  //
  //  func unregisterKeyboardNotifications() {
  //    NSNotificationCenter.defaultCenter().removeObserver(self)
  //  }
}
