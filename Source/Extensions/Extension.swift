//
//  Extension.swift

import Foundation
//import Log
import MapKit
import LoremIpsum
//import Sugar
import FontAwesome_swift
//import FontAwesomeKit
//import OdyiOS
import Neon
//import RandomKit
import SwiftRandom
import Fakery

public let faker = Faker()

public extension UIWindow {
  public var visibleViewController: UIViewController? {
    return UIWindow.getVisibleViewControllerFrom(self.rootViewController)
  }

  public static func getVisibleViewControllerFrom(_ vc: UIViewController?) -> UIViewController? {
    if let nc = vc as? UINavigationController {
      return UIWindow.getVisibleViewControllerFrom(nc.visibleViewController)
    } else if let tc = vc as? UITabBarController {
      return UIWindow.getVisibleViewControllerFrom(tc.selectedViewController)
    } else {
      if let pvc = vc?.presentedViewController {
        return UIWindow.getVisibleViewControllerFrom(pvc)
      } else {
        return vc
      }
    }
  }
}

extension NSMutableDictionary {
  public func jsonString(onSuccess: (_ string: NSString) -> ()) {
    do {
      let data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
      let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
      onSuccess(string!)
    } catch {
      print(error)

    }
  }
}

//extension AppDelegate: UITabBarControllerDelegate {
//
//  func enableTabBarController(viewControllers: [UIViewController]!, titles: [String]!, images: [UIImage], selectedImages: [UIImage] = []) -> (UIWindow?, UITabBarController!) {
//    var _selectedImages = [UIImage]()
//    if selectedImages.count > 0 {
//      _selectedImages = selectedImages
//    } else {
//      _selectedImages = images
//    }
//    let tabBarViewController = UITabBarController()
//    let vcs = viewControllers.map({ $0.embededInNavigationController() })
//    for (index, vc) in vcs.enumerate() {
//      vc.tabBarItem = UITabBarItem(title: titles[index], image: images[index], selectedImage: _selectedImages[index])
//      viewControllers[index].titled(titles[index])
//    }
//    tabBarViewController.viewControllers = vcs
//    tabBarViewController.delegate = self
//    return (bootFrom(tabBarViewController), tabBarViewController)
//  }
//}

extension UIImagePickerController {
  public func getImageFromInfo(_ info: [String: AnyObject]) -> UIImage? {
    dismiss(animated: true, completion: nil)
    let mediaType = info[UIImagePickerControllerMediaType] as! String
    if !mediaType.isEmpty {
      let image = info[UIImagePickerControllerOriginalImage] as! UIImage
      return image
    } else {
      return nil
    }
  }
}

open class Lorem: LoremIpsum {

  open class func message() -> String {
    return Lorem.array(1, upper: 5).map({ _ in Randoms.randomFakeConversation() }).join(" ")
  }

  open class func array(_ lower: Int = 3, upper: Int = 5) -> Array<Int> {
    return Array((1...wizRandomInt(lower, upper: upper)))
  }

  //  class func time() -> NSDate {
  //
  //  }
  //
  //  override class func date() -> NSDate {
  //    return NSDate().addDay(wizRandomInt(-30, upper: 30)).addHour(wizRandomInt(-10, upper: 10))
  //  }

  open class func user() -> String {
    return K.Sample.users.randomItem()!
  }

  open class func bool() -> Bool {
    let bool = (wizRandomInt() % 2) == 1
    return bool
  }

  open class func tel() -> String {
    return "0986168168"
  }

  open class func image() -> String {
    return randomImageName()
  }

  open class func imageUrl() -> String {
    return randomImageUrl()
  }

  open class func address() -> String {
    return faker.address.streetAddress()
  }

  open class func city() -> String {
    return faker.address.city()
  }

  open class func area() -> String {
    return faker.address.country()
  }

  open class func creditCart() -> String {
    return "．．．．\(wizRandomInt(1999, upper: 9999))"
  }

  open class func postcode() -> String {
    return faker.address.postcode().split("-").first!
  }

  open class func token() -> String {
    return random()
  }

  open class func random() -> String {
    return "ABC"
  }

  open class func password() -> String {
    return random()
  }

  private class func condition() -> Bool {
    return _isSimulator() //|| !_isSimulator()
  }

  open class func string() -> String {
    return name()
  }

  open class func int(_ lower: Int = 0, upper: Int = 9999) -> Int {
    if condition() {
      return wizRandomInt(lower, upper: upper)
    } else {
      return 0
    }
  }

  open class func phone() -> String {
    return "\(wizRandomInt(11111, upper: 99999))\(wizRandomInt(11111, upper: 99999))"
  }

  override open class func name() -> String {
    //    if condition() {
    return super.name()
    //    } else {
    //      return ""
    //    }
  }

}

extension UIGestureRecognizer {
//  public func indexPathInTableView(_ tableView: UITableView) -> NSIndexPath {
//    let position = view?.convert(.zero, to: tableView)
//    return tableView.indexPathForRowAtPoint(position!)! as NSIndexPath
//  }
}


extension String {

  subscript (r: Range<Int>) -> String {
    get {
      let startIndex =  self.index(self.startIndex, offsetBy: r.lowerBound)
      let endIndex = self.index(startIndex, offsetBy: r.upperBound - r.lowerBound)
      return String(self[startIndex...endIndex])
    }
  }

//
//  subscript (r: Range<Int>) -> String {
//    get {
//      let startIndex = self.startIndex.advanced(by: r.lowerBound)
//      let endIndex = startIndex.advanced(by: r.upperBound - r.lowerBound)
//
//      return self[Range(startIndex, in: endIndex)]
//    }
//  }


  public func updateNumberWrappedIn(_ number: AnyObject) -> String {
    let prefix = split("(")[0]
    if Int(number as! NSNumber) > 0 {
      return prefix + "(\(number))"
    } else {
      return prefix
    }
  }

  public func length() -> Int {
    return self.lengthOfBytes(using: String.Encoding.utf8)
  }

  public func deDecimal() -> Int? {
    if self == "" { return nil }
    return Int(self.gsub(",", withString: ""))!
  }

  public func gsub(_ target: String, withString: String = "") -> String {
    return replacingOccurrences(of: target, with: withString)
//    return stringByReplacingOccurrencesOfString(target, withString: withString)
  }

  public func safeForURL() -> String {
    return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//    return stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
  }

  public func randomTimes(_ n: Int = 1, m: Int = 3) -> String {
    var t = self
    randomBlock(n, m: m) {
      t += t
    }
    return t
  }

  public func split(_ char: Character = " ") -> [String] {
    return self.characters.split{$0 == char}.map(String.init)
  }

  public func formatedAs(_ format: String = "%02d") -> String {
    return NSString.localizedStringWithFormat(format as NSString, self) as String
  }

  public func toJOSN() -> [String:AnyObject]? {
    if let data = data(using: String.Encoding.utf8) {
      do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String : AnyObject] //as? [String: AnyObject]
      } catch let error as NSError {
        print(error)
      }
    }
    return nil
  }

  public func toNSMutableAttributedString() -> NSMutableAttributedString? {
//    do {
//      let result = try NSMutableAttributedString(data: data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSAttributedString.DocumentType], documentAttributes: nil)
//      return result
//    } catch {
//      return NSMutableAttributedString()
//    }
    return NSMutableAttributedString(string: self)
  }

  public func toAttributedString() -> NSAttributedString? {
    return toHtml()
  }

  public func toHtmlWithStyle(_ css: String) -> NSAttributedString? {
    let html = "<html><head><style>\(css)</style></head><body>\(self)</body></html>"
    return html.toHtml()
  }

  public func toHtml() -> NSAttributedString? {
//    do {
//      let result = try NSAttributedString(data: data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
//      return result
//    } catch {
//      return NSAttributedString()
//    }
//    var html2AttributedString: NSAttributedString? {
      do {
        return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
      } catch {
        print("error: ", error)
        return nil
      }
//    }
//    var html2String: String {
//      return html2AttributedString?.string ?? ""
//    }
  }

  public func taggedWith(_ tag: String = "div") -> String! {
    let headTag = "<\(tag)>"
    let footTag = "</\(tag)>"
    return "\(headTag)\(self)\(footTag)"
  }

  public func toDate(_ dateFormat: String = K.Api.timeFormat) -> NSDate? {
    if self == "" { return nil }
    let df = DateFormatter()
    df.dateFormat = dateFormat
    return df.date(from: self)! as NSDate
  }
}

extension Float {
  public var int: Int { get { return Int(self) } }
}

extension LoremIpsum {

  open class func paragraphsAsHtmlWithNumber(_ numberOfParagraphs: Int) -> String! {
    var paragraphs = ""
    for _ in (1...numberOfParagraphs) {
      paragraphs += self.paragraph().taggedWith("p")
    }
    return paragraphs
  }

