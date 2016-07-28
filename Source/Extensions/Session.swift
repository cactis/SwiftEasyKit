//
//  Session.swift
//

import Foundation

class Session {
  
  class func setToken(token: String) {
    let key = "session_token"
    setValue(token, key: key)
  }
  
  class func getToken() -> String? {
    let key = "session_token"
    return store().objectForKey(key) as? String
  }
  
  class func removeToken() {
    store().removeObjectForKey("session_token")
  }
  
  
  
  class func setValue(value: String, key: String) {
    store().setObject(value, forKey: key)
  }
  
  class func setValueObject(value: AnyObject, key: String) {
    store().setObject(value, forKey: key)
  }
  
  class func getValue(key: String) -> String? {
    return store().objectForKey(key) as? String
  }
  
  class func getValueObject(key: String) -> AnyObject? {
    return store().objectForKey(key) as AnyObject?
  }
  
  class func removeValue(key: String) {
    store().removeObjectForKey(key)
  }
  
  //  class func removeAll() {
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