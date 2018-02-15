//
//  AppMappable.swift
//  SwiftEasyKit
//
//  Created by ctslin on 04/01/2018.
//

import ObjectMapper

open class AppMappable: Mappable {
  public var id: Int?
  public var createdAt: Date?
  public var updatedAt: Date?
  public var state: String?
//  public var status: String?
  public var alert: String?
  public var priButton: String?
  public var subButton: String?
  public var nextEvent: String?
  public var css: String?
  public var expired: Bool?

  static var TIMEFORMAT = K.Api.timeFormat
  
  open func mapping(map: Map) {    
    id <- map["id"]
    state <- map["aasm_state"]
//    status <- map["status"]
    createdAt <- (map["created_at"], DateTransform(timeFormat:  AppMappable.TIMEFORMAT))
    updatedAt <- (map["updated_at"], DateTransform(timeFormat:  AppMappable.TIMEFORMAT))
    alert <- map["alert"]
    priButton <- map["pri_button"]
    subButton <- map["sub_button"]
    nextEvent <- map["next_event"]
    css <- map["css"]
    expired <- map["expired"]
  }

  required public init?(map: Map) {}
}

class DateTransform: TransformType {

  public typealias Object = Date
  public typealias JSON = String

  public var timeFormat: String?

  public init(timeFormat: String? = AppMappable.TIMEFORMAT) {
    self.timeFormat = timeFormat
  }

  public func transformFromJSON(_ value: Any?) -> Date? {
    if value == nil { return nil }
    return (value as? String)!.toDate(timeFormat!)
  }

  public func transformToJSON(_ value: Date?) -> String? {
    return value?.toString()
  }
}


