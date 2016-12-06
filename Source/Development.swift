//
//  Development.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/28/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation

public struct Development {
  //  static var simulator = true
  public static var setDeviceAsSimulator = false
  public static var mode = "UI Design"
//  public static var mode = "API Implement"

  public static var developer = "All"
  
  public static var delayed: Double = 20
  public static var autoRun = true
  public static var prompt = true
  public static var uiTestMode = false {
    didSet {
      if uiTestMode {
        autoRun = false
        prompt = false
      }
    }
  }
  
  public struct Log {
    public struct API {
      public static var request = true
      public static var response = true
      public static var statusCode = true
      public static var processInfo = true
      public static var header = true
    }
  }
}

