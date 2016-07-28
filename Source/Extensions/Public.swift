//
//  Public.swift
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

public func _autoRunForUIMode(funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  if _isUIMode() {
    _autoRun(funcName, fileName: fileName, run: run)
  }
}

private func _autoRun(funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line, run: () -> ()) {
  print("=== autoRun in \(Development.mode): \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
  NSObject()._delayedJob { () -> () in
    run()
  }
}

public func runInDeviceMode(run: () -> (), elseRun: () -> () = {}) { if !_isSimulator() { run() } else { elseRun() } }

public func _isSimulator() -> Bool { return TARGET_OS_SIMULATOR != 0 || Development.simulator == true }

public func _logError(err: NSError!) {
  _log(err.localizedDescription, title: "err")
}

public func _logClear() { (0...50).forEach { _ in print("\n") }}

public func _logForAnyMode(obj: AnyObject = "", title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForUIMode(obj, title: title, funcName: funcName, fileName: fileName)
  _logForAPIMode(obj, title: title, funcName: funcName, fileName: fileName)
}

public func _logForUIMode(title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForUIMode("", title: title, funcName: funcName, fileName: fileName)
}

public func _logForUIMode(obj: AnyObject, title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if _isUIMode() {
    _log(obj, title: title, funcName: funcName, fileName: fileName)
  }
}

public func _logForAPIMode(title: String = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _logForAPIMode("", title: title, funcName: funcName, fileName: fileName)
}

public func _logForAPIMode(obj: AnyObject, title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  if _isAPIMode() {
    _log(obj, title: title, funcName: funcName, fileName: fileName)
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

private func _log(obj: AnyObject, title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  let time = NSDate()
  print("")
  print("=== \(title) in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
  switch obj.self {
  case is String, is Int, is [String], is [Int]:
    print(obj)
  default:
    print((obj as! NSObject).asJSON())
  }
  print("=== \(title) in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
  print(time)
  print("")
}

private func _log(obj: Int, title: AnyObject = "", funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  _log("\(obj)", title: title, funcName: funcName, fileName: fileName)
}

public func _disableSimulatorMode(status: Bool = true, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  print("")
  print("=== call _disableSimulatorMode in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
  Development.simulator = !status
}

public func _enableSimulatorMode(status: Bool = true, funcName: String = #function, fileName: String = #file, column: Int = #column, line: Int = #line) {
  print("")
  print("=== call _enableSimulatorMode in \(funcName) of \((fileName as NSString).lastPathComponent) \(line):\(column) ===")
  Development.simulator = status
}

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

public func screenHeight() -> CGFloat {
  return UIScreen.mainScreen().bounds.height
}

public func randomBlock(n: Int = 15, m: Int = 30, run: () -> ()) {
  (0...wizRandomInt(n, upper: m)).forEach { (i) -> () in
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

public func getIcon(name: FontAwesome, options: NSDictionary = NSDictionary(), inset: CGFloat = 0) -> UIImage {
  let color = options["color"] as? UIColor ?? K.Color.button.darker()
  let size = options["size"] as? CGFloat ?? K.BarButtonItem.size //* 4
  let backgroundColor = options["backgroundColor"] as? UIColor ?? UIColor.clearColor()
  var icon = UIImage.fontAwesomeIconWithNameWithInset(name, textColor: color, size: CGSize(width: size, height: size), backgroundColor: backgroundColor, inset: inset)
  icon = icon.imageWithRenderingMode(.AlwaysOriginal)
  return icon
}

public func delayedJob(seconds: Double, todo: () -> ()) {
  let indicator = UIActivityIndicatorView()
  indicator.startAnimating()
  //    indicator.center = UIScreen.mainScreen().bounds.center
  let delay = seconds * Double(NSEC_PER_SEC)
  let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
  dispatch_after(time, dispatch_get_main_queue()) {
    todo()
    indicator.stopAnimating()
  }
}

public func verticalLayout(blocks: [UIView], heights: [CGFloat], padding: CGFloat = 0, xPad: CGFloat = 0, yPad: CGFloat = 0) {
  var prevBlock: UIView!
  blocks.forEach { (block) in
    let index = blocks.indexOf(block)!
    switch index {
    case 0:
      block.anchorAndFillEdge(.Top, xPad: xPad, yPad: yPad, otherSize: heights[0])
    default:
      block.alignUnder(prevBlock, matchingLeftAndRightWithTopPadding: padding, height: heights[index])
    }
    prevBlock = block
  }
}