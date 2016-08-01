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
import RandomKit
import SwiftRandom
import Fakery

public let faker = Faker()

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

public class Lorem: LoremIpsum {

  public class func message() -> String {
    return Lorem.array(1, upper: 5).map({ _ in Randoms.randomFakeConversation() }).joinWithSeparator(" ")
  }

  public class func array(lower: Int = 3, upper: Int = 5) -> Array<Int> {
    return Array((1...wizRandomInt(lower, upper: upper)))
  }

  //  class func time() -> NSDate {
  //
  //  }
  //
  //  override class func date() -> NSDate {
  //    return NSDate().addDay(wizRandomInt(-30, upper: 30)).addHour(wizRandomInt(-10, upper: 10))
  //  }

  public class func user() -> String {
    return K.Sample.users.randomItem()
  }

  public class func bool() -> Bool {
    let bool = (wizRandomInt() % 2) == 1
    return bool
  }

  public class func tel() -> String {
    return "0986168168"
  }

  public class func image() -> String {
    return randomImageName()
  }

  public class func imageUrl() -> String {
    return randomImageUrl()
  }

  public class func address() -> String {
    return faker.address.streetAddress()
  }

  public class func city() -> String {
    return faker.address.city()
  }

  public class func area() -> String {
    return faker.address.country()
  }

  public class func creditCart() -> String {
    return "．．．．\(wizRandomInt(1999, upper: 9999))"
  }

  public class func postcode() -> String {
    return faker.address.postcode()
  }

  public class func token() -> String {
    return String.random()
  }

  public class func password() -> String {
    return String.random()
  }

  private class func condition() -> Bool {
    return _isSimulator() //|| !_isSimulator()
  }

  public class func string() -> String {
    return name()
  }

  public class func int() -> Int {
    if condition() {
      return wizRandomInt()
    } else {
      return 0
    }
  }

  public class func phone() -> String {
    return faker.phoneNumber.phoneNumber()
  }

  override public class func name() -> String {
    if condition() {
      return super.name()
    } else {
      return ""
    }
  }

}

extension UIGestureRecognizer {
  public func indexPathInTableView(tableView: UITableView) -> NSIndexPath {
    let position = view?.convertPoint(CGPointZero, toView: tableView)
    return tableView.indexPathForRowAtPoint(position!)!
  }
}

extension String {


  public func split() -> [String] {
    return self.characters.split{$0 == " "}.map(String.init)
  }

  public func formatedAs(format: String = "%02d") -> String {
    return NSString.localizedStringWithFormat(format, self) as String
  }

  public func toNSMutableAttributedString() -> NSMutableAttributedString {
    do {
      let result = try NSMutableAttributedString(data: dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
      return result
    } catch {
      return NSMutableAttributedString()
    }
  }

  public func toAttributedString() -> NSAttributedString {
    return toHtml()
  }

  public func toHtml() -> NSAttributedString {
    do {
      let result = try NSAttributedString(data: dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
      return result
    } catch {
      return NSAttributedString()
    }
  }

  public func taggedWith(tag: String = "div") -> String! {
    let headTag = "<\(tag)>"
    let footTag = "</\(tag)>"
    return "\(headTag)\(self)\(footTag)"
  }

  public func toDate() -> NSDate {
    let df = NSDateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:SS +0000"
    return df.dateFromString(self.stringByReplacingOccurrencesOfString("T", withString: " "))!
  }
}

extension Float {
  public var int: Int { get { return Int(self) } }
}

extension LoremIpsum {

  public class func paragraphsAsHtmlWithNumber(numberOfParagraphs: Int) -> String! {
    var paragraphs = ""
    for _ in (1...numberOfParagraphs) {
      paragraphs += self.paragraph().taggedWith("p")
    }
    return paragraphs
  }

  public class func sentencesAsArrayWithNumber(numberOfSentences: Int) -> [String] {
    var sentences = [String]()
    for _ in 1...numberOfSentences {
      sentences.append(self.sentence())
    }
    return sentences
  }
}

extension NSBundle {

  public var releaseVersionNumber: String? {
    return self.infoDictionary?["CFBundleShortVersionString"] as? String
  }

  public var buildVersionNumber: String? {
    return self.infoDictionary?["CFBundleVersion"] as? String
  }
}

extension NSNumber {

  public func asDecimal() -> String {
    let f = NSNumberFormatter()
    f.numberStyle = NSNumberFormatterStyle.DecimalStyle
    return f.stringFromNumber(self)!
  }

}

extension Int {
  public func asDecimal() -> String {
    return NSNumber(integer: self).asDecimal()
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

  public var dollar: String {
    get {
      return "$\(NSNumber(integer: self).asDecimal())"
    }
  }
}

extension NSDate{

  public class func Parse(dateString:String!)->NSDate?{
    if dateString == nil {
      return nil
    }

    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    if let date = dateFormatter.dateFromString(dateString) {
      return date
    }

    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    if let date = dateFormatter.dateFromString(dateString) {
      return date
    }

    dateFormatter.dateFormat = "yyyy/MM/dd"
    if let date = dateFormatter.dateFromString(dateString) {
      return date
    }
    return nil
  }

  public func Hour()->String{
    let hour = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: self).hour
    return String(format: "%02d", hour)
  }

  public func Minute()->String{
    let minute = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: self).minute
    return String(format: "%02d", minute)
  }

  public func Day()->String{
    let day = NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: self).day
    return String(format: "%02d", day)
  }

