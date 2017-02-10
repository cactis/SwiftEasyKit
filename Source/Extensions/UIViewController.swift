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
  
  public func enableTabBarController(viewControllers: [UIViewController]!, titles: [String]!, images: [UIImage], selectedImages: [UIImage] = []) -> UITabBarController! {
    var _selectedImages = [UIImage]()
    if selectedImages.count > 0 {
      _selectedImages = selectedImages
    } else {
      _selectedImages = images
    }
    let tabBarViewController = UITabBarController()
    let vcs = viewControllers.map({ $0.embededInNavigationController() })
    for (index, vc) in vcs.enumerate() {
      vc.tabBarItem = UITabBarItem(title: titles[index], image: images[index], selectedImage: _selectedImages[index])
      viewControllers[index].titled(titles[index])
    }
    tabBarViewController.viewControllers = vcs
    return tabBarViewController
  }
  
  public func _enableDebugInfo(fileName: String = (#file as NSString).lastPathComponent) {
    _logForUIMode()
    if _isSimulator() {
      _logForUIMode()
      let _fileName = Label()
      view.layout([_fileName])
      _fileName.text(fileName).smaller(2)
      view.bringSubviewToFront(_fileName)
      _fileName.anchorInCorner(.BottomRight, xPad: 0, yPad: 0, width: _fileName.textWidth(), height: _fileName.textHeight())
    }
  }
  
  public func goBackToRootViewController(delayed delayed: Double = 0, onComplete: () -> () = {}) {
    delayedJob(delayed) {
      self.navigationController?.popToRootViewControllerAnimated(true)
      onComplete()
    }
  }
  
  public func goBackViewController(delayed delayed: Double = 0, onComplete: () -> () = {}) {
    delayedJob(delayed) {
      self.navigationController?.popViewControllerAnimated(true)
      onComplete()
    }
  }
  
  public func titled(title: String, token: String = #file) -> UIViewController {
    navigationItem.title = _isSimulator() ? "[\(token.split("/").last!.split(".").first!)]-\(title)" : title
    return self
  }
  
  public func openImagePicker(sourceType: UIImagePickerControllerSourceType = .Camera) -> UIImagePickerController {
    var type = sourceType
    if _isSimulator() { type = .PhotoLibrary }
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = type
    self.presentViewController(picker, animated: true, completion: nil)
    return picker
  }
  
  public func embededInNavigationController() -> UINavigationController {
    return UINavigationController(rootViewController: self)
  }
  
  public func flipViewController(vc: UIViewController, run: () -> () = {}) {
    openViewController(vc, style: .FlipHorizontal, run: run)
  }
  
  public func openViewController(vc: UIViewController, style: UIModalTransitionStyle = .CoverVertical, run: ()->() = {}) {
    openControllerWithDelegate(self, vc: vc, style: style, run: run)
  }
  
  public func pushViewController(vc: UIViewController, checked: Bool = true, delayed: Double = 0, onComplete: () -> () = {}, onDismissViewController: () -> () = {}, didDismissViewController: () -> () = {}) -> Void {
    (vc as? DefaultViewController)!.onDismissViewController = onDismissViewController
    (vc as? DefaultViewController)!.didDismissViewController = didDismissViewController
    delayedJob(delayed) {
      //      if checked && (self.navigationController?.topViewController?.isKindOfClass(vc.dynamicType))! {
      //        _logForUIMode("Not push again")
      //        return
      //      }
      self.navigationController?.pushViewController(vc, animated: true)
      onComplete()
    }
  }
  
  public func popToViewController(vc: UIViewController, delayed: Double = 0, onComplete: () -> () = {}) {
    delayedJob(delayed){
      self.navigationController?.popToViewController(vc, animated: true)
      onComplete()
    }
  }
  
  public func setFieldsGroup(fields: [UITextField]) -> Void {
    let delegate = self as! UITextFieldDelegate
    if fields.count > 1 {
      for index in 0...fields.count - 2 {
        fields[index].delegate = delegate
        fields[index].nextField = fields[index + 1]
      }
    }
    fields.last?.delegate = delegate
  }
  
  public func setViewsGroup(fields: [UITextView]) -> Void {
    //    let delegate = self as! UITextViewDelegate
    //    for index in 0...fields.count - 2 {
    //      fields[index].delegate = delegate
    //      fields[index].nextField = fields[index + 1]
    //    }
    //    fields.last?.delegate = delegate
    
    let delegate = self as! UITextViewDelegate
    if fields.count > 1 {
      for index in 0...fields.count - 2 {
        fields[index].delegate = delegate
        fields[index].nextField = fields[index + 1]
      }
    }
    fields.last?.delegate = delegate
    
  }
  
  public func navBarHeight() -> CGFloat {
    return (navigationController?.navigationBar.height)!
  }
  
  public func tabBarHeight() -> CGFloat {
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
  
  public func _colored(views: [UIView]) {
    for index in 0...views.count - 1 {
      views[index]._coloredWithIndex(index)
    }
  }
  
  public func viewNetHeight() -> CGFloat {
    var barHeight: CGFloat = 0
    if UIApplication.sharedApplication().statusBarFrame != CGRectZero {
      barHeight = statusBarHeight()
    }
    return view.height() - barHeight// - 44 //(navigationController?.navigationBar.height)!
  }
  
  public func addLeftBarButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem {
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
  
  public   func setRightBarButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    self.navigationItem.rightBarButtonItems = [item]
    return item
  }
  
  @nonobjc
  public func setRightBarButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(title, action: action)
    self.navigationItem.rightBarButtonItems = [item]
    return item
  }
  
  public func setLeftBarButtonItem(image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    item.customView?.layoutSubviews()
    self.navigationItem.leftBarButtonItems = [item]
    return item
  }
  
  @nonobjc
  public func setLeftBarButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(title, action: action)
    item.customView?.layoutSubviews()
    self.navigationItem.leftBarButtonItems = [item]
    return item
  }
  
  
  public func addRightBarButtonItemWithBadge(image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItemWithBadge(image, action: action)
    var items: [UIBarButtonItem] = [UIBarButtonItem]()
    if let _item = self.navigationItem.rightBarButtonItem {
      item.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25)
      items = [_item, item]
    } else {
      items = [item]
    }
    item.customView?._coloredWithSuperviews()
    (item.customView as? IconLabelButton)!.icon._coloredWithSuperviews()
    self.navigationItem.rightBarButtonItems = items
    return item
  }
  
  public func disabledNavShadow() {
    let navbar = navigationController?.navigationBar
    navbar?.setBackgroundImage(UIImage().makeImageWithColorAndSize(K.Color.navigator), forBarPosition: .Any, barMetrics: .Default)
    navbar?.shadowImage = UIImage()
  }
  
  public func newBarButtonItemWithBadge(image: UIImage, action: Selector) -> UIBarButtonItem {
    let button = IconLabelButton(image: image, text: "111")
    let item = UIBarButtonItem(title: nil, style: .Plain, target: self, action: action)
    //    let item = UIBarButtonItem(customView: button)
    _logForUIMode(0)
    item.customView = button
    return item
  }
  
  public func addRightBarButtonItem(iconCode iconCode: String, action: Selector, withOffset: Bool = true) -> UIBarButtonItem {
    let item = newBarButtonItem(iconCode: iconCode, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }
  
  public func addRightBarButtonItem(title: String, action: Selector, withOffset: Bool = true) -> UIBarButtonItem {
    let item = newBarButtonItem(title, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }
  
  @nonobjc
  public func addRightBarButtonItem(image: UIImage, action: Selector, withOffset: Bool = true) -> ENMBadgedBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }
  
  public func appendItemToBar(item: UIBarButtonItem, withOffset: Bool) {
    var items: [UIBarButtonItem] = [UIBarButtonItem]()
    if let _item = self.navigationItem.rightBarButtonItem {
      if withOffset { item.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25) } else { item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0) }
      items = [_item, item]
    } else {
      items = [item]
    }
    self.navigationItem.rightBarButtonItems = items
  }
  
  public func newBarButtonItem(iconCode iconCode: String, action: Selector, color: UIColor = K.Color.barButtonItem) -> UIBarButtonItem {
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
  
  public func newBarButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    let button = UIButton(type: .Custom)
    button.text(title).colored(K.BarButtonItem.color).sizeToFit()
    button.frame = CGRect(x: 0, y: 0, width: button.textWidth(), height: button.textHeight())
    button.addTarget(self, action: action, forControlEvents: .TouchUpInside)
    //    button._coloredWithSuperviews()
    let item = UIBarButtonItem(customView: button)
    return item
  }
  
  public func newBarButtonItem(image: UIImage, action: Selector, count: Int = 0) -> ENMBadgedBarButtonItem {
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
  
  public func disableSwipeRightToBack(swipeRight: UISwipeGestureRecognizer) {
    self.view.removeGestureRecognizer(swipeRight)
  }
  
  public func enableSwipeRightToBack(target: AnyObject) -> UISwipeGestureRecognizer {
    let swipeRight = UISwipeGestureRecognizer(target: target, action: #selector(UIViewController.respondToSwipeGesture(_:)))
    swipeRight.direction = UISwipeGestureRecognizerDirection.Right
    self.view.addGestureRecognizer(swipeRight)
    return swipeRight
  }
  
  public func respondToSwipeGesture(gesture: UIGestureRecognizer) {
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
  
  public func hideBackBarButtonItem() {
    navigationItem.hidesBackButton = true
  }
  
  public func hideBackBarButtonItemTitle() {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
  }
  
  public func enableCaptureSessionWithPreview(liveView: UIView, position: AVCaptureDevicePosition = .Back, onComplete: () -> ()) -> (AVCaptureDeviceInput, AVCaptureStillImageOutput, AVCaptureSession) {
    var input = AVCaptureDeviceInput()
    let output = AVCaptureStillImageOutput()
    let session = AVCaptureSession()
    delayedJob(0.1) {
      do {
        session.sessionPreset = AVCaptureSessionPresetPhoto
        //        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        var device: AVCaptureDevice!
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        devices.forEach({ (item) in
          if item.position == position {
            device = item as! AVCaptureDevice
          }
        })
        
        input = try AVCaptureDeviceInput(device: device)
        
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
    return (input, output, session)
  }
  
  public func collectionView(layout: UICollectionViewFlowLayout, registeredClass: AnyClass!, identifier: String) -> UICollectionView {
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    layout.scrollDirection = .Horizontal
    layout.itemSize = CGSizeMake(100, 100)
    let padding: CGFloat = 10
    layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding)
    collectionView.delegate = self as? UICollectionViewDelegate
    collectionView.dataSource = self as? UICollectionViewDataSource
    collectionView.backgroundColored(UIColor.clearColor())
    collectionView.registerClass(registeredClass, forCellWithReuseIdentifier: identifier)
    return collectionView
  }
  
  public func tableView(registeredClass: AnyClass!, identifier: String, style: UITableViewStyle = .Plain) -> UITableView {
    let tableView = UITableView(frame: view.bounds, style: style)
    tableView.delegate = self as? UITableViewDelegate
    tableView.dataSource = self as? UITableViewDataSource
    tableView.estimatedRowHeight = 10
    tableView.styled()
    tableView.registerClass(registeredClass, forCellReuseIdentifier: identifier)
    return tableView
  }
}

import AVFoundation
extension AVCaptureStillImageOutput {
  public func getImage(onComplete: (image: UIImage) -> ()) {
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

