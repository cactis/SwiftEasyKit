//
//  SwiftEasyKit.swift
//  SwiftEasyKit
//
//  Created by ctslin on 7/27/16.
//  Copyright © 2016 airfont. All rights reserved.
//

import Foundation

//import FontAwesome_swift

open class SwiftEasyKit {

  open class func enableTabBarController(_ delegate: UITabBarControllerDelegate, viewControllers: [UIViewController]!, titles: [String]!, images: [UIImage], selectedImages: [UIImage] = []) -> (UIWindow?, UITabBarController?) {
    var _selectedImages = [UIImage]()
    if selectedImages.count > 0 {
      _selectedImages = selectedImages
    } else {
      _selectedImages = images
    }
    let tabBarViewController = UITabBarController()
    let vcs = viewControllers.map({
        UINavigationController(rootViewController: $0)

    })
    for (index, vc) in vcs.enumerated() {
      vc.tabBarItem = UITabBarItem(title: titles[index], image: images[index], selectedImage: _selectedImages[index])
//      viewControllers[index].titled(titles[index])
      viewControllers[index].navigationItem.title = titles[index]
    }
    tabBarViewController.viewControllers = vcs
    tabBarViewController.delegate = delegate
    return (bootFrom(tabBarViewController), tabBarViewController)
  }

  open class func bootFrom(_ vc: UIViewController) -> UIWindow? {
    let window: UIWindow?  = UIWindow(frame: UIScreen.main.bounds)
//    window!.backgroundColor = K.Color.body
    window!.rootViewController = vc
    window!.makeKeyAndVisible()
    return window!
  }

}

