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
// import RandomKit
import SwiftRandom


extension UIViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  public enum DismissType {
    case login
    case delete
    case update
  }

  @discardableResult open func enableTabBarController(_ viewControllers: [UIViewController]!, titles: [String]!, images: [UIImage], selectedImages: [UIImage] = []) -> UITabBarController! {
    var _selectedImages = [UIImage]()
    if selectedImages.count > 0 {
      _selectedImages = selectedImages
    } else {
      _selectedImages = images
    }
    let tabBarViewController = UITabBarController()
    let vcs = viewControllers.map({ $0.embededInNavigationController() })
    for (index, vc) in vcs.enumerated() {
      vc.tabBarItem = UITabBarItem(title: titles[index], image: images[index], selectedImage: _selectedImages[index])
      viewControllers[index].titled(titles[index])
    }
    tabBarViewController.viewControllers = vcs
    return tabBarViewController
  }

//  open func _enableDebugInfo(_ fileName: String = (#file as NSString).lastPathComponent) {
//    _logForUIMode()
//    if _isSimulator() {
//      _logForUIMode()
//      let _fileName = Label()
//      view.layout([_fileName])
//      _fileName.texted(fileName).smaller(2)
//      view.bringSubview(toFront: _fileName)
//      _fileName.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: _fileName.textWidth(), height: _fileName.textHeight())
//    }
//  }

  open func goBackToRootViewController(_ delayed: Double = 0, onComplete: @escaping () -> () = {}) {
    delayedJob(delayed) {
      self.navigationController?.popToRootViewController(animated: true)
      onComplete()
    }
  }

  public func goBackViewController(_ delayed: Double = 0, onComplete: @escaping () -> () = {}) {
    delayedJob(delayed) {
      self.navigationController?.popViewController(animated: true)
      onComplete()
    }
  }

  @discardableResult public func titled(_ title: String, token: String = #file) -> UIViewController {
    navigationItem.title = _isSimulator() ? "[\(token.split("/").last!.split(".").first!)]-\(title)" : title
    return self
  }

  @discardableResult public func openImagePicker(_ sourceType: UIImagePickerControllerSourceType = .camera) -> UIImagePickerController {
    var type = sourceType
    if _isSimulator() { type = .photoLibrary }
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = type
    self.present(picker, animated: true, completion: nil)
    return picker
  }

  @discardableResult public func embededInNavigationController() -> UINavigationController {
    return UINavigationController(rootViewController: self)
  }

  public func flipViewController(_ vc: UIViewController, completion: @escaping () -> () = {}) {
    openViewController(vc, style: .flipHorizontal, completion: completion)
  }

