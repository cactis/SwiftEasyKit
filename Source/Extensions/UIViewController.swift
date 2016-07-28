//
//  UIViewController.swift
//
//  Created by ctslin on 5/18/16.
//

import Foundation
import MapKit
import LoremIpsum
import FontAwesome_swift
import Neon
import RandomKit
import SwiftRandom


extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func goBackViewController() {
    navigationController?.popViewControllerAnimated(true)
  }

  func titled(title: String) -> UIViewController {
    navigationItem.title = title
    return self
  }

//  func appDelegate() -> AppDelegate {
//    return UIApplication.sharedApplication().delegate as! AppDelegate
//  }

  func openImagePicker(sourceType: UIImagePickerControllerSourceType = .Camera) -> UIImagePickerController {
    var type = sourceType
    if _isSimulator() { type = .PhotoLibrary }
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = type
    self.presentViewController(picker, animated: true, completion: nil)
    return picker
  }

  func embededInNavigationController() -> UINavigationController {
    return UINavigationController(rootViewController: self)
  }

  func flipViewController(vc: UIViewController, run: () -> () = {}) {
    openViewController(vc, style: .FlipHorizontal, run: run)
  }
//
//  func getViewControllersFromTabBar() -> [UIViewController] {
//    return appDelegate().tabBarViewController.viewControllers!
//  }

  func openViewController(vc: UIViewController, style: UIModalTransitionStyle = .CoverVertical, run: ()->() = {}) {
    openControllerWithDelegate(self, vc: vc, style: style, run: run)
  }

  func pushViewController(vc: UIViewController, onComplete: () -> () = {}) -> Void {
    navigationController?.pushViewController(vc, animated: true)
    //    delayedJob {
    onComplete()
    //    }
  }

  func setFieldsGroup(fields: [UITextField]) -> Void {
    let delegate = self as! UITextFieldDelegate
    if fields.count > 1 {
      for index in 0...fields.count - 2 {
        fields[index].delegate = delegate
        fields[index].nextField = fields[index + 1]
      }
    }
    fields.last?.delegate = delegate
  }

  func setViewsGroup(fields: [UITextView]) -> Void {
    let delegate = self as! UITextViewDelegate
    for index in 0...fields.count - 2 {
      fields[index].delegate = delegate
      fields[index].nextField = fields[index + 1]
    }
    fields.last?.delegate = delegate
  }


  func navBarHeight() -> CGFloat {
    return (navigationController?.navigationBar.height)!
  }

  func tabBarHeight() -> CGFloat {

    if let tabbar = tabBarController {
      if tabbar.tabBar.hidden == true {
        return 0
      } else {
        return tabbar.tabBar.height
      }
    } else {
      return 0
    }
  }

  func _colored(views: [UIView]) {
    for index in 0...views.count - 1 {
      views[index]._coloredWithIndex(index)
    }
  }

  func viewNetHeight() -> CGFloat {
    var barHeight: CGFloat = 0
    if UIApplication.sharedApplication().statusBarFrame != CGRectZero {
      barHeight = UIApplication.sharedApplication().statusBarFrame.height
    }
    return view.height() - barHeight// - 44 //(navigationController?.navigationBar.height)!
  }

  func addLeftBarButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    var items: [UIBarButtonItem] = [UIBarButtonItem]()
    if let _item = self.navigationItem.leftBarButtonItem {
      item.imageInsets = UIEdgeInsetsMake(0, -25, 0, 0)
      items = [_item, item]
    } else {
      items = [item]
    }
    self.navigationItem.leftBarButtonItems = items
    return item
  }

  func setRightBarButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    self.navigationItem.rightBarButtonItems = [item]
    return item
  }

  @nonobjc
  func setRightBarButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(title, action: action)
    self.navigationItem.rightBarButtonItems = [item]
    return item
  }

  func setLeftBarButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    item.customView?.layoutSubviews()
    self.navigationItem.leftBarButtonItems = [item]
    return item
  }

  func addRightBarButtonItemWithBadge(image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItemWithBadge(image, action: action)
    var items: [UIBarButtonItem] = [UIBarButtonItem]()
    if let _item = self.navigationItem.rightBarButtonItem {
      _logForUIMode(1)
      item.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25)
      items = [_item, item]
    } else {
      _logForUIMode(2)
      items = [item]
    }
    item.customView?._coloredWithSuperviews()
    (item.customView as? IconLabelButton)!.icon._coloredWithSuperviews()
    self.navigationItem.rightBarButtonItems = items
    return item
  }

  func disabledNavShadow() {
    let navbar = navigationController?.navigationBar
    navbar?.setBackgroundImage(UIImage().makeImageWithColorAndSize(K.Color.navigator), forBarPosition: .Any, barMetrics: .Default)
    navbar?.shadowImage = UIImage()
  }

  func newBarButtonItemWithBadge(image: UIImage, action: Selector) -> UIBarButtonItem {
    let button = IconLabelButton(image: image, text: "111")
    let item = UIBarButtonItem(title: nil, style: .Plain, target: self, action: action)
    //    let item = UIBarButtonItem(customView: button)
    _logForUIMode(0)
    item.customView = button
    return item
  }

  func addRightBarButtonItem(iconCode iconCode: String, action: Selector, withOffset: Bool = true) -> UIBarButtonItem {
    let item = newBarButtonItem(iconCode: iconCode, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }

  func addRightBarButtonItem(title: String, action: Selector, withOffset: Bool = true) -> UIBarButtonItem {
    let item = newBarButtonItem(title, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }

  @nonobjc
  func addRightBarButtonItem(image: UIImage, action: Selector, withOffset: Bool = true) -> ENMBadgedBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }

  func appendItemToBar(item: UIBarButtonItem, withOffset: Bool) {
    var items: [UIBarButtonItem] = [UIBarButtonItem]()
    if let _item = self.navigationItem.rightBarButtonItem {
      if withOffset { item.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25) } else { item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0) }
      items = [_item, item]
    } else {
      items = [item]
    }
    self.navigationItem.rightBarButtonItems = items
  }

  func newBarButtonItem(iconCode iconCode: String, action: Selector, color: UIColor = K.Color.barButtonItem) -> UIBarButtonItem {
    let item = newBarButtonItem(iconCode, action: action)
    let button = (item.customView as! UIButton)
    button.titleLabel!.font = UIFont(name: K.Font.icon, size: K.BarButtonItem.size)
//    button.frame = CGRect(x: 0, y: 0, width: K.BarButtonItem.size, height: K.BarButtonItem.size)
    button.frame = CGRect(x: 0, y: 0, width: button.textWidth(), height: button.textHeight() * 2)
//    button.sizeToFit()
    button.setTitleColor(color, forState: .Normal)
//    button._coloredWithSuperviews()
    return item
  }

  func newBarButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    let button = UIButton(type: .Custom)
    button.text(title).colored(K.BarButtonItem.color).sizeToFit()
    button.frame = CGRect(x: 0, y: 0, width: button.textWidth(), height: button.textHeight())
    button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
