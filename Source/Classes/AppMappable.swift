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
  public var status: String?
  public var alert: String?
  public var priButton: String?
  public var subButton: String?
  public var nextEvent: String?
  open func mapping(map: Map) {
    id <- map["id"]
    state <- map["state"]
    status <- map["status"]
    createdAt <- (map["created_at"], DateTransform())
    updatedAt <- (map["updated_at"], DateTransform())
    alert <- map["alert"]
    priButton <- map["pri_button"]
    subButton <- map["sub_button"]
    nextEvent <- map["next_event"]
  }

  required public init?(map: Map) {}
}

class DateTransform: TransformType {

  public typealias Object = Date
  public typealias JSON = String

  public init() {}

  public func transformFromJSON(_ value: Any?) -> Date? {
    if value == nil { return nil }
    return (value as? String)!.toDate()
  }

  public func transformToJSON(_ value: Date?) -> String? {
    return value?.toString()
  }
}


