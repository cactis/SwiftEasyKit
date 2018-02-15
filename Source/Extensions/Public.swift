//
//  Public.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/28/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation
import MapKit
import LoremIpsum
import FontAwesome_swift
import Neon
import SwiftRandom
import KeychainSwift
import ObjectMapper
import PhotoSlider
import AssistantKit

//import EZLoadingActivity

public func storeToKeyChain(_ value: String?, key: String!) {
  KeychainSwift().set(value!, forKey: key)
}

public func loadFromKeyChain(_ key: String!) -> String? {
  return KeychainSwift().get(key)
}

open class PromptType {
  public var color: UIColor!
  public var bgColor: UIColor!
  public init(color: UIColor = K.Color.Alert.color, bgColor: UIColor = K.Color.Alert.backgroundColor) {
    self.color = color
    self.bgColor = bgColor
  }
}

public func statusBarHeight() -> CGFloat {
  return UIApplication.shared.statusBarFrame.height
}

public func prompt(_ msgs: [String], runWith: (_ msg: String) -> String = { msg in return msg }, style: PromptType = PromptType(), onTapped: @escaping () -> () = {}) {
  prompt(runWith(msgs.randomItem()!), style: style, onTapped: onTapped)
}

public func prompt(_ msg: String?, style: PromptType = PromptType(), onTapped: @escaping () -> () = {}) {
  //  if !Development.prompt { return }
  let message = msg ?? "(異常錯誤：未被追蹤到的錯誤。)"
  UIApplication.shared.isStatusBarHidden = true
  let notification = UIButton()
  let block = DefaultView()
  let label = UILabel()
  
  block.backgroundColored(style.bgColor).shadowed().radiused(3).bordered(0.5, color: K.Color.text.lighter().cgColor)
  label.styled().colored(style.color).texted(message).multilinized().centered().sized(12.em)
  notification.layout([block.layout([label])])
  
  let xPad = 10.em
  let yPad = 15.em
  
  let w = screenWidth() - 4 * xPad
  let h = label.getHeightByWidth(w)
  
  label.frame = CGRect(x: xPad, y: yPad, width: w, height: h)
  block.frame = CGRect(x: xPad, y: 0, width: w + 2 * xPad, height: label.bottomEdge() + yPad)
  
  label.isUserInteractionEnabled = false
  block.isUserInteractionEnabled = false
  
  if label.linesCount > 1 { label.aligned(.left) }
  
  if let v = window() {
    v.addSubview(notification)
    notification.frame = CGRect(x: 0, y: -1 * screenHeight(), width: screenWidth(), height: screenHeight())
    UIView().animate(onComplete: {
      notification.frame = CGRect(x: 0, y: statusBarHeight(), width: screenWidth(), height: screenHeight())
    })
    
    delayedJob(K.Prompt.delay, withIndicator: false, todo: {
      if notification.superview != nil {
        notification.tapped()
      }
    })
    
    notification.whenTapped({
      UIView().animate(onComplete: {
        notification.frame = CGRect(x: 0, y: -1 * screenHeight(), width: screenWidth(), height: screenHeight())
      })
      delayedJob(0.1, withIndicator: false, todo: {
        notification.removeFromSuperview()
        onTapped()
      })
    })
  }
}

public func wizImage(_ name: String) -> UIImage {
  var img = UIImage(named: name)
  img = img?.withRenderingMode(.alwaysOriginal)
  return img!
}

public func randomImage(_ onComplete: (_ image: UIImage) -> ()) {
  //  Lorem.asyncPlaceholderImageWithSize(CGSize(width: 400, height: 300)) { (image) -> Void in
  //    onComplete(image: image)
  //  }
  let image = UIImage(named: randomImageName())
  onComplete(image!)
}

public func randomImage() -> UIImage {
  return UIImage(named: randomImageName())!
}

public func randomImageName() -> String {
  return K.Sample.images.randomItem()!
}

public func randomAvatarUrl() -> String {
  let w = CGFloat(Randoms.randomInt(120, 200))
  return randomImageUrl(width: w, height: w)
}

public func randomImageUrl(width: CGFloat = CGFloat(Randoms.randomInt(400, 600)), height: CGFloat = CGFloat(Randoms.randomInt(300, 400))) -> String {
  return Lorem.urlForPlaceholderImage(from: .dummyImage, with: CGSize(width: width, height: height)).absoluteString
}

public func placeHoderImage() -> UIImage {
  return UIImage.fontAwesomeIcon(name: .clockO, textColor: UIColor.lightGray.lighter(), size: CGSize(width: 300, height: 300))
}

public func openControllerWithDelegate(_ delegate: UIViewController, vc: UIViewController, style: UIModalTransitionStyle = .coverVertical, completion: @escaping () -> ()) {
  vc.modalTransitionStyle = style
  let navigator = UINavigationController()
  navigator.pushViewController(vc, animated: true)
  delegate.present(navigator, animated: true, completion: completion)
  //  delegate.present(nv, animated: true, completion: { () -> Void in
  //    completion()
  //  })
}

public func _isUIMode() -> Bool {
  return _isSimulator() && Development.mode == "UI Design"
}

public func _isAPIMode() -> Bool {
  return _isSimulator() && Development.mode == "API Implement"
}

public func _autoRunForAPIMode(_ funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: @escaping () -> ()) {
  if _isAPIMode() {
    _autoRun(funcName, fileName: fileName, run: run)
  }
}

public func _autoRunInDevice(_ funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: @escaping () -> ()) {
  if !_isSimulator() {
    autoRun(funcName, fileName: fileName, run: run)
  }
}

private func autoRun(_ funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: @escaping () -> ()) {
  print("=== autoRun in \(funcName) of \(fileName) \(line):\(column) ===")
  delayedJob { () -> () in
    run()
  }
}

public func _autoRunFor(_ who: String = "All", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: @escaping () -> ()) {
  if who == Development.developer {
    _autoRun(funcName, fileName: fileName, run: run)
  }
}

public func _autoRunForUIMode(_ funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: @escaping () -> ()) {
  if _isUIMode() {
    _autoRun(funcName, fileName: fileName, run: run)
  }
}