//  public func openViewController(_ vc: UIViewController, style: UIModalTransitionStyle = .coverVertical, completion: @escaping ()->() = {}) {
  public func openViewController(_ vc: UIViewController, style: UIModalTransitionStyle = .coverVertical, completion: @escaping () -> () = {}, onDismissViewController: @escaping () -> () = {}, didDismissViewController: @escaping (_ action: DismissType) -> () = {_ in }, didLoadData: @escaping () -> () = {}) -> Void {
    if let vc = vc as? DefaultViewController {
      vc.didLoadData = didLoadData
      vc.onDismissViewController = onDismissViewController
      vc.didDismissViewController = didDismissViewController
    }
    openControllerWithDelegate(self, vc: vc, completion: completion)
  }

  public func pushViewController(_ vc: UIViewController, checked: Bool = true, delayed: Double = 0, onComplete: () -> () = {}, onDismissViewController: @escaping () -> () = {}, didDismissViewController: @escaping (_ action: DismissType) -> () = {_ in }) -> Void {
    if let vc = vc as? DefaultViewController {
      vc.onDismissViewController = onDismissViewController
      vc.didDismissViewController = didDismissViewController
    }
//    delayedJob(delayed) {
      self.navigationController?.pushViewController(vc, animated: true)
      onComplete()
//    }
  }

  public func popToViewController(_ vc: UIViewController, delayed: Double = 0, onComplete: @escaping () -> () = {}) {
    delayedJob(delayed){
      self.navigationController?.popToViewController(vc, animated: true)
      onComplete()
    }
  }

  public func setFieldsGroup(_ fields: [UITextField]) -> Void {
    let delegate = self as! UITextFieldDelegate
    if fields.count > 1 {
      for index in 0...fields.count - 2 {
        fields[index].delegate = delegate
        fields[index].nextField = fields[index + 1]
      }
    }
    fields.last?.delegate = delegate
  }

  public func setViewsGroup(_ fields: [UITextView]) -> Void {
    let delegate = self as! UITextViewDelegate
    if fields.count > 1 {
      for index in 0...fields.count - 2 {
        fields[index].delegate = delegate
        fields[index].nextField = fields[index + 1]
      }
    }
    fields.last?.delegate = delegate
  }

  @discardableResult public func navBarHeight() -> CGFloat {
    return (navigationController != nil) ? (navigationController?.navigationBar.height)! : 0
  }

  @discardableResult public func tabBarHeight() -> CGFloat {
    if let tabbar = tabBarController {
      if tabbar.tabBar.isHidden == true {
        return 0
      } else {
        return tabbar.tabBar.height
      }
    } else {
      return 0
    }
  }

  public func _colored(_ views: [UIView]) {
    for index in 0...views.count - 1 {
      views[index]._coloredWithIndex(index)
    }
  }

  @discardableResult public func viewNetHeight() -> CGFloat {
    var barHeight: CGFloat = 0
    if UIApplication.shared.statusBarFrame != .zero {
      barHeight = statusBarHeight()
    }
    return view.height() - barHeight// - 44 //(navigationController?.navigationBar.height)!
  }

  @discardableResult public func addLeftBarButtonItem(_ image: UIImage, action: Selector) -> UIBarButtonItem {
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

  @discardableResult public func setRightBarButtonItem(_ image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    self.navigationItem.rightBarButtonItems = [item]
    return item
  }

  @discardableResult public func setRightBarButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(title: title, action: action)
    self.navigationItem.rightBarButtonItems = [item]
    return item
  }

  @discardableResult public func setLeftBarButtonItem(_ image: UIImage, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    item.customView?.layoutSubviews()
    self.navigationItem.leftBarButtonItems = [item]
    return item
  }

  @nonobjc
  @discardableResult public func setLeftBarButtonItem(_ title: String, action: Selector) -> UIBarButtonItem {
    let item = newBarButtonItem(title: title, action: action)
    item.customView?.layoutSubviews()
    self.navigationItem.leftBarButtonItems = [item]
    return item
  }

  @discardableResult public func addRightBarButtonItemWithBadge(_ image: UIImage, action: Selector) -> UIBarButtonItem {
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
    navbar?.setBackgroundImage(UIImage().makeImageWithColorAndSize(color: K.Color.navigator), for: .any, barMetrics: .default)
    navbar?.shadowImage = UIImage()
  }

  @discardableResult public func newBarButtonItemWithBadge(_ image: UIImage, action: Selector) -> UIBarButtonItem {
    let button = IconLabelButton(image: image, text: "111")
    let item = UIBarButtonItem(title: nil, style: .plain, target: self, action: action)
    //    let item = UIBarButtonItem(customView: button)
    item.customView = button
    return item
  }

  @discardableResult public func addRightBarButtonItem(iconCode: String, action: Selector, withOffset: Bool = true) -> UIBarButtonItem {
    let item = newBarButtonItem(iconCode: iconCode, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }

  @discardableResult public func addRightBarButtonItem(_ title: String, action: Selector, withOffset: Bool = true) -> UIBarButtonItem {
    let item = newBarButtonItem(title: title, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }

  @nonobjc
  @discardableResult public func addRightBarButtonItem(_ image: UIImage, action: Selector, withOffset: Bool = true) -> ENMBadgedBarButtonItem {
    let item = newBarButtonItem(image, action: action)
    appendItemToBar(item, withOffset: withOffset)
    return item
  }

  public func appendItemToBar(_ item: UIBarButtonItem, withOffset: Bool) {
    var items: [UIBarButtonItem] = [UIBarButtonItem]()
    if let _item = self.navigationItem.rightBarButtonItem {
      if withOffset { item.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25) } else { item.imageInsets = UIEdgeInsetsMake(0, 0, 0, 0) }
      items = [_item, item]
    } else {
      items = [item]
    }
    self.navigationItem.rightBarButtonItems = items
  }

  @discardableResult public func newBarButtonItem(iconCode: String, action: Selector, color: UIColor = K.Color.barButtonItem) -> UIBarButtonItem {
    let item = newBarButtonItem(title: iconCode, action: action)
    let button = (item.customView as! UIButton)
    button.titleLabel!.font = UIFont(name: K.Font.icon, size: K.BarButtonItem.size)
    button.frame = CGRect(x: 0, y: 0, width: button.textWidth(), height: button.textHeight() * 2)
    button.setTitleColor(color, for: .normal)
    return item
  }

  @discardableResult public func newBarButtonItem(title: String, action: Selector) -> UIBarButtonItem {
    let button = UIButton(type: .custom)
    button.texted(title).colored(K.BarButtonItem.color).sizeToFit()
    button.frame = CGRect(x: 0, y: 0, width: button.textWidth(), height: button.textHeight())
    button.addTarget(self, action: action, for: .touchUpInside)
    let item = UIBarButtonItem(customView: button)
    return item
  }

  @discardableResult public func newBarButtonItem(_ image: UIImage, action: Selector, count: Int = 0) -> ENMBadgedBarButtonItem {
    let button = UIButton(type: .custom)
    button.frame = CGRect(x: 0, y: 0, width: K.BarButtonItem.size, height: K.BarButtonItem.size)
    ////    if let knownImage = image {
    ////      button.frame = CGRectMake(0.0, 0.0, knownImage.size.width, knownImage.size.height)
    ////    } else {
    ////      button.frame = .zero;
    ////    }
    ////    button.setBackgroundImage(image, forState: UIControlState.normal)
    button.imaged(image)
    button.addTarget(self,
                     action: action,
                     for: .touchUpInside)
    //
    let item = ENMBadgedBarButtonItem(customView: button, value: "\(count)")

    //    let item = UIBarButtonItem(title: nil, style: .plain, target: self, action: action)
    item.image = image
    return item
  }

  public func disableSwipeRightToBack(_ swipeRight: UISwipeGestureRecognizer) {
    self.view.removeGestureRecognizer(swipeRight)
  }

  @discardableResult public func enableSwipeRightToBack(_ target: AnyObject) -> UISwipeGestureRecognizer {
    let swipeRight = UISwipeGestureRecognizer(target: target, action: #selector(UIViewController.respondToSwipeGesture(_:)))
    swipeRight.direction = UISwipeGestureRecognizerDirection.right
    self.view.addGestureRecognizer(swipeRight)
    return swipeRight
  }

  @objc public func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case UISwipeGestureRecognizerDirection.right:
        navigationController?.popViewController(animated: true)
      default: break
      }
    }
  }

  public func hideBackBarButtonItem() {
    navigationItem.hidesBackButton = true
  }

  public func hideBackBarButtonItemTitle() {
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//    let icon = getIcon(.chevronLeft, options: ["size": K.BarButtonItem.size, "color": K.Color.barButtonItem])
//    self.navigationController?.navigationBar.backIndicatorImage = icon
//    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = icon
  }

