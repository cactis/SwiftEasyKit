//
//  DefaultViewController.swift

import UIKit

open class DefaultViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

  public var swipeRight: UISwipeGestureRecognizer!

  public var didFixedConstraints = false
  public var keyboardSize: CGSize! = .zero

  public var textViewShouldReturn = false

  public var tabBarHidden = false

  public var onDismissViewController: () -> () = { }// auto run
  public var didDismissViewController: (_ action: DismissType) -> () = { _ in } // call by target

  override open func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = navigationItem.title ?? K.App.name

    layoutUI() // 建立 UI 框架。結束時 loadData() 載入動態資料
    styleUI()  // 視覺化 UI 框架
    bindUI()   // 綁定 UI 事件
    bindData() // binding data
  }

  override open func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    onDismissViewController()
  }

  open func layoutUI() {
    view.setNeedsUpdateConstraints()
  }

  open func styleUI() {
    hideBackBarButtonItemTitle()
    view.backgroundColor = K.Color.body
    baseStyle()
    //    scrollView.contentSize = CGSize(width: view.width(), height: view.height() + (navigationController?.navigationBar.height)! + 40)

    //    tabBarController?.tabBar.isTranslucent = false
    //    automaticallyAdjustsScrollViewInsets = false
  }

  open func baseStyle() {
    let textAttributes = [NSAttributedStringKey.foregroundColor: K.Color.barButtonItem]
    //    UINavigationBar.appearance().titleTextAttributes = textAttributes

    navigationController?.navigationBar.titleTextAttributes = textAttributes
    navigationController?.navigationBar.barTintColor = K.Color.navigator
    navigationController?.navigationBar.tintColor = K.Color.barButtonItem
    navigationController?.navigationBar.isTranslucent = false
  }

  open func bindUI() {
    swipeRight = enableSwipeRightToBack(self)
    view.whenTapped(self, action: #selector(DefaultViewController.viewDidTapped))
    registerKeyboardNotifications()
  }

  open func bindData() { }

  open func enableSaveBarButtonItem(title: String = "") {
    if title != "" {
      setRightBarButtonItem(title: title, action: #selector(saveTapped))
    } else {
      setRightBarButtonItem(getIcon(.save, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(saveTapped))
    }
  }
  @objc open func saveTapped() { _logForAnyMode()}

  open func enableCloseBarButtonItem() {
    setRightBarButtonItem(
//      getIcon(.close, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem])
      getImage(iconCode: K.Icons.close, color: K.Color.barButtonItem, size: K.BarButtonItem.size)
      , action: #selector(closeTapped))
  }

  open func enableCloseBarButtonItemAtLeft() { setLeftBarButtonItem(
//    getIcon(.close, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem])
    getImage(iconCode: K.Icons.close, color: K.Color.barButtonItem, size: K.BarButtonItem.size)
  , action: #selector(closeTapped)) }

  @objc open func closeTapped() { dismiss(animated: true) { () -> Void in }}

  @objc open func viewDidTapped() { view.endEditing(true) }

  open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if let field = textField.nextField {
      field.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return true
  }

  open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    if !textViewShouldReturn && text == "\n" {
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

  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  open func fixConstraints() {
    self.updateViewConstraints()
    self.view.setNeedsUpdateConstraints()
  }

  override open func viewWillAppear(_ animated: Bool) {
    //    _logForUIMode()
    setTabBarStatus()
    _logForUIMode(K.Api.userToken, title: "K.Api.userToken")
  }

  open func setTabBarStatus() {
    self.tabBarController?.tabBar.isHidden = tabBarHidden
  }

  override open func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterKeyboardNotifications()
  }

  @objc open func keyboardDidShow(_ notification: NSNotification) {
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
    //    _logForUIMode(keyboardSize.height, title: "keyboardSize.height")

    //    let userInfo: NSDictionary = notification.userInfo!
    //    let keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
    //    let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
    //    contentView.contentInset = contentInsets
    //    contentView.scrollIndicatorInsets = contentInsets
  }

  @objc open func keyboardWillShow(_ notification: NSNotification) {
    //    _logForUIMode()
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
    //    _logForUIMode(keyboardSize.height, title: "keyboardSize.height")
  }


  @objc open func keyboardWillHide(_ notification: NSNotification) {
    //    _logForUIMode()
    keyboardSize = .zero
    //    contentView.contentInset = .zero
    //    contentView.scrollIndicatorInsets = .zero
  }

  //  func textFieldDidBeginEditing(textField: UITextField) {
  ////    var viewRect = view.frame
  ////    viewRect.size.height -= keyboardSize.height
  ////    if CGRectContainsPoint(viewRect, textField.frame.origin) {
  ////      let scrollPoint = CGPointMake(0, textField.frame.origin.y - keyboardSize.height)
  ////      contentView.setContentOffset(scrollPoint, animated: true)
  ////    }
  //  }


  open func registerKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(DefaultViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(DefaultViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    NotificationCenter.default.addObserver(self, selector: #selector(DefaultViewController.keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(DefaultViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
  }

  open func unregisterKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self)
  }

}
