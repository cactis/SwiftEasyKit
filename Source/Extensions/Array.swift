//
//  Array.swift
//
//
//  Created by ctslin on 2016/11/12.
//
//

import Foundation
//// import RandomKit

extension Array {

  public func rand() -> Element {
    return randomItem()!
  }

  public func compact() -> [Element] {
    return flatMap({$0})
  }

//  public func asJSON() -> [NSDictionary] {
//    return self.map({($0 as? NSObject)!.asJSON()})
//  }

}

extension Sequence where Iterator.Element == String {

  public func join(_ separator: String = "") -> String {
    return joined(separator: separator)
  }

}
