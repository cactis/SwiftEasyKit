//
//  DefaultViewController.swift

import UIKit
//import FontAwesomeKit
//import FontAwesome_swift
//import CocoaLumberjack
//import LoremIpsum
//import RandomKit
//import SwiftRandom
//import Neon
//import Log
//import OdyiOS

public class DefaultViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

  var swipeRight: UISwipeGestureRecognizer!

  var didFixedConstraints = false
  var keyboardSize: CGSize! = CGSizeZero

  var tabBarHidden = false

  override public func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = navigationItem.title ?? K.App.name

    layoutUI() // 建立 UI 框架。結束時 loadData() 載入動態資料
    styleUI()  // 視覺化 UI 框架
    bindUI()   // 綁定 UI 事件

  }

  public func layoutUI() {
    view.setNeedsUpdateConstraints()
  }

  public func styleUI() {
    hideBackBarButtonItemTitle()
    view.backgroundColor = K.Color.body
    baseStyle()
    //    scrollView.contentSize = CGSize(width: view.width(), height: view.height() + (navigationController?.navigationBar.height)! + 40)

    //    tabBarController?.tabBar.translucent = false
    //    automaticallyAdjustsScrollViewInsets = false
  }

  public func baseStyle() {
    let textAttributes = [NSForegroundColorAttributeName: K.Color.barButtonItem]
//    UINavigationBar.appearance().titleTextAttributes = textAttributes

    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationController?.navigationBar.barTintColor = K.Color.navigator
    navigationController?.navigationBar.tintColor = K.Color.barButtonItem
    navigationController?.navigationBar.translucent = false
  }

  public func bindUI() {
    swipeRight = enableSwipeRightToBack(self)
    view.whenTapped(self, action: #selector(DefaultViewController.viewDidTapped))
    registerKeyboardNotifications()
  }

  public func enableSaveBarButtonItem() {
    setRightBarButtonItem(getIcon(.Save, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(saveTapped))
  }
  public func saveTapped() { _logForAnyMode()}
  public func enableCloseBarButtonItem() {
    setRightBarButtonItem(getIcon(.Close, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(closeTapped))
  }
  public func enableCloseBarButtonItemAtLeft() { setLeftBarButtonItem(getIcon(.Close, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(closeTapped)) }
  public func closeTapped() { dismissViewControllerAnimated(true) { () -> Void in }}
  public func viewDidTapped() { view.endEditing(true) }

  public func textFieldShouldReturn(textField: UITextField) -> Bool {
    if let field = textField.nextField {
      field.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return true
  }

  public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      if let field = textView.nextField {
        field.becomeFirstResponder()
      } else {
        textView.resignFirstResponder()
      }
      return false
    } else {
      return true
    }
  }

  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  public func fixConstraints() {
    self.updateViewConstraints()
    self.view.setNeedsUpdateConstraints()
  }

  override public func viewWillAppear(animated: Bool) {
//    _logForUIMode()
    setTabBarStatus()
  }

  public func setTabBarStatus() {
    self.tabBarController?.tabBar.hidden = tabBarHidden
  }

  override public func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterKeyboardNotifications()
  }

  public func keyboardDidShow(notification: NSNotification) {
    let userInfo: NSDictionary = notification.userInfo!
    keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
//    _logForUIMode(keyboardSize.height, title: "keyboardSize.height")

//    let userInfo: NSDictionary = notification.userInfo!
//    let keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
//    let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
//    contentView.contentInset = contentInsets
//    contentView.scrollIndicatorInsets = contentInsets
  }

  public func keyboardWillShow(notification: NSNotification) {
//    _logForUIMode()
   let userInfo: NSDictionary = notification.userInfo!
    keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
//    _logForUIMode(keyboardSize.height, title: "keyboardSize.height")
  }


  public func keyboardWillHide(notification: NSNotification) {
//    _logForUIMode()
    keyboardSize = CGSizeZero
//    contentView.contentInset = UIEdgeInsetsZero
//    contentView.scrollIndicatorInsets = UIEdgeInsetsZero
  }

//  func textFieldDidBeginEditing(textField: UITextField) {
////    var viewRect = view.frame
////    viewRect.size.height -= keyboardSize.height
////    if CGRectContainsPoint(viewRect, textField.frame.origin) {
////      let scrollPoint = CGPointMake(0, textField.frame.origin.y - keyboardSize.height)
////      contentView.setContentOffset(scrollPoint, animated: true)
////    }
//  }


  public func registerKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefaultViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefaultViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefaultViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefaultViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
  }

  public func unregisterKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

}
