//
//  SWKFormDelegate.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/12/1.
//  Copyright © 2016年 airfont. All rights reserved.
//

import Foundation

public protocol SWKFormDelegate: NSObjectProtocol {
  var didSubmit: (_ data: AnyObject) -> () { get set }
  init(data: AnyObject, didSubmit: (_ data: AnyObject) -> ())
}