  public func Week()->String{
    let Weekday = NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday, fromDate: self).weekday
    let map = ["","日","一","二","三","四","五","六"]

    return map[Weekday]
  }

  public func Month()->String{
    let month = NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: self).month
    //let map = ["","1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]

    return String(format: "%02d", month)
  }

  public func Year()->String{
    let year = NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: self).year
    return "\(year)"
  }

  public func toLongString()->String{
    if self == "" { return "" }
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
    return dateFormatter.stringFromDate(self)
  }

  public func toShortString()->String{
    if self == "" { return "" }
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    return dateFormatter.stringFromDate(self)
  }

  public func toString()->String{
    if self == "" { return "" }
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
    return dateFormatter.stringFromDate(self)
  }

  public func toNormalString()->String{
    if self == "" { return "" }
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "MM/dd HH:mm"
    return dateFormatter.stringFromDate(self)
  }

  public func addMonths(month:Int)->NSDate{
    let calendar = NSCalendar.currentCalendar()
    let offsetComponents = NSDateComponents()
    offsetComponents.month = month
    return calendar.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions())!
  }

  public func addSecond(sec:Int)->NSDate{
    let calendar = NSCalendar.currentCalendar()
    let offsetComponents = NSDateComponents()
    offsetComponents.second = sec
    return calendar.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions())!
  }

  public func addHour(hour:Int)->NSDate{
    let calendar = NSCalendar.currentCalendar()
    let offsetComponents = NSDateComponents()
    offsetComponents.hour = hour
    return calendar.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions())!
  }

  public func addDay(day:Int)->NSDate{
    let calendar = NSCalendar.currentCalendar()
    let offsetComponents = NSDateComponents()
    offsetComponents.day = day
    return calendar.dateByAddingComponents(offsetComponents, toDate: self, options: NSCalendarOptions())!
  }

  public func firstDateOfMonth(calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
    let components = calendar.components(
      [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
      , fromDate: self)
    components.day = 1

    return calendar.dateFromComponents(components)!
  }

  public func lastDateOfMonth(calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
    let components = calendar.components(
      [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
      , fromDate: self)
    components.day = 0
    components.month = components.month + 1

    return calendar.dateFromComponents(components)!
  }

  public func beginningOfDay(calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
    let components = calendar.components(
      [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
      , fromDate: self)
    //components.hour = 0

    return calendar.dateFromComponents(components)!
  }

  public func dateWithDay(day:Int , calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
    let components = calendar.components(
      [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
      , fromDate: self)
    components.day = day

    return calendar.dateFromComponents(components)!
  }

  public func nextFirstDateOfMonth(calendar:NSCalendar! = NSCalendar.currentCalendar())->NSDate{
    let components = calendar.components(
      [NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day]
      , fromDate: self)
    components.day = 1
    components.month = components.month + 1

    return calendar.dateFromComponents(components)!
  }

  public func yearsFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(NSCalendarUnit.Year, fromDate: date, toDate: self, options: []).year
  }
  public func monthsFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(NSCalendarUnit.Month, fromDate: date, toDate: self, options: []).month
  }
  public func weeksFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(NSCalendarUnit.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
  }
  public func daysFrom(date:NSDate) -> Int{

    let fromDay = NSDate.Parse(date.toShortString())!
    let toDay = NSDate.Parse(self.toShortString())!
    return NSCalendar.currentCalendar().components(NSCalendarUnit.Day, fromDate: fromDay, toDate: toDay, options: []).day
  }
  public func hoursFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date, toDate: self, options: []).hour
  }
  public func minutesFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date, toDate: self, options: []).minute
  }
  public func secondsFrom(date:NSDate) -> Int{
    return NSCalendar.currentCalendar().components(NSCalendarUnit.Second, fromDate: date, toDate: self, options: []).second
  }
  public func offsetFrom(date:NSDate) -> String {
    if yearsFrom(date)   > 0 { return "\(yearsFrom(date))y"   }
    if monthsFrom(date)  > 0 { return "\(monthsFrom(date))M"  }
    if daysFrom(date)    > 0 { return "\(daysFrom(date))d"    }
    if hoursFrom(date)   > 0 { return "\(hoursFrom(date))h"   }
    if minutesFrom(date) > 0 { return "\(minutesFrom(date))m" }
    if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
    return ""
  }

  var datePart:NSDate{
    return self.beginningOfDay()
  }

  public func isTheSameDay(date:NSDate)->Bool{
    return self.toShortString() == date.toShortString()
  }
}

