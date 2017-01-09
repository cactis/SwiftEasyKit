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
import RandomKit
import SwiftRandom
import KeychainSwift

public func storeToKeyChain(value: String?, key: String!) {
  KeychainSwift().set(value!, forKey: key)
}

public func loadFromKeyChain(key: String!) -> String? {
  return KeychainSwift().get(key)
}

public class PromptType {
  public var color: UIColor!
  public var bgColor: UIColor!
  public init(color: UIColor = K.Color.Alert.color, bgColor: UIColor = K.Color.Alert.backgroundColor) {
    self.color = color
    self.bgColor = bgColor
  }
}

public func statusBarHeight() -> CGFloat {
  return UIApplication.sharedApplication().statusBarFrame.height
}

public func prompt(msgs: [String], runWith: (msg: String) -> String = { msg in return msg }, style: PromptType = PromptType()) {
  prompt(runWith(msg: msgs.randomItem()), style: style)
}

public func prompt(msg: String?, style: PromptType = PromptType()) {
  //  _logForUIMode(msg)
  if !Development.prompt { return }
  let message = msg ?? "(異常錯誤：未被追蹤到的錯誤。)"
  UIApplication.sharedApplication().statusBarHidden = true
  let notification = UIButton()
  let block = DefaultView()
  let label = UILabel()
  
  block.backgroundColored(style.bgColor).bottomBordered().shadowed().radiused(3)
  label.styled().colored(style.color).text(message).multilinized().centered().sized(12.em)
  notification.layout([block.layout([label])])
  
  let xPad = 10.em
  var yPad = 15.em
  
  let w = screenWidth() - 4 * xPad
  let h = label.getHeightBySizeThatFitsWithWidth(w)
  
  label.frame = CGRect(x: xPad, y: yPad, width: w, height: h)
  block.frame = CGRect(x: xPad, y: 0, width: w + 2 * xPad, height: label.bottomEdge() + yPad)
  
  label.userInteractionEnabled = false
  block.userInteractionEnabled = false
  
  //  print(label.height, label.textHeight() + 4)
  if label.linesCount > 1 {
    label.aligned(.Left)
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
      })
    })
  }
}


public func wizImage(name: String) -> UIImage {
  var img = UIImage(named: name)
  img = img?.imageWithRenderingMode(.AlwaysOriginal)
  return img!
}

public func randomImage(onComplete: (image: UIImage) -> ()) {
  //  Lorem.asyncPlaceholderImageWithSize(CGSize(width: 400, height: 300)) { (image) -> Void in
  //    onComplete(image: image)
  //  }
  let image = UIImage(named: randomImageName())
  onComplete(image: image!)
}

public func randomImage() -> UIImage {
  return UIImage(named: randomImageName())!
}

public func randomImageName() -> String {
  return K.Sample.images.randomItem()
}


public func randomAvatarUrl() -> String {
  let w = CGFloat(Randoms.randomInt(120, 200))
  return randomImageUrl(w, height: w)
}

public func randomImageUrl(width: CGFloat = CGFloat(Randoms.randomInt(400, 600)), height: CGFloat = CGFloat(Randoms.randomInt(300, 400))) -> String {
  return Lorem.URLForPlaceholderImageFromService(.DummyImage, withSize: CGSizeMake(width, height)).absoluteString
}

public func placeHoderImage() -> UIImage {
  return UIImage.fontAwesomeIconWithName(.ClockO, textColor: UIColor.lightGrayColor().lighter(), size: CGSize(width: 300, height: 300))
}

public func openControllerWithDelegate(delegate: UIViewController, vc: UIViewController, style: UIModalTransitionStyle = .CoverVertical, run: ()->() = {}) {
  vc.modalTransitionStyle = style
  let nv = UINavigationController()
  nv.pushViewController(vc, animated: true)
  delegate.presentViewController(nv, animated: true, completion: { () -> Void in
    run()
  })
}


public func _isUIMode() -> Bool {
  return _isSimulator() && Development.mode == "UI Design"
}

public func _isAPIMode() -> Bool {
  return _isSimulator() && Development.mode == "API Implement"
}

public func _autoRunForAPIMode(funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  if _isAPIMode() {
    _autoRun(funcName, fileName: fileName, run: run)
  }
}

public func _autoRunInDevice(funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  if !_isSimulator() {
    autoRun(funcName, fileName: fileName, run: run)
  }
}

