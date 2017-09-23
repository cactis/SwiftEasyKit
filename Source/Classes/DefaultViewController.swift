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
    let textAttributes = [NSForegroundColorAttributeName: K.Color.barButtonItem]
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

  open func bindData() {

  }

  open func enableSaveBarButtonItem(title: String = "") {
    if title != "" {
      setRightBarButtonItem(title, action: #selector(saveTapped))
    } else {
      setRightBarButtonItem(getIcon(.save, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(saveTapped))
    }
  }
  open func saveTapped() { _logForAnyMode()}
  open func enableCloseBarButtonItem() {
    setRightBarButtonItem(getIcon(.close, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(closeTapped))
  }
  open func enableCloseBarButtonItemAtLeft() { setLeftBarButtonItem(getIcon(.close, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem]), action: #selector(closeTapped)) }
  open func closeTapped() { dismiss(animated: true) { () -> Void in }}
  open func viewDidTapped() { view.endEditing(true) }

  open func textFieldShouldReturn(textField: UITextField) -> Bool {
    if let field = textField.nextField {
      field.becomeFirstResponder()
    } else {
      view.endEditing(true)
    }
    return true
  }

  open func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
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
  }

  open func setTabBarStatus() {
    self.tabBarController?.tabBar.isHidden = tabBarHidden
  }

  override open func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unregisterKeyboardNotifications()
  }

  open func keyboardDidShow(_ notification: NSNotification) {
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
    //    _logForUIMode(keyboardSize.height, title: "keyboardSize.height")

    //    let userInfo: NSDictionary = notification.userInfo!
    //    let keyboardSize = userInfo.objectForKey(UIKeyboardFrameBeginUserInfoKey)!.CGRectValue.size
    //    let contentInsets = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0)
    //    contentView.contentInset = contentInsets
    //    contentView.scrollIndicatorInsets = contentInsets
  }

  open func keyboardWillShow(_ notification: NSNotification) {
    //    _logForUIMode()
    let userInfo: NSDictionary = notification.userInfo! as NSDictionary
    keyboardSize = (userInfo.object(forKey: UIKeyboardFrameBeginUserInfoKey)! as AnyObject).cgRectValue.size
    //    _logForUIMode(keyboardSize.height, title: "keyboardSize.height")
  }


  open func keyboardWillHide(_ notification: NSNotification) {
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
