//
//  SwiftEasyKit.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/27/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation

//import FontAwesome_swift

public class SwiftEasyKit {

  public class func enableTabBarController(delegate: UITabBarControllerDelegate, viewControllers: [UIViewController]!, titles: [String]!, images: [UIImage], selectedImages: [UIImage] = []) -> (UIWindow?, UITabBarController!) {
    var _selectedImages = [UIImage]()
    if selectedImages.count > 0 {
      _selectedImages = selectedImages
    } else {
      _selectedImages = images
    }
    let tabBarViewController = UITabBarController()
    let vcs = viewControllers.map({ $0.embededInNavigationController() })
    for (index, vc) in vcs.enumerate() {
      vc.tabBarItem = UITabBarItem(title: titles[index], image: images[index], selectedImage: _selectedImages[index])
      viewControllers[index].titled(titles[index])
    }
    tabBarViewController.viewControllers = vcs
    tabBarViewController.delegate = delegate
    return (bootFrom(tabBarViewController), tabBarViewController)
  }

  public class func bootFrom(vc: UIViewController) -> UIWindow? {
    let window: UIWindow?  = UIWindow(frame: UIScreen.mainScreen().bounds)
//    window!.backgroundColor = K.Color.body
    window!.rootViewController = vc
    window!.makeKeyAndVisible()
    return window!
  }

}