//    button._coloredWithSuperviews()
    let item = UIBarButtonItem(customView: button)
    return item
  }

  func newBarButtonItem(image: UIImage, action: Selector, count: Int = 0) -> ENMBadgedBarButtonItem {
    let button = UIButton(type: .Custom)
    button.frame = CGRect(x: 0, y: 0, width: K.BarButtonItem.size, height: K.BarButtonItem.size)
    ////    if let knownImage = image {
    ////      button.frame = CGRectMake(0.0, 0.0, knownImage.size.width, knownImage.size.height)
    ////    } else {
    ////      button.frame = CGRectZero;
    ////    }
    ////    button.setBackgroundImage(image, forState: UIControlState.Normal)
    button.imaged(image)
    button.addTarget(self,
                     action: action,
                     forControlEvents: .TouchUpInside)
    //
    let item = ENMBadgedBarButtonItem(customView: button, value: "\(count)")

    //    let item = UIBarButtonItem(title: nil, style: .Plain, target: self, action: action)
    item.image = image
    return item
  }

  func disableSwipeRightToBack(swipeRight: UISwipeGestureRecognizer) {
    self.view.removeGestureRecognizer(swipeRight)
  }

  func enableSwipeRightToBack(target: AnyObject) -> UISwipeGestureRecognizer {
    let swipeRight = UISwipeGestureRecognizer(target: target, action: #selector(UIViewController.respondToSwipeGesture(_:)))
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.view.addGestureRecognizer(swipeRight)
    return swipeRight
  }

  func respondToSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.Right:
        navigationController?.popViewControllerAnimated(true)
      //      case UISwipeGestureRecognizerDirection.Down:
      default:
        break
      }
    }
  }

  func hideBackBarButtonItem() {
    navigationItem.hidesBackButton = true
  }

  func hideBackBarButtonItemTitle() {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  }

  func enableCaptureSessionWithPreview(liveView: UIView, onComplete: () -> ()) -> AVCaptureStillImageOutput {
    let output = AVCaptureStillImageOutput()
    delayedJob(0.1) {
      do {
        var session: AVCaptureSession!
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let input = try AVCaptureDeviceInput(device: device)
        session.addInput(input)
        output.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        session.addOutput(output)
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravityResizeAspectFill
        preview.frame = liveView.bounds
        liveView.layer.addSublayer(preview)
        session.startRunning()
        onComplete()
      } catch {
        print(error)
      }
    }
    return output
  }

  func collectionView(layout: UICollectionViewFlowLayout, registeredClass: AnyClass!, identifier: String) -> UICollectionView {
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    layout.scrollDirection = .Horizontal
    layout.itemSize = CGSizeMake(100, 100)
    let padding: CGFloat = 10
    layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding)
    collectionView.delegate = self as? UICollectionViewDelegate
    collectionView.dataSource = self as? UICollectionViewDataSource
    collectionView.registerClass(registeredClass, forCellWithReuseIdentifier: identifier)
    return collectionView
  }

  func tableView(registeredClass: AnyClass!, identifier: String) -> UITableView {
    let tableView = UITableView(frame: view.bounds)
    tableView.delegate = self as? UITableViewDelegate
    tableView.dataSource = self as? UITableViewDataSource
    tableView.styled()
    tableView.registerClass(registeredClass, forCellReuseIdentifier: identifier)
    return tableView
  }
}

import AVFoundation
extension AVCaptureStillImageOutput {
  func getImage(onComplete: (image: UIImage) -> ()) {
    let conneciton = connectionWithMediaType(AVMediaTypeVideo)
    captureStillImageAsynchronouslyFromConnection(conneciton, completionHandler: { (buffer, error) in
      let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)
      let provider = CGDataProviderCreateWithCFData(data)
      let cgImageRef = CGImageCreateWithJPEGDataProvider(provider, nil, true,  CGColorRenderingIntent.RenderingIntentDefault)
      let image = UIImage(CGImage: cgImageRef!, scale: 1.0, orientation: .Right)
      onComplete(image: image)
    })
  }
}