  open class func sentencesAsArrayWithNumber(_ numberOfSentences: Int) -> [String] {
    var sentences = [String]()
    for _ in 1...numberOfSentences {
      sentences.append(self.sentence())
    }
    return sentences
  }
}

extension Bundle {

  public var releaseVersionNumber: String? {
    return self.infoDictionary?["CFBundleShortVersionString"] as? String
  }

  public var buildVersionNumber: String? {
    return self.infoDictionary?["CFBundleVersion"] as? String
  }
}

extension NSNumber {

  public func asDecimal() -> String? {
    //    guard self != 0 else { return "" }
    let f = NumberFormatter()
    f.numberStyle = .decimal
    return f.string(from: self)!
  }

}

extension UInt {
  var string: String? { get { return String(self) } }
}

extension Int {
  public func asDecimal() -> String? {
    //    guard self != 0 else { return nil }
    return NSNumber(value: self).asDecimal()
  }

  public var string: String {
    return String(self)
  }

  public var float: Float {
    get { return Float(self) }
  }

  public var cgFloat: CGFloat {
    get { return CGFloat(self) }
  }

  public var em: CGFloat {
    get { return CGFloat(self).em }
  }

  public var dollar: String? {
    get {
      guard self != 0 else { return nil }
      return "$\(NSNumber(value: self).asDecimal()!)"
    }
  }
}

extension Date {
   public func timeAgo() -> String {
    return "!!!"
   }

   public func toString(_ dateFormat: String = K.Api.timeFormat) -> String{
   if self == nil { return "" }
   let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = dateFormat
  return dateFormatter.string(from: self as Date)
 }
}