public func _autoRun(_ funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: @escaping () -> ()) {
  if Development.autoRun && !_isRunningTest() {
    print("=== autoRun in \(Development.mode): \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
    _delayedJob { () -> () in
      run()
    }
  }
}

public func runInDeviceMode(_ run: () -> (), elseRun: () -> () = {}) { if !_isSimulator() { run() } else { elseRun() } }


public func _isRunningTest() -> Bool {
  return UIApplication.isRunningTest
}

public func _isWho(_ who: String) -> Bool {
  //  _logForAnyMode(Development.developer, title: "Development.developer")
  //  _logForAnyMode(!_isRunningTest())
  //  _logForAnyMode(_isSimulator())
  //  _logForAnyMode(who == Development.developer)
  //  _logForAnyMode(_isSimulator() && who == Development.developer && !_isRunningTest())
  return _isSimulator() && who == Development.developer && !_isRunningTest()
}
public func _isSimulator() -> Bool { return TARGET_OS_SIMULATOR != 0 || Development.setDeviceAsSimulator == true }
public func _isRealSimulator() -> Bool { return TARGET_OS_SIMULATOR != 0 }
public func isReadDevice() -> Bool { return !_isRealSimulator() }

public func _logError(_ err: NSError!) {
  _log(err.localizedDescription as AnyObject, title: "err")
}

public func _logClear() { (0...50).forEach { _ in print("\n") }}

public func _logForAnyMode(_ obj: Any? = "", title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForUIMode(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  _logForAPIMode(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logFor(_ who: String, obj: AnyObject?, title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if who == Development.developer {
    _logForUIMode(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  }
}

public func _logForUIMode(_ title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForUIMode("" as AnyObject, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logForUIMode(_ obj: Any?, title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if _isUIMode() {
    _log(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  }
}

public func _logForAPIMode(_ title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForAPIMode("" as AnyObject, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logForAPIMode(_ obj: Any?, title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if _isAPIMode() {
    _log(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  }
}

private func _log(_ title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  print("\n")
  print("\(NSDate())")
  if title == "" {
    print("=== in \(funcName) of \(fileName) \(line):\(column) ===")
  } else {
    print("=== \(title), in \(funcName) of \(fileName) \(line):\(column) ===")
  }
  print("\n")
}

private func _log(_ obj: Any?, title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  let time = NSDate()
  print("")
  print(">>> \"\(title)\" in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) >>>")
  if obj != nil {
    if let json = obj as? Mappable {
      debugPrint(json.toJSON())
    } else {
      debugPrint(obj!)
    }
  } else {
    debugPrint("nil")
  }
  print("<<< \"\(title)\" in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) <<<")
  print("\(time) in \(Development.mode) mode")
  print("")
}

private func _log(obj: Int, title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _log("\(obj)" as AnyObject, title: title, funcName: funcName, fileName: fileName)
}

public func _disableDeviceAsSimulator(status: Bool = true, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  print("")
  print("=== call _disableSimulatorMode in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
  Development.setDeviceAsSimulator = !status
}

public func _enableDeviceAsSimulator(status: Bool = true, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  print("")
  print("=== call _enableSimulatorMode in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
  Development.setDeviceAsSimulator = status
}

public func alert(_ delegate: AnyObject, title: String, message: String, onCompletion: @escaping () -> () = {}, okHandler: @escaping (_ action: UIAlertAction) -> () = {_ in }, cancelHandler: @escaping (_ action: UIAlertAction) -> () = {_ in }) {
  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
  alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: cancelHandler))
  alert.addAction(UIAlertAction(title: "確定", style: .default, handler: okHandler))
  if delegate.isKind(of: UIViewController.self) {
    delegate.present(alert, animated: true, completion: onCompletion)
  } else {
    (delegate as? UIView)?.parentViewController()?.present(alert, animated: true, completion: onCompletion)
  }
}

public func dial(_ number: String) {
  UIApplication.shared.openURL(NSURL(string: number)! as URL)
}

public func wizRandomToken() -> String {
  return Randoms.randomFakeTag()
}

public func wizRandomBool() -> Bool {
  return wizRandomInt() % 2 == 0
}

public func wizRandomInt(_ lower: Int = 0, upper: Int = 9) -> Int {
  return Randoms.randomInt(lower, upper)
}

public func wizRandomPercentage() -> Float {
  return Randoms.randomFloat(0.2, 1.0)
}

public func screenWidth() -> CGFloat {
  return UIScreen.main.bounds.width
}

public func screenCenter() -> CGPoint {
  return CGPoint(x: screenWidth() / 2, y: screenHeight() / 2)
}

public func screenHeight() -> CGFloat {
  return UIScreen.main.bounds.height
}

public func randomBlock(_ n: Int = 2, m: Int = 4, run: () -> ()) {
  (0...wizRandomInt(n, upper: m)).forEach { (i) -> () in
    run()
  }
}

//public func runOnce(_ run: () -> ()) -> () {
//  struct TokenContainer {
//    static var token : dispatch_once_t = 0
//  }
//
//  dispatch_once(&TokenContainer.token) {
//    run()
//  }
//}

public func randomImages(_ n: Int = 2, of: Int = 10, placeHolder: UIImage = UIImage()) -> [UIImage] {
  return (0...of - 1).map({ (i) in if i < n { return UIImage(named: randomImageName())! } else { return placeHolder }})
}

public func notNull(_ s: AnyObject?) -> String! {
  if (s != nil) && !(s!.isEqual(NSNull())) {
    return s as! String
  } else {
    return ""
  }
}

public func notNullDate(_ s: NSDate?) -> NSDate! {
  if (s != nil) && !(s!.isEqual(NSNull())) {
    return s as NSDate!
  } else {
    return NSDate()
  }
}

public func logInfo(_ fileName: String? = #file, funcName: String? = #function) -> [String: String] {
  return ["fileName": (fileName! as NSString).lastPathComponent, "funcName": funcName!]
}

public func barButtonItemImage(_ name: FontAwesome) -> UIImage {
  return getIcon(name, options: ["size": K.BarButtonItem.size])
}

public func getTabIcon(_ name: FontAwesome, options: NSDictionary = NSDictionary(), inset: CGFloat = 0) -> UIImage {
  let size = options["size"] as? CGFloat ?? K.BarButtonItem.size
  let color = options["color"] as? UIColor ?? K.Color.button
  let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clear
  var icon = UIImage.fontAwesomeIconWithNameWithInset(name: name, textColor: color, size: CGSize(width: size, height: size), backgroundColor: backgroundColor, inset: inset)
  icon = icon.withRenderingMode(.alwaysOriginal)
  return icon
}

public func getIcon(_ name: FontAwesome, options: NSDictionary = NSDictionary(), inset: CGFloat = 0) -> UIImage {
  let opts: NSMutableDictionary = options.mutableCopy() as! NSMutableDictionary
  let size = options["size"] as? CGFloat ?? K.BarButtonItem.size// * 4
  opts["size"] = size
  return getTabIcon(name, options: opts)
}

public func getImage(iconCode: String, color: UIColor = K.Color.barButtonItem, size: CGFloat = K.BarButtonItem.size) -> UIImage {
  return UIImage.fromCode(drawText: iconCode, color: color, size: size)
}

public func getImage(_ name: String) -> UIImage {
  return UIImage(named: name)!
}

public func indicatorStart() -> UIView {
  //  EZLoadingActivity.Settings.ActivityColor = UIColor.black.colorWithAlphaComponent(0.8)
  //  EZLoadingActivity.show("資料載入中...", disableUI: false)
  
  let bg = UIView()
  //  let indicator = UIActivityIndicatorView()
  //  indicator.startAnimating()
  //  bg.frame = CGRectMake(0, 0, screenWidth(), screenHeight())
  //  bg.center = screenCenter()
  //  bg.userInteractionEnabled = false
  //  //  bg.backgroundColored(UIColor.black.colorWithAlphaComponent(0.05))
  //  indicator.center = screenCenter()
  //  //  currentView()?.addSubview(bg)
  //  bg.addSubview(indicator)
  return bg
}

public func indicatorEnd(indicator: UIView) {
  indicator.removeFromSuperview()
  //  EZLoadingActivity.hide()
  //  SwiftSpinner.hide()
  //  indicator.indicator.stopAnimating()
}

public func _delayedJob(todo: @escaping () -> ()) {
  if _isSimulator() {
    delayedJob(1) { () -> () in todo()
    } } }

public func delayedJob(_ todo: @escaping () -> ()) { delayedJob(0.5, todo: todo) }

public func delayedJob(_ seconds: Double, withIndicator: Bool = true, todo: @escaping () -> ()) {
  var indicator = UIView()
  if withIndicator { indicator =  indicatorStart() }
  //  let delay = seconds * Double(NSEC_PER_SEC)
  DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
    todo()
    indicatorEnd(indicator: indicator)
  }
}

public func openPhotoSlider(imageURLs: [String], index: Int! = 0, infos: [String]? = nil) {
  let urls = imageURLs.map({ URL(string: $0)! })
  openPhotoSlider(photoSlider: PhotoSlider.ViewController(imageURLs: urls), index: index, infos: infos)
}

public func openPhotoSlider(images: [UIImage], index: Int! = 0, infos: [String]? = nil) {
  openPhotoSlider(photoSlider: PhotoSlider.ViewController(images: images), index: index, infos: infos)
}

public func openPhotoSlider(photoSlider: PhotoSlider.ViewController, index: Int! = 0, infos: [String]? = nil) {
  if let _info = infos?.first {
    let labelInfo = _info.toHtmlWithStyle()
    let label = Label(rectInsets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)).multilinized().html(labelInfo!)
    label.colored(UIColor.black).backgroundColored(UIColor.white)
    photoSlider.view.addSubview(label)
    let w = screenWidth() * 0.9
    label.anchorTopCenter(withTopPadding: 100, width: w, height: label.getHeightByWidth(w))
  }
  photoSlider.currentPage = index
  photoSlider.modalPresentationStyle = .overFullScreen // .overCurrentContext
  photoSlider.modalTransitionStyle = .crossDissolve
  currentViewController.present(photoSlider, animated: true, completion: nil)
}

public func currentView() -> UIView? {
  return window()?.subviews.last
}

public func window() -> UIWindow? {
  return appDelegate().window
}
public var currentViewController: UIViewController { get { return (window()?.visibleViewController)! }}

public func appDelegate() -> DefaultAppDelegate {
  return UIApplication.shared.delegate as! DefaultAppDelegate
}

public func requestPushNotification() { // 在任何地方呼叫用來請求推播授權
  appDelegate().requestToAllowUserNotification(UIApplication.shared)
}

public func verticalLayout(_ blocks: [UIView], heights: [CGFloat], padding: CGFloat = 0, xPad: CGFloat = 0, yPad: CGFloat = 0, alignUnder: UIView? = nil) {
  var prevBlock: UIView!
  blocks.forEach { (block) in
    let index = blocks.index(of: block)!
    switch index {
    case 0:
      if alignUnder != nil {
        block.alignUnder(alignUnder, matchingLeftAndRightWithTopPadding: yPad, height: heights[0])
      } else {
        block.anchorAndFillEdge(.top, xPad: xPad, yPad: yPad, otherSize: heights[0])
      }
    default:
      block.alignUnder(prevBlock, matchingLeftAndRightWithTopPadding: padding, height: heights[index])
    }
    prevBlock = block
  }
}

public class Env {
  
  public class func isPad() -> Bool {
    return Device.isPad
  }
  
  public class var deviceType: Type { get {
    return Device.type
    }}

  public class func size(phone: CGFloat, pad: CGFloat) -> CGFloat {
    return Device.size(phone: phone, pad: pad)
  }

  static public var family: ScreenFamily { get { return Device.screen.family } }

  static public func size<T: Any>(old: T? = nil, small: T, medium: T, big: T) -> T {
    _logForUIMode(Device.screen.family, title: "family")
    return Device.size(old: old, small: small, medium: medium, big: big)
  }

}


public extension Mappable {
  
  /// Convert self to JSON String.
  /// - Returns: Returns the JSON as String or empty string if error while parsing.
  func json() -> String {
    do {
      let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
      guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
        print("Can't create string with data.")
        return "{}"
      }
      return jsonString
    } catch let parseError {
      print("json serialization error: \(parseError)")
      return "{}"
    }
  }
}


//  class func loginFromFacebook(_ data: NSDictionary, success: @escaping (User?) -> (), next: @escaping () -> ()) {
//    // *** _logForUIMode(data, title: "data")
//    var params = [String: NSObject]()
//    params = [
//      "uid": data.object(forKey: "id") as! String as NSObject,
//      "provider": "facebook" as NSObject as NSObject,
//      "name": data.object(forKey: "name") as! String as NSObject,
//      "first_name": data.object(forKey: "first_name") as! String as NSObject,
//      "last_name": data.object(forKey: "last_name") as! String as NSObject]
//    params["email"] = data.object(forKey: "email") as? String as? NSObject
//    params["user"] = params as NSObject
//    requestLogin(params, success: success, next: next)
//  }


