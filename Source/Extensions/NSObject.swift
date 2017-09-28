////
////  NSObject.swift
////
////  Created by ctslin on 5/18/16.
//
//import Foundation
//
//// https://github.com/andrei512/magic/blob/master/magic.swift
//extension NSObject {
//  open class func fromJson(jsonInfo: NSDictionary) -> Self {
//    let object = self.init()
//
//    (object as NSObject).load(jsonInfo: jsonInfo)
//
//    return object
//  }
//
//  public func load(jsonInfo: NSDictionary) {
//    for (key, value) in jsonInfo {
//      let keyName = key as! String
//      if (responds(to: NSSelectorFromString(keyName))) {
//        self.setValue(value, forKey: keyName)
//      }
//    }
//  }
//
//  public func propertyNames() -> [String] {
//    var names: [String] = []
//    var count: UInt32 = 0
//    let properties = class_copyPropertyList(classForCoder, &count)
//    for i in 0 ..< Int(count) {
//      let property: objc_property_t = !(properties![i] != nil)
//      let name: String = String.fromCString(property_getName(property))!
//      names.append(name)
//    }
//    free(properties)
//    return names
//  }
//
//  public func asJSON() -> NSDictionary {
//    var json = [String: AnyObject]()
//    let mirror = Mirror(reflecting: self)
//    mirror.children.enumerated().forEach { (index, element) in
//      if let label = element.label as String! {
//        json[label] = element.value as? AnyObject
//        //        switch element.value.dynamicType {
//        //          case is Optional<String>.Type, is Optional<Int>.Type, is String, is Int, is [String], is [Int]:
//        //            json[name] = element.value as? AnyObject
//        //        case is Optional<AnyObject>.Type: break
//        //        default:
//        //          print("element.value.dynamicType: ", element.value.dynamicType, "\nelement.label: ", element.label, "\nelement.value: ", element.value)
//        //          json[name] = (element.value as? NSObject)!.asJSON()
//        //        }
//      }
//    }
//    return json
//
//  }
//  //  public func asJSON() -> NSDictionary {
//  //    var json:Dictionary<String, AnyObject> = [:]
//  //    for name in propertyNames() {
//  //      if let value: AnyObject = valueForKey(name) {
//  //        json[name] = value
//  //      } else {
//  //        json[name] = "????"
//  //      }
//  //    }
//  //    return json
//  //  }
//
//  public typealias dispatch_cancelable_closure = (_ cancel : Bool) -> Void
//
//  public func delayedJobCancelable(seconds: TimeInterval = 1.5, closure: () -> Void) ->  dispatch_cancelable_closure? {
//    var indicator = UIActivityIndicatorView()
//    indicator.startAnimating()
//    //    indicator.center = UIScreen.main().bounds.center
//
//    func dispatch_later(clsr: () -> Void) {
//      dispatch_after(
//        dispatch_time(DISPATCH_TIME_NOW, Int64(seconds * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), clsr)
//    }
//
//    var closure: dispatch_block_t? = closure
//    var cancelableClosure: dispatch_cancelable_closure?
//
//    let delayedClosure:dispatch_cancelable_closure = { cancel in
//      if closure != nil {
//        if (cancel == false) {
//          dispatch_async(dispatch_get_main_queue(), closure!);
//          indicator.stopAnimating()
//        }
//      }
//      closure = nil
//      cancelableClosure = nil
//    }
//
//    cancelableClosure = delayedClosure
//
//    dispatch_later {
//      if let delayedClosure = cancelableClosure {
//        delayedClosure(false)
//      }
//    }
//
//    return cancelableClosure
//  }
//
//  public func cancel_delayedJob(closure: dispatch_cancelable_closure?) {
//    if closure != nil {
//      !(cancel: true)
//    }
//  }
//


