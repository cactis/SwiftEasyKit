////  UIFont.swift
////
////  Created by ctslin on 7/4/16.
//
//import Foundation
//
////extension UIFont {
////
////  @nonobjc static var loadAllFontsDO: dispatch_once_t = 0
////
////  class func initialsAvatarFont() -> UIFont {
////    loadAllFonts()
////    if let retval = UIFont(name: "MyFontName", size: kInitialsAvatarFontSize) {
////      return retval;
////    } else {
////      return UIFont.systemFont(ofSize: kInitialsAvatarFontSize)
////    }
////  }
////
////  class func loadAllFonts() {
////    dispatch_once(&loadAllFontsDO) { () -> Void in
////      registerFontWithFilenameString("thefontfilename.ttf", bundleIdentifierString: "nameOfResourceBundleAlongsideTheFrameworkBundle")
////      // Add more font files here as required
////    }
////  }
////
////  static func registerFontWithFilenameString(filenameString: String, bundleIdentifierString: String) {
////    let frameworkBundle = Bundle(forClass: AnyClassInYourFramework.self)
////    let resourceBundleURL = frameworkBundle.URLForResource(bundleIdentifierString, withExtension: "bundle")
////    if let bundle = Bundle(URL: resourceBundleURL!) {
////      let pathForResourceString = bundle.pathForResource(filenameString, ofType: nil)
////      let fontData = NSData(contentsOfFile: pathForResourceString!)
////      let dataProvider = CGDataProviderCreateWithCFData(fontData)
////      let fontRef = CGFontCreateWithDataProvider(dataProvider)
////      var errorRef: Unmanaged<CFError>? = nil
////
////      if (CTFontManagerRegisterGraphicsFont(fontRef!, &errorRef) == false) {
////        NSLog("Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
////      }
////    }
////    else {
////      NSLog("Failed to register font - bundle identifier invalid.")
////    }
////  }
////}
//
//public extension UIFont {
//  public static func registerFontWithFilenameString(filenameString: String, bundleIdentifierString: String) {
//    if let bundle = Bundle(identifier: bundleIdentifierString) {
//      if let pathForResourceString = bundle.path(forResource: filenameString, ofType: nil) {
//        if let fontData = NSData(contentsOfFile: pathForResourceString) {
//          if let dataProvider = CGDataProvider(data: fontData) {
//            if let fontRef = CGFont(dataProvider) {
//              var errorRef: Unmanaged<CFError>? = nil
//
//              if (CTFontManagerRegisterGraphicsFont(fontRef, &errorRef) == false) {
//                NSLog("UIFont+:  Failed to register font - register graphics font failed - this font may have already been registered in the main bundle.")
//              }
//            }
//            else {
//              NSLog("UIFont+:  Failed to register font - font could not be loaded.")
//            }
//          }
//          else {
//            NSLog("UIFont+:  Failed to register font - data provider could not be loaded.")
//          }
//        }
//        else {
//          NSLog("UIFont+:  Failed to register font - font data could not be loaded.")
//        }
//      }
//      else {
//        NSLog("UIFont+:  Failed to register font - path for resource not found.")
//      }
//    }
//    else {
//      NSLog("UIFont+:  Failed to register font - bundle identifier invalid.")
//    }
//  }
//}
//
////
////  Downloader.swift
////  CustomFonts
////
////  Created by Trum Gyorgy on 12/1/15.
////  Copyright (c) 2015 General Electric. All rights reserved.
////
//
//import Foundation
//import CoreGraphics
//import CoreText
//import UIKit
//
//class Downloader {
//  class func load(URL: NSURL) -> UIFont? {
//    let sessionConfig = URLSessionConfiguration.default
//    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
//    let request = NSMutableURLRequest(url: URL as URL)
//    request.httpMethod = "GET"
//    let task = session.dataTaskWithRequest(request as URLRequest, completionHandler: { (data: NSData?, response: URLResponse?, error: NSError?) -> Void in
//      if (error == nil) {
//        // Success
//        let statusCode = (response as! NSHTTPURLResponse).statusCode
//        print("Success: \(statusCode)")
//
//        // This is your file-variable:
//        // data
//
////        var uiFont: UIFont?
////        let fontData = data
////
////        let dataProvider = CGDataProviderCreateWithCFData(fontData)
////        let cgFont = CGFontCreateWithDataProvider(dataProvider)
////
////        var error: Unmanaged<CFError>?
////        if !CTFontManagerRegisterGraphicsFont(cgFont!, &error)
////        {
////          print("Error loading Font!")
////        } else {
////          let fontName = CGFontCopyPostScriptName(cgFont)
////          uiFont = UIFont(name: String(fontName) , size: 30)
////        }
//
//      }
//      else {
//        // Failure
//        print("Faulure: %@", error!.localizedDescription);
//      }
//    })
//    task.resume()
//
//    return nil
//  }
//}