extension NSDate{
//
//  open class func Parse(_ dateString:String!)->NSDate?{
//    if dateString == nil {
//      return nil
//    }
//
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//    if let date = DateFormatter.dateFromString(dateString) {
//      return date
//    }
//
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//    if let date = dateFormatter.date(from: dateString) {
//      return date as NSDate
//    }
//
//    dateFormatter.dateFormat = "yyyy/MM/dd"
//    if let date = dateFormatter.date(from: dateString) {
//      return date as NSDate
//    }
//    return nil
//  }
//
//  public func Hour()->String{
//    let hour = NSCalendar.current.components(NSCalendar.Unit.hour, fromDate: self as Date).hour
//    return String(format: "%02d", hour)
//  }
//
//  public func Minute()->String{
//    let minute = NSCalendar.current.components(NSCalendar.Unit.minute, fromDate: self as Date).minute
//    return String(format: "%02d", minute)
//  }
//
//  public func Day()->String{
//    let day = NSCalendar.current.components(NSCalendar.UnitNSCalendar.Unit.day, fromDate: self as Date).day
//    return String(format: "%02d", day)
//  }
//
//  public func Week()->String{
//    let Weekday = NSCalendar.current.components(NSCalendar.Unit.weekday, fromDate: self as Date).weekday
//    let map = ["","日","一","二","三","四","五","六"]
//
//    return map[Weekday]
//  }
//
//  public func Month()->String{
//    let month = NSCalendar.current.components(NSCalendar.Unit.month, fromDate: self as Date).month
//    //let map = ["","1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
//
//    return String(format: "%02d", month)
//  }
//
//  public func Year()->String{
//    let year = NSCalendar.current.components(NSCalendar.Unit.year, fromDate: self as Date).year
//    return "\(year)"
//  }
//
//  public func toLongString()->String{
//    if self == "" { return "" }
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = K.Api.timeFormat// "yyyy/MM/dd HH:mm:ss"
//    return dateFormatter.stringFromDate(self as Date)
//  }
//
//  public func toShortString()->String{
//    if self == "" { return "" }
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "yyyy/MM/dd"
//    return dateFormatter.stringFromDate(self)
//  }
//
 public func toString(_ dateFormat: String = K.Api.timeFormat) -> String{
   if self == nil { return "" }
   let dateFormatter = DateFormatter()
   dateFormatter.dateFormat = dateFormat
  return dateFormatter.string(from: self as Date)
 }
//
//  public func toNormalString()->String{
//    if self == "" { return "" }
//    let dateFormatter = DateFormatter()
//    dateFormatter.dateFormat = "MM/dd HH:mm"
//    return dateFormatter.string(from: self as Date as Date)
//  }
//
//  public func addMonths(_ month:Int)->NSDate{
//    let calendar = NSCalendar.current
//    let offsetComponents = NSDateComponents()
//    offsetComponents.month = month
//    return calendar.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendar.Options())!
//  }
//
//  public func addSecond(_ sec:Int)->NSDate{
//    let calendar = NSCalendar.current
//    let offsetComponents = NSDateComponents()
//    offsetComponents.second = sec
//    return calendar.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendar.Options())!
//  }
//
//  public func addHour(_ hour:Int)->NSDate{
//    let calendar = NSCalendar.current
//    let offsetComponents = NSDateComponents()
//    offsetComponents.hour = hour
//    return calendar.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendar.Options())!
//  }
//
//  public func addDay(_ day:Int)->NSDate{
//    let calendar = NSCalendar.current
//    let offsetComponents = NSDateComponents()
//    offsetComponents.day = day
//    return calendar.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendar.Options())!
//  }
//
//  public func firstDateOfMonth(_ calendar:NSCalendar! = NSCalendar.current)->NSDate{
//    var components = calendar.components(
//      [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
//      , from: self as Date)
//    components.day = 1
//
//    return calendar.dateFromComponents(components)! as NSDate
//  }
//
//  public func lastDateOfMonth(_ calendar:NSCalendar! = NSCalendar.current)->NSDate{
//    var components = calendar.components(
//      [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
//      , from: self as Date)
//    components.day = 0
//    components.month = components.month + 1
//
//    return calendar.dateFromComponents(components)! as NSDate
//  }
//
//  public func beginningOfDay(_ calendar:NSCalendar! = NSCalendar.current)->NSDate{
//    let components = calendar.components(
//      [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
//      , from: self as Date)
//    //components.hour = 0
//
//    return calendar.dateFromComponents(components)! as NSDate
//  }
//
//  public func dateWithDay(_ day:Int , calendar:NSCalendar! = NSCalendar.current)->NSDate{
//    let components = calendar.components(
//      [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
//      , fromDate: self as Date)
//    components.day = day
//
//    return calendar.dateFromComponents(components)!
//  }
//
//  public func nextFirstDateOfMonth(_ calendar:NSCalendar! = NSCalendar.current)->NSDate{
//    let components = calendar.components(
//      [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day]
//      , fromDate: self as Date)
//    components.day = 1
//    components.month = components.month + 1
//
//    return calendar.dateFromComponents(components)!
//  }
//
//  public func yearsFrom(_ date:NSDate) -> Int{
//    return NSCalendar.current.components(NSCalendar.Unit.year, fromDate: date, toDate: self, options: []).year
//  }
//  public func monthsFrom(_ date:NSDate) -> Int{
//    return NSCalendar.current.components(NSCalendar.Unit.month, fromDate: date, toDate: self, options: []).month
//  }
//  public func weeksFrom(_ date:NSDate) -> Int{
//    return NSCalendar.current.components(NSCalendar.Unit.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
//  }
//  public func daysFrom(_ date:NSDate) -> Int{
//
//    let fromDay = NSDate.Parse(date.toShortString())!
//    let toDay = NSDate.Parse(self.toShortString())!
//    return NSCalendar.current.components(NSCalendar.Unit.day, fromDate: fromDay, toDate: toDay, options: []).day
//  }
//  public func hoursFrom(_ date:NSDate) -> Int{
//    return NSCalendar.current.components(NSCalendar.Unit.hour, fromDate: date, toDate: self, options: []).hour
//  }
//  public func minutesFrom(_ date:NSDate) -> Int{
//    return NSCalendar.current.components(NSCalendar.Unit.minute, fromDate: date, toDate: self, options: []).minute
//  }
//  public func secondsFrom(_ date:NSDate) -> Int{
//    return NSCalendar.current.components(NSCalendar.Unit.second, fromDate: date, toDate: self, options: []).second
//  }
//  public func offsetFrom(_ date:NSDate) -> String {
//    if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
//    if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
//    if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
//    if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
//    if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
//    if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
//    return ""
//  }
//
//  var datePart:NSDate{
//    return self.beginningOfDay()
//  }
//
//  public func isTheSameDay(_ date:NSDate)->Bool{
//    return self.toShortString() == date.toShortString()
//  }
}

extension Collection {
  /// Return a copy of `self` with its elements shuffled
  public func shuffle() -> [Iterator.Element] {
    let list = Array(self)
    return list.shuffle()
  }
}

extension Double {

