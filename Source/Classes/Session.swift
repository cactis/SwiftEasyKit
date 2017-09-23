//
//  Session.swift
//

import Foundation

open class Session {

  open class func setValue(value: String, key: String) {
    store().set(value, forKey: key)
//    _logForUIMode(value as AnyObject, title: "saved \(key) key in session")
  }

  open class func setValueObject(value: AnyObject, key: String) {
    store().set(value, forKey: key)
  }

  open class func getValue(key: String) -> String? {
    return store().object(forKey: key) as? String
  }

  open class func getValueObject(key: String) -> AnyObject? {
    return store().object(forKey: key) as AnyObject?
  }

  open class func removeValue(key: String) {
    store().removeObject(forKey: key)
  }

  //  open class func removeAll() {
  //    var session: NSUserDefaults = store()
  //    var keys: Array = session.dictionaryRepresentation().keys.array
  //
  //    for key in session.dictionaryRepresentation().keys {
  //      session.removeObjectForKey(key.description)
  //    }
  //  }

  class private func store() -> UserDefaults {
    return UserDefaults.standard
  }

}
