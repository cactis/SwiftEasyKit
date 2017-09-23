////
////  CreditCard.swift
////  SwiftEasyKit
////
////  Created by ctslin on 2016/12/9.
////  Copyright © 2016年 airfont. All rights reserved.
////
//
//import ObjectMapper
//import Stripe
//
//open class CreditCard: STPCardParams, Mappable {
//  static let key = "z;tYGD0gr"
//  static let separator: String = ";"
//
//  public var checked: Bool? = false
//  public var brand: STPCardBrand? { get { return STPCardValidator.brand(forNumber: number!) } }
//  public var expDate: String? { get { return "\(expMonth)\(String(expYear.string!.characters.suffix(2)))" }}
//  public var secretedNumber: String? { get { return "‧ ‧ ‧ ‧ \(last4()!)" } }
//  public func mapping(map: Map) {
//    number <- map["number"]
//    expMonth <- map["expMonth"]
//    expYear <- map["expYear"]
//    cvc <- map["cvc"]
//    checked <- map["checked"]
//  }
//
//  required public init?(map: Map) {}
//
//  open class func store(items: [CreditCard]) {
//    let key = CreditCard.key
//    let separator = CreditCard.separator
//    storeToKeyChain(items.map({$0.toJSONString()!}).join(separator: separator), key: key)
//  }
//
//  open class func restore(onComplete: (_ items: [CreditCard]) -> ()) {
//    let key = CreditCard.key
//    let separator = CreditCard.separator
//    if let data = loadFromKeyChain(key) {
//      onComplete(data.split(Character(separator)).map({CreditCard(map: $0)!}))
//    } else {
//      onComplete([])
//    }
//  }
//
//  open class func seed() -> CreditCard {
//    return CreditCard(JSON: [
//      "number": seedNum(),
//      "expMonth": 12,
//      "expYear": 2022,
//      "cvc": "333"
//      ])!
//  }
//
//  open class func seeds() -> [CreditCard] {
//    return (0...3).map({_ in CreditCard.seed()})
//  }
//
//  class func seedNum() -> String {
//    return [
//      "5610591081018250",
//      "6011111111111117",
//      "6011000990139424",
//      "3530111333300000",
//      "3566002020360505",
//      "5555555555554444",
//      "5105105105105100",
//      "4111111111111111",
//      "4012888888881881",
//      "5019717010103742",
//      "6331101999990016"
//      ].randomItem()!
//  }
//}
//
//extension Sequence where Iterator.Element == CreditCard {
//}

