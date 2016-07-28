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

class DefaultViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

  var swipeRight: UISwipeGestureRecognizer!

  var didFixedConstraints = false
  var keyboardSize: CGSize! = CGSizeZero

  var tabBarHidden = false

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = navigationItem.title ?? K.App.name

    layoutUI() // 建立 UI 框架。結束時 loadData() 載入動態資料
    styleUI()  // 視覺化 UI 框架
    bindUI()   // 綁定 UI 事件

  }

  func layoutUI() {
    view.setNeedsUpdateConstraints()
  }

  func styleUI() {
    hideBackBarButtonItemTitle()
    view.backgroundColor = K.Color.body
    baseStyle()
    //    scrollView.contentSize = CGSize(width: view.width(), height: view.height() + (navigationController?.navigationBar.height)! + 40)

    //    tabBarController?.tabBar.translucent = false
    //    automaticallyAdjustsScrollViewInsets = false
  }

  func baseStyle() {
    let textAttributes = [NSForegroundColorAttributeName: K.Color.barButtonItem]
//    UINavigationBar.appearance().titleTextAttributes = textAttributes

    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationController?.navigationBar.barTintColor = K.Color.navigator
    navigationController?.navigationBar.tintColor = K.Color.barButtonItem
    navigationController?.navigationBar.translucent = false
  }

  func bindUI() {
    swipeRight = enableSwipeRightToBack(self)
    view.whenTapped(self, action: #selector(DefaultViewController.viewDidTapped))
    registerKeyboardNotifications()
  }

  func enableSaveBarButtonItem() {
    setRightBarButtonItem(getIcon(.Save, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(saveTapped))
  }
  func saveTapped() { _logForAnyMode()}
  func enableCloseBarButtonItem() {
    setRightBarButtonItem(getIcon(.Close, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(closeTapped))
  }
  func enableCloseBarButtonItemAtLeft() { setLeftBarButtonItem(getIcon(.Close, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(closeTapped)) }
  func closeTapped() { dismissViewControllerAnimated(true) { () -> Void in }}
  func viewDidTapped() { view.endEditing(true) }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if let field = textField.nextField {
      field.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return true
  }

  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
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

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  func fixConstraints() {
    self.updateViewConstraints()
    self.view.setNeedsUpdateConstraints()
  }

  override func viewWillAppear(animated: Bool) {
//    _logForUIMode()
    setTabBarStatus()
  }

  func setTabBarStatus() {
    self.tabBarController?.tabBar.hidden = tabBarHidden
  }

  override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterKeyboardNotifications()
  }

  func keyboardDidShow(notification: NSNotification) {
    let userInfo: NSDictionary = notification.userInfo!
    keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
//    _logForUIMode(keyboardSize.height, title: "keyboardSize.height")

//    let userInfo: NSDictionary = notification.userInfo!
//    let keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
//    let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
//    contentView.contentInset = contentInsets
//    contentView.scrollIndicatorInsets = contentInsets
  }

  func keyboardWillShow(notification: NSNotification) {
//    _logForUIMode()
   let userInfo: NSDictionary = notification.userInfo!
    keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
//    _logForUIMode(keyboardSize.height, title: "keyboardSize.height")
  }


  func keyboardWillHide(notification: NSNotification) {
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


  func registerKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefaultViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefaultViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)

    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefaultViewController.keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(DefaultViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
  }

  func unregisterKeyboardNotifications() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }

}