private func autoRun(funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  print("=== autoRun in \(funcName) of \(fileName) \(line):\(column) ===")
  delayedJob { () -> () in
    run()
  }
}

public func _autoRunFor(who: String = "All", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  if who == Development.developer {
    _autoRun(funcName, fileName: fileName, run: run)
  }
}

public func _autoRunForUIMode(funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  if _isUIMode() {
    _autoRun(funcName, fileName: fileName, run: run)
  }
}

private func _autoRun(funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  if Development.autoRun {
    print("=== autoRun in \(Development.mode): \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
    NSObject()._delayedJob { () -> () in
      run()
    }
  }
}

public func runInDeviceMode(run: () -> (), elseRun: () -> () = {}) { if !_isSimulator() { run() } else { elseRun() } }


public func _isWho(who: String) -> Bool { return _isSimulator() && who == Development.developer }
public func _isSimulator() -> Bool { return TARGET_OS_SIMULATOR != 0 || Development.setDeviceAsSimulator == true }

public func _logError(err: NSError!) {
  _log(err.localizedDescription, title: "err")
}

public func _logClear() { (0...50).forEach { _ in print("\n") }}

public func _logForAnyMode(obj: AnyObject? = "", title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForUIMode(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  _logForAPIMode(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logFor(who: String, obj: AnyObject?, title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if who == Development.developer {
    _logForUIMode(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  }
}

public func _logForUIMode(title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForUIMode("", title: title, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logForUIMode(obj: AnyObject?, title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if _isUIMode() {
    _log(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  }
}

public func _logForAPIMode(title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForAPIMode("", title: title, funcName: funcName, fileName: fileName, column: column, line: line)
}

public func _logForAPIMode(obj: AnyObject?, title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if _isAPIMode() {
    _log(obj, title: title, funcName: funcName, fileName: fileName, column: column, line: line)
  }
}

private func _log(title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  print("\n")
  print("\(NSDate())")
  if title == "" {
    print("=== in \(funcName) of \(fileName) \(line):\(column) ===")
  } else {
    print("=== \(title), in \(funcName) of \(fileName) \(line):\(column) ===")
  }
  print("\n")
}

private func _log(obj: AnyObject?, title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
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

private func _log(obj: Int, title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _log("\(obj)", title: title, funcName: funcName, fileName: fileName)
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

public func alert(delegate: AnyObject, title: String, message: String, onCompletion: () -> () = {}, cancelHandler: (action: UIAlertAction) -> () = {_ in }, okHandler: (action: UIAlertAction) -> ()) {
  let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
  alert.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: cancelHandler))
  alert.addAction(UIAlertAction(title: "確定", style: .Default, handler: okHandler))
  if delegate.isKindOfClass(UIViewController) {
    delegate.presentViewController(alert, animated: true, completion: onCompletion)
  } else {
    delegate.parentViewController()?.presentViewController(alert, animated: true, completion: onCompletion)
  }
}

public func dial(number: String) {
  UIApplication.sharedApplication().openURL(NSURL(string: number)!)
}

//public func openMap(locaiton)

public func delayedJob(todo: () -> ()) {
  delayedJob(0.5, todo: todo)
}

public func wizRandomToken() -> String {
  return String.random()
}

public func wizRandomBool() -> Bool {
  return wizRandomInt() % 2 == 0
}

public func wizRandomInt(lower: Int = 0, upper: Int = 9) -> Int {
  return Randoms.randomInt(lower, upper)
}

public func wizRandomPercentage() -> Float {
  return Randoms.randomFloat(0.2, 1.0)
}

public func screenWidth() -> CGFloat {
  return UIScreen.mainScreen().bounds.width
}

public func screenCenter() -> CGPoint {
  return CGPoint(x: screenWidth() / 2, y: screenHeight() / 2)
}

public func screenHeight() -> CGFloat {
  return UIScreen.mainScreen().bounds.height
}

public func randomBlock(n: Int = 15, m: Int = 30, run: () -> ()) {
  (0...wizRandomInt(n, upper: m)).forEach { (i) -> () in
    run()
  }
}

public func runOnce(run: () -> ()) -> () {
  struct TokenContainer {
    static var token : dispatch_once_t = 0
  }
  
  dispatch_once(&TokenContainer.token) {
    run()
  }
}

public func randomImages(n: Int = 2, of: Int = 10, placeHolder: UIImage = UIImage()) -> [UIImage] {
  return (0...of - 1).map({ (i) in if i < n { return UIImage(named: randomImageName())! } else { return placeHolder }})
}

public func notNull(s: AnyObject?) -> String! {
  if (s != nil) && !(s!.isEqual(NSNull())) {
    return s as! String
  } else {
    return ""
  }
}

public func notNullDate(s: NSDate?) -> NSDate! {
  if (s != nil) && !(s!.isEqual(NSNull())) {
    return s as NSDate!
  } else {
    return NSDate()
  }
}

public func logInfo(fileName: String? = #file, funcName: String? = #function) -> [String: String] {
  return ["fileName": (fileName! as NSString).lastPathComponent, "funcName": funcName!]
}

public func barButtonItemImage(name: FontAwesome) -> UIImage {
  return getIcon(name, options: ["size": K.BarButtonItem.size])
}

public func getTabIcon(name: FontAwesome, options: NSDictionary = NSDictionary(), inset: CGFloat = 0) -> UIImage {
  let size = options["size"] as? CGFloat ?? K.BarButtonItem.size
  let color = options["color"] as? UIColor ?? K.Color.button.darker()
  let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clearColor()
  var icon = UIImage.fontAwesomeIconWithNameWithInset(name, textColor: color, size: CGSize(width: size, height: size), backgroundColor: backgroundColor, inset: inset)
  icon = icon.imageWithRenderingMode(.AlwaysOriginal)
  return icon
}

public func getIcon(name: FontAwesome, var options: NSDictionary = NSDictionary(), inset: CGFloat = 0) -> UIImage {
  var opts: NSMutableDictionary = options.mutableCopy() as! NSMutableDictionary
  let size = options["size"] as? CGFloat ?? K.BarButtonItem.size * 4
  opts["size"] = size
  return getTabIcon(name, options: opts)
}

public func getImage(iconCode iconCode: String, color: UIColor = K.Color.barButtonItem, size: CGFloat = K.BarButtonItem.size) -> UIImage {
  return UIImage.fromCode(iconCode, color: color, size: size)
}

public func getImage(name: String) -> UIImage {
  return UIImage(named: name)!
}

public func indicatorStart() -> UIView {
  let bg = UIView()
  let indicator = UIActivityIndicatorView()
  indicator.startAnimating()
  bg.frame = CGRectMake(0, 0, screenWidth(), screenHeight())
  bg.center = screenCenter()
  bg.userInteractionEnabled = false
  //  bg.backgroundColored(UIColor.blackColor().colorWithAlphaComponent(0.05))
  indicator.center = screenCenter()
  //  currentView()?.addSubview(bg)
  bg.addSubview(indicator)
  
  return bg
}

public func indicatorEnd(indicator: UIView) {
  indicator.removeFromSuperview()
  //  indicator.indicator.stopAnimating()
}

public func delayedJob(seconds: Double, withIndicator: Bool = true, todo: () -> ()) {
  var indicator = UIView()
  if withIndicator { indicator =  indicatorStart() }
  let delay = seconds * Double(NSEC_PER_SEC)
  let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
  dispatch_after(time, dispatch_get_main_queue()) {
    todo()
    indicatorEnd(indicator)
  }
}

public func currentView() -> UIView? {
  return window()?.subviews.last
}

public func window() -> UIWindow? {
  return appDelegate().window
}

public func appDelegate() -> DefaultAppDelegate {
  return UIApplication.sharedApplication().delegate as! DefaultAppDelegate
}

public func verticalLayout(blocks: [UIView], heights: [CGFloat], padding: CGFloat = 0, xPad: CGFloat = 0, yPad: CGFloat = 0, alignUnder: UIView? = nil) {
  var prevBlock: UIView!
  blocks.forEach { (block) in
    let index = blocks.indexOf(block)!
    switch index {
    case 0:
      if alignUnder != nil {
        block.alignUnder(alignUnder, matchingLeftAndRightWithTopPadding: yPad, height: heights[0])
//        block.alignUnder(alignUnder, centeredFillingWidthWithLeftAndRightPadding: xPad, topPadding: yPad, height: heights[0])
      } else {
        block.anchorAndFillEdge(.Top, xPad: xPad, yPad: yPad, otherSize: heights[0])
      }
    default:
      block.alignUnder(prevBlock, matchingLeftAndRightWithTopPadding: padding, height: heights[index])
    }
    prevBlock = block
  }
}