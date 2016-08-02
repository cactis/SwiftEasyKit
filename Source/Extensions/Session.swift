//
//  Session.swift
//

import Foundation

public class Session {

  public class func setValue(value: String, key: String) {
    store().setObject(value, forKey: key)
  }

  public class func setValueObject(value: AnyObject, key: String) {
    store().setObject(value, forKey: key)
  }

  public class func getValue(key: String) -> String? {
    return store().objectForKey(key) as? String
  }

  public class func getValueObject(key: String) -> AnyObject? {
    return store().objectForKey(key) as AnyObject?
  }

  public class func removeValue(key: String) {
    store().removeObjectForKey(key)
  }

  //  public class func removeAll() {
  //    var session: NSUserDefaults = store()
  //    var keys: Array = session.dictionaryRepresentation().keys.array
  //
  //    for key in session.dictionaryRepresentation().keys {
  //      session.removeObjectForKey(key.description)
  //    }
  //  }

  class private func store() -> NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
  }

}