  public func string() -> String {
    return "\(self)"
  }

  public var em: CGFloat {
    get {
      return CGFloat(self).em
    }
  }
}

extension CGFloat {

  public var int: Int {
    get { return Int(self) }
  }

  public func or(_ n: Int = 10) -> CGFloat {
    return CGFloat([n, Int(self)].max()!)
  }

  public var em: CGFloat {
    //    _logForUIMode(screenWidth(), title: "screenWidth()")
    return self * screenWidth() / 320
  }

  public func smaller(_ n: CGFloat = 1) -> CGFloat {
    return self - n
  }

  public func larger(_ n: CGFloat = 1) -> CGFloat {
    return self + n
  }
}

extension NSMutableAttributedString {

  public func setAsLink(_ textToFind: String, linkURL: String) -> Bool {
    let foundRange = self.mutableString.range(of: textToFind)
    if foundRange.location != NSNotFound {
      self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
      return true
    }
    return false
  }
}

extension UITextField {

  @discardableResult public func texted(_ value: String?) -> UITextField {
    if let _ = value { text = value }
    return self
  }

  public func colored(_ color: UIColor) -> UITextField {
    textColor = color
    return self
  }

  public func aligned(_ align: NSTextAlignment = .left) -> UITextField {
    textAlignment = align
    return self
  }

  public func bold() -> UITextField {
    font = UIFont.boldSystemFont(ofSize: font!.pointSize)
    return self
  }

  public func scrolledToVisible(_ scrollView: UIScrollView, keyboardSize: CGSize) {
    let target = superview!
    var viewRect = target.frame
    viewRect.size.height -= keyboardSize.height
    let y = target.frame.origin.y
    let scrollPoint = CGPoint(x: 0, y: y)
    scrollView.setContentOffset(scrollPoint, animated: true)
  }
}


extension UITableView {

  open func indexPathForView(_ view: AnyObject) -> NSIndexPath? {
    let point: CGPoint = self.convert(.zero, from: (view as! UIView))
    return self.indexPathForRow(at: point)! as NSIndexPath
  }

  open func enableRefreshControl(_ delegae: UIViewController, action: Selector) -> UITableView {
    let refreshControl = UIRefreshControl()
    addSubview(refreshControl)
    refreshControl.addTarget(delegate, action: action, for: .valueChanged)
    return self
  }

  @objc open func indexOfTapped(_ sender: UITapGestureRecognizer) -> NSIndexPath {
    return indexPathForRow(at: sender.view!.convert(.zero, to: self))! as NSIndexPath
  }

  open func reloadDataAndRun(_ completion: @escaping ()->() = {}) {
    UIView.animate(withDuration: 0, animations: { self.reloadData() })
    { _ in completion() }
  }

  open func setOffsetToBottom(_ animated: Bool) {
    self.setContentOffset(CGPoint(x: 0, y: self.contentSize.height - self.frame.size.height), animated: true)
  }

  open func scrollToLastRow(_ animated: Bool) {
    if self.numberOfRows(inSection: 0) > 0 {
      self.scrollToRow(at: NSIndexPath(row: self.numberOfRows(inSection: 0) - 1, section: 0) as IndexPath, at: .bottom, animated: animated)
    }
  }

  @discardableResult open func styled() -> UITableView {
    estimatedRowHeight = 20.0
    rowHeight = UITableViewAutomaticDimension
    separatorStyle = .none
    return self
  }
}

extension UITableViewRowAction {
  @discardableResult open func setImage(_ icon: UIImage, size: CGSize, rect: CGRect, bgColor: UIColor) -> UITableViewRowAction {
    UIGraphicsBeginImageContext(size)
    bgColor.set()
    UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
    icon.draw(in: rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    backgroundColor = UIColor(patternImage: image!)
    return self
  }
}

extension UISwitch {

  open func resize(_ sx: CGFloat = 0.7, sy: CGFloat = 0.7) -> UISwitch {
    transform = CGAffineTransform(scaleX: sx, y: sy)
    return self
  }

}

extension UIScrollView {
  open func isAtTop(_ offset: CGFloat = 10) -> Bool {
    return contentOffset.y < offset
  }

  open func isAtBottom(_ offset: CGFloat = 10) -> Bool {
    let scrollViewHeight = frame.size.height
    let scrollContentSizeHeight = contentSize.height
    let scrollOffset = contentOffset.y
    return scrollOffset + scrollViewHeight - scrollContentSizeHeight > offset
  }
}
