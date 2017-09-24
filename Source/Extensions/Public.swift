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
//// import RandomKit
import SwiftRandom
import KeychainSwift

import EZLoadingActivity
//import SwiftSpinner

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

public func prompt(_ msgs: [String], runWith: (_ msg: String) -> String = { msg in return msg }, style: PromptType = PromptType()) {
  prompt(runWith(msgs.randomItem()!), style: style)
}

public func prompt(_ msg: String?, style: PromptType = PromptType(), onTapped: @escaping () -> () = {}) {
  //  _logForUIMode(msg)
  if !Development.prompt { return }
  let message = msg ?? "(異常錯誤：未被追蹤到的錯誤。)"
//  UIApplication.shared.statusBarHidden = true
  UIApplication.shared.isStatusBarHidden = true
  let notification = UIButton()
  let block = DefaultView()
  let label = UILabel()

  block.backgroundColored(style.bgColor).shadowed().radiused(3).bordered(0.5, color: K.Color.text.lighter().cgColor)
  label.styled().colored(style.color).texted(message).multilinized().centered().sized(12.em)
//  label._coloredWithSuperviews()
  notification.layout([block.layout([label])])

  let xPad = 10.em
  var yPad = 15.em

  let w = screenWidth() - 4 * xPad
  let h = label.getHeightBySizeThatFitsWithWidth(w)

  label.frame = CGRect(x: xPad, y: yPad, width: w, height: h)
  block.frame = CGRect(x: xPad, y: 0, width: w + 2 * xPad, height: label.bottomEdge() + yPad)

  label.isUserInteractionEnabled = false
  block.isUserInteractionEnabled = false

  //  print(label.height, label.textHeight() + 4)
  if label.linesCount > 1 {
    label.aligned(.left)
  }

  if let v = window() {
    //    _logForUIMode(true)
    v.addSubview(notification)
    notification.frame = CGRect(x: 0, y: -1 * screenHeight(), width: screenWidth(), height: screenHeight())

    UIView().animate(onComplete: {
      notification.frame = CGRect(x: 0, y: statusBarHeight(), width: screenWidth(), height: screenHeight())
    })

    delayedJob(5, withIndicator: false, todo: {
      notification.tapped()
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

public func openControllerWithDelegate(_ delegate: UIViewController, vc: UIViewController, style: UIModalTransitionStyle = .coverVertical, run: @escaping () -> ()) {
  vc.modalTransitionStyle = style
  let nv = UINavigationController()
  nv.pushViewController(vc, animated: true)
  delegate.present(nv, animated: true, completion: { () -> Void in
    run()
  })
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

public func _autoRunInDevice(_ funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  if !_isSimulator() {
    autoRun(funcName, fileName: fileName, run: run)
  }
}

private func autoRun(_ funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
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

private func _autoRun(_ funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: @escaping () -> ()) {
  if Development.autoRun {
    print("=== autoRun in \(Development.mode): \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
//    NSObject()._delayedJob { () -> () in
      run()
//    }
  }
}

public func runInDeviceMode(_ run: () -> (), elseRun: () -> () = {}) { if !_isSimulator() { run() } else { elseRun() } }


public func _isWho(_ who: String) -> Bool { return _isSimulator() && who == Development.developer }
public func _isSimulator() -> Bool { return TARGET_OS_SIMULATOR != 0 || Development.setDeviceAsSimulator == true }

public func _logError(_ err: NSError!) {
  _log(err.localizedDescription as AnyObject, title: "err" as AnyObject)
}

public func _logClear() { (0...50).forEach { _ in print("\n") }}

public func _logForAnyMode(_ obj: AnyObject? = "" as AnyObject, title: AnyObject = "" as AnyObject, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForUIMode(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  _logForAPIMode(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logFor(_ who: String, obj: AnyObject?, title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if who == Development.developer {
    _logForUIMode(obj, title: title as AnyObject, funcName: funcName, fileName: fileName, column: column, line: line)
  }
}

public func _logForUIMode(_ title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForUIMode("" as AnyObject, title: title as AnyObject, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logForUIMode(_ obj: AnyObject?, title: AnyObject = "" as AnyObject, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if _isUIMode() {
    _log(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  }
}

public func _logForAPIMode(_ title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForAPIMode("" as AnyObject, title: title as AnyObject, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logForAPIMode(_ obj: AnyObject?, title: AnyObject = "" as AnyObject, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
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

private func _log(_ obj: AnyObject?, title: AnyObject = "" as AnyObject, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  let time = NSDate()
  print("")
  print("|=== \"\(title)\" in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
  //  switch obj.self {
  //  case is String, is Int, is [String], is [Int]:
  //    print(obj)
  //  default:
  //    print((obj as! NSObject).asJSON())
  //  }
  if let _ = obj { print(obj!) } else { print(obj) }
  print("=== \"\(title)\" in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===|")
  print("\(time) in \(Development.mode) mode")
  print("")
}

private func _log(obj: Int, title: AnyObject = "" as AnyObject, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
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
    delegate.parentViewController()?.present(alert, animated: true, completion: onCompletion)
  }
}

public func dial(_ number: String) {
  UIApplication.shared.openURL(NSURL(string: number)! as URL)
}

//public func openMap(locaiton)

public func delayedJob(_ todo: () -> ()) {
  delayedJob(0.5, todo: todo)
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

public func randomBlock(_ n: Int = 15, m: Int = 30, run: () -> ()) {
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
  let color = options["color"] as? UIColor ?? K.Color.button.darker()
  let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clear
  var icon = UIImage.fontAwesomeIconWithNameWithInset(name: name, textColor: color, size: CGSize(width: size, height: size), backgroundColor: backgroundColor, inset: inset)
  icon = icon.withRenderingMode(.alwaysOriginal)
  return icon
}

public func getIcon(_ name: FontAwesome, options: NSDictionary = NSDictionary(), inset: CGFloat = 0) -> UIImage {
  var opts: NSMutableDictionary = options.mutableCopy() as! NSMutableDictionary
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

public func delayedJob(_ seconds: Double, withIndicator: Bool = true, todo: () -> ()) {
  todo()
//  var indicator = UIView()
//  if withIndicator { indicator =  indicatorStart() }
//  let delay = seconds * Double(NSEC_PER_SEC)
//  let time = DispatchTime.now(dispatch_time_t(DISPATCH_TIME_NOW), Int64(delay))
//  dispatch_after(time, dispatch_get_main_queue()) {
//    todo()
//    indicatorEnd(indicator: indicator)
//  }
}

public func currentView() -> UIView? {
  return window()?.subviews.last
}

public func window() -> UIWindow? {
  return appDelegate().window
}

public func appDelegate() -> DefaultAppDelegate {
  return UIApplication.shared.delegate as! DefaultAppDelegate
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