//  @discardableResult public func enableCaptureSessionWithPreview___(liveView: UIView, position: AVCaptureDevice.Position = .back, onComplete: @escaping () -> ()) -> (AVCaptureDeviceInput?, AVCaptureStillImageOutput?, AVCaptureSession?) {
//
//    let session = AVCaptureSession()
//    let output = AVCaptureStillImageOutput()
//    output.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
//    enabledPreview(session: session, target: liveView)
//    session.sessionPreset = .photo
//    session.addOutput(output)
//    return (nil, output, session)
//  }

  public func checkCamera(ready: @escaping () -> ()) {
    if AVCaptureDevice.authorizationStatus(for: .video) == .authorized {
      ready()
    } else {
      alert(self, title: "相機授權", message: "需要相機授權", onCompletion: {
      }, okHandler: { (ok) in
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
          if granted {
            ready()
          } else {
            alert(self, title: "沒有相機的授權", message: "要到控制中心開啟權限", onCompletion: {
            }, okHandler: { (ok) in
              UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
            })
          }
        })
      })
    }
  }

  func enabledPreview(session: AVCaptureSession, target: UIView) {
    let preview = AVCaptureVideoPreviewLayer(session: session)
    preview.videoGravity = .resizeAspectFill
    preview.frame = target.bounds
    target.layer.addSublayer(preview)
  }

  @discardableResult public func enableCaptureSessionWithPreview(liveView: UIView, position: AVCaptureDevice.Position = .back, onComplete: @escaping () -> ()) -> (AVCaptureDeviceInput?, AVCaptureStillImageOutput?, AVCaptureSession?) {
    var input: AVCaptureDeviceInput!
    let output = AVCaptureStillImageOutput()
    let session = AVCaptureSession()
    if !_isSimulator() {
    delayedJob(0.1) {
      do {
        session.sessionPreset = AVCaptureSession.Preset.photo
        var targetDevice: AVCaptureDevice!
        let devices = AVCaptureDevice.devices(for: AVMediaType.video)
        devices.forEach({ (device) in
          if device.position == position {
            targetDevice = device
          }
        })
        input = try AVCaptureDeviceInput(device: targetDevice)
        session.addInput(input)
        output.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        session.addOutput(output)
        let preview = AVCaptureVideoPreviewLayer(session: session)
        preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preview.frame = liveView.bounds
        liveView.layer.addSublayer(preview)
        session.startRunning()
        onComplete()
      } catch {
        print(error)
      }
      }
    }
    return (input, output, session)
  }

  @discardableResult public func collectionView(_ layout: UICollectionViewFlowLayout, registeredClass: AnyClass!, identifier: String) -> UICollectionView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 100, height: 100)
    let padding: CGFloat = 10
    layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding)
    collectionView.delegate = self as? UICollectionViewDelegate
    collectionView.dataSource = self as? UICollectionViewDataSource
    collectionView.backgroundColored(UIColor.clear)
    collectionView.register(registeredClass, forCellWithReuseIdentifier: identifier)
    return collectionView
  }

  @discardableResult public func tableView(_ registeredClass: AnyClass!, identifier: String, style: UITableViewStyle = .plain) -> UITableView {
    let tableView = UITableView(frame: view.bounds, style: style)
    tableView.delegate = self as? UITableViewDelegate
    tableView.dataSource = self as? UITableViewDataSource
//    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.styled()
    tableView.register(registeredClass, forCellReuseIdentifier: identifier)
    return tableView
  }
}

import AVFoundation
extension AVCaptureStillImageOutput {
  public func getImage(onComplete: @escaping (_ image: UIImage) -> ()) {
    let conneciton = connection(with: AVMediaType.video)
    captureStillImageAsynchronously(from: conneciton!, completionHandler: { (buffer, error) in
      let data = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer!)
      let provider = CGDataProvider(data: data! as CFData)
      let cgImageRef = CGImage(jpegDataProviderSource: provider!, decode: nil, shouldInterpolate: true,  intent: CGColorRenderingIntent.defaultIntent)
      let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: .right)
      onComplete(image)
    })
  }
}