extension UIResponder {

  public func parentViewController() -> UIViewController? {
    if self.nextResponder() is UIViewController {
      return self.nextResponder() as? UIViewController
    } else {
      if self.nextResponder() != nil {
        return (self.nextResponder()!).parentViewController()
      }
      else {return nil}
    }
  }

  public func bootFrom(vc: UIViewController) -> UIWindow? {
    let window: UIWindow?  = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.backgroundColor = K.Color.body
    window!.rootViewController = vc
    window!.makeKeyAndVisible()
    return window!
  }

  public func pushServerAppID() -> String {
    return ""
  }

  public func getDeviceName() -> String {
    let name = UIDevice.currentDevice().name
    //    _log(name, title: "\(__FUNCTION__): name")
    return name
  }

 public func getDeviceToken() -> String {
   return Session.getValue(getDeviceName())!
 }

  public func saveDeviceToken(token: String, name: String) {
//    Session.setValue(name, key: token)
//    Session.setValue(token, key: name)

    //    let manager = HttpManager.getManagerWithoutCache()
    //    let url = HttpManager.requestPath("/users/0")
    //    let params = ["user[ios_device_token]": token, "user[ios_device_name]": name]
    //    manager.PUT(url, parameters: params, success: { (operation, response) -> Void in
    //      //      log(response)
    //      }) { (operation, error) -> Void in
    //        log("error: \(error.localizedDescription)")
    //    }
  }

  
//  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//    UITabBar.appearance().tintColor = K.Color.tabBar
//    UITabBar.appearance().barTintColor = K.Color.tabBarBackgroundColor
//    return true
//  }

  public func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings){
//    _logForAnyMode()
    application.registerForRemoteNotifications()
  }

  public func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
//    _logForAnyMode()
    PushServer.saveToken(pushServerAppID(), user: getDeviceName(), deviceToken: deviceToken, success: { (deviceTokenString) -> () in
      self.saveDeviceToken(PushServer.getDeviceTokenString(deviceToken), name: self.getDeviceName())
    })
  }

  public func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
//    _logForAnyMode(error.localizedDescription)
//    _logForAnyMode(error.description)
  }

  public func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  public func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  public func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  public func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  public func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

extension CollectionType {
  /// Return a copy of `self` with its elements shuffled
  public func shuffle() -> [Generator.Element] {
    var list = Array(self)
    list.shuffleInPlace()
    return list
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

  public func or(n: Int = 10) -> CGFloat {
    return CGFloat([n, Int(self)].maxElement()!)
  }

  public var em: CGFloat {
    //    _logForUIMode(screenWidth(), title: "screenWidth()")
    return self * screenWidth() / 320
  }

  public func smaller(n: CGFloat = 1) -> CGFloat {
    return self - n
  }

  public func larger(n: CGFloat = 1) -> CGFloat {
    return self + n
  }
}

extension Array {
  public func compact() -> [Element] {
    return flatMap({$0})
  }
  //  }
  //    return self.filter({ (t) -> Bool in t != "" })
  //  }
}

extension NSMutableAttributedString {

  public func setAsLink(textToFind: String, linkURL: String) -> Bool {
    let foundRange = self.mutableString.rangeOfString(textToFind)
    if foundRange.location != NSNotFound {
      self.addAttribute(NSLinkAttributeName, value: linkURL, range: foundRange)
      return true
    }
    return false
  }
}

extension UITextField {

  public func scrolledToVisible(scrollView: UIScrollView, keyboardSize: CGSize) {
    let target = superview!
    var viewRect = target.frame
    viewRect.size.height -= keyboardSize.height
    let y = target.frame.origin.y
    let scrollPoint = CGPointMake(0, y)
    scrollView.setContentOffset(scrollPoint, animated: true)
  }
}

extension UITableView {

  public func indexOfTapped(sender: UITapGestureRecognizer) -> NSIndexPath {
    return indexPathForRowAtPoint(sender.view!.convertPoint(CGPointZero, toView: self))!
  }

  public func reloadDataAndRun(completion: ()->() = {}) {
    UIView.animateWithDuration(0, animations: { self.reloadData() })
    { _ in completion() }
  }

  public func setOffsetToBottom(animated: Bool) {
    self.setContentOffset(CGPointMake(0, self.contentSize.height - self.frame.size.height), animated: true)
  }

  public func scrollToLastRow(animated: Bool) {
    if self.numberOfRowsInSection(0) > 0 {
      self.scrollToRowAtIndexPath(NSIndexPath(forRow: self.numberOfRowsInSection(0) - 1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
    }
  }

  public func styled() -> UITableView {
    estimatedRowHeight = 20.0
    rowHeight = UITableViewAutomaticDimension
    separatorStyle = .None
    return self
  }

}
