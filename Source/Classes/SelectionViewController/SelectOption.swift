//
//  SelectOption.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/11/25.
//  Copyright © 2016年 airfont. All rights reserved.
//

import UIKit
// import RandomKit
import SwiftRandom
import ObjectMapper

open class InputField: Mappable {
  public var key: String?
  public var label: String?
  public var value: String?

  open func mapping(map: Map) {
    key <- map["key"]
    label <- map["label"]
    value <- map["value"]
  }
  public required init?(map: Map) {}
}

open class SelectOption: Mappable {

  public var id: Int?
  public var name: String?
  public var title: String?
  public var parent: SelectOption?
  public var parent_id: Int?
  public var family: [SelectOption]?
  //  var children: [SelectOption]?//Array<SelectOption>? //[SelectOption]?
  public var active: Bool! = true
  public var level: Int?
  public var url: String?
  public var children_url: String?
  public var inputFields: [InputField]?

  open func mapping(map: Map) {
    id <- map["id"]
    name <- map["name"]
    title <- map["title"]
    parent_id <- map["parent_id"]
    parent <- map["parent"]
    //    children <- map["children"]
    level <- map["level"]
    active <- map["active"]
    family <- map["family"]
    url <- map["url"]
    children_url <- map["children_url"]
    inputFields <- map["input_fields"]
  }

  open class func new(_ id: Int, name: String) -> SelectOption {
    let item = SelectOption(JSON: ["id": id, "name": name, "level": 0])!
    item.family = [item]
    //    item.family?.first?.id = id
    //    item.family?.first?.name = item.name
    return item
  }

  public var breadcrumb: String! { get {
    _ = family?.popLast()
    return family != nil ? (family?.asBreadcrumb())! : name!
    }
  }
  public var forHuman: String! { get { return family != nil ? (family?.asBreadcrumb())! : name! } }

  open class func seeds(_ onComplete: (_ items: [SelectOption]) -> ()) {
    let items = Array(0...wizRandomInt(5, upper: 8)).map({ SelectOption(JSON: ["id": $0, "name": Randoms.randomFakeTag()])! })
    onComplete(items)
  }

  open class func list(_ url: String!, onComplete: @escaping (_ items: [SelectOption]) -> ()) {
    var items = [SelectOption]()
    API.get(url) { (response, data) in
      switch response.result {
      case .success(let value):
        if let jsons = value as? [[String: AnyObject]] {
          jsons.forEach({ json in
            let item = SelectOption(JSON: json)!
            items.append(item)
          })
          onComplete(items)
        }
      case .failure(let error):
        _logForUIMode(error.localizedDescription)
    }
//    onComplete(items)
    }
  }

  public func getChildren(_ onComplete: @escaping (_ items: [SelectOption]?) -> ()) {
    SelectOption.list(children_url) { (items) in
      onComplete(items)
    }
  }
  required public init?(map: Map) {}
}

extension Sequence where Iterator.Element == SelectOption {
  var ids: [Int] { get { return map({$0.id!}) } }

  public func asBreadcrumb(_ separator: String = " / ") -> String {
    return self.map({$0.name!}).join(separator)
  }

  public func prependDefaultOption(name: String! = "全部類別") -> [SelectOption] {
    return [SelectOption(JSON: ["id": 0, "name": name, "level": 0])!] + self
  }

  public func contains(_ ele: SelectOption) -> Bool {
    return ids.contains(ele.id!)
  }

}

//extension SequenceType where Iterator.Element == AnyObject {
//  func toSelectOption() -> [SelectOption] {
//    var selectOptions = [SelectOption]()
//    forEach({ obj in
//      if obj is [String: AnyObject] {
//        selectOptions.append(SelectOption(JSON: [
//          "id": obj.objectForKey("id")!,
//          "name": obj.objectForKey("name")!,
//          "children": (obj.objectForKey("children") as? [AnyObject])!
//          ])!)
//      }
//    })
//    return selectOptions
//  }
//}

open class SelectionCell: TableViewCell {
  var id: Int!
  var title = UILabel()
  public var checked = false { didSet { styleIcon() } }
  var icon = IconLabel(iconCode: K.Icons.check)

  func loadData(_ data: SelectOption) {
    if data.id != nil { id = data.id }
    title.text = data.name
  }

  func styleIcon() {
    if checked {
      icon.iconColor = K.Color.selectOptionChecked
    } else {
      icon.iconColor = UIColor.clear
    }
  }

  override open func layoutUI() {
    super.layoutUI()
    layout([title, icon])
  }

  override open func styleUI() {
    super.styleUI()
    title.styled().darker().bold()
    backgroundColor = UIColor.white
    icon.iconSize = title.textHeight() * 1.4
    styleIcon()
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    title.anchorAndFillEdge(.left, xPad: 20, yPad: 10, otherSize: width - 40)
    icon.anchorToEdge(.right, padding: 20, width: icon.iconSize!, height: icon.iconSize!)
  }

}
