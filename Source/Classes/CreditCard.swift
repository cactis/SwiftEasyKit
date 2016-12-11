//
//  CreditCard.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/12/9.
//  Copyright © 2016年 airfont. All rights reserved.
//

import ObjectMapper
import Stripe

public class CreditCard: STPCardParams, Mappable {
  static let key = "z;tYGD0gr"
  static let separator: String = ";"
  
  public var checked: Bool? = false
  public var brand: STPCardBrand? { get { return STPCardValidator.brandForNumber(number!) } }
  public var expDate: String? { get { return "\(expMonth)\(String(expYear.string!.characters.suffix(2)))" }}
  public var secretedNumber: String? { get { return "‧ ‧ ‧ ‧ \(last4()!)" } }
  public func mapping(map: Map) {
    number <- map["number"]
    expMonth <- map["expMonth"]
    expYear <- map["expYear"]
    cvc <- map["cvc"]
    checked <- map["checked"]
  }
  
  required public init?(_ map: Map) {}
  
  public class func store(items: [CreditCard]) {
    let key = CreditCard.key
    let separator = CreditCard.separator
    storeToKeyChain(items.map({$0.toJSONString()!}).join(separator), key: key)
  }
  
  public class func restore(onComplete: (items: [CreditCard]) -> ()) {
    let key = CreditCard.key
    let separator = CreditCard.separator    
    if let data = loadFromKeyChain(key) {
      onComplete(items: data.split(Character(separator)).map({CreditCard(JSONString: $0)!}))
    } else {
      onComplete(items: [])
    }
  }
  
  public class func seed() -> CreditCard {
    return CreditCard(JSON: [
      "number": seedNum(),
      "expMonth": 12,
      "expYear": 2022,
      "cvc": "333"
      ])!
  }
  
  public class func seeds() -> [CreditCard] {
    return (0...3).map({_ in CreditCard.seed()})
  }
  
  class func seedNum() -> String {
    return [
      //      "378282246310005",
      //      "371449635398431",
      //      "378734493671000",
      "5610591081018250",
      //      "30569309025904",
      //      "38520000023237",
      "6011111111111117",
      "6011000990139424",
      "3530111333300000",
      "3566002020360505",
      "5555555555554444",
      "5105105105105100",
      "4111111111111111",
      "4012888888881881",
      //      "4222222222222",
      //      "76009244561",
      "5019717010103742",
      "6331101999990016"
      ].randomItem()
  }
}

extension SequenceType where Generator.Element == CreditCard {
}
