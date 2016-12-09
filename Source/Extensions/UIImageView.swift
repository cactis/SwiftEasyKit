//
//  UIImageView.swift
//
//  Created by ctslin on 5/18/16.
//

import Foundation
import MapKit
import LoremIpsum
import FontAwesome_swift
import Neon
import RandomKit
import SwiftRandom
import Kingfisher

extension UIImageView {

  public func scaledHeight(width: CGFloat) -> CGFloat {
    return image!.size.height / (image!.size.width / width)
  }

  public func imaged(name: String?) -> UIImageView {
    guard let _ = name else { return self }
    if name!.containsString("http") {
      self.kf_setImageWithURL(NSURL(string: name!)!)
    } else {
      loadImage(UIImage(named: name!))
    }
    return self
  }
  
  public convenience init(name: String?) {
    self.init()
    imaged(name)
  }

  public func loadImageWithString(name: String!) -> UIImageView {
    return imaged(name)
  }

  public func loadImage(image: UIImage? = placeHoderImage()) -> UIImageView {
    if image != nil {
      //      UIView.transitionWithView(self, duration: 0.5, options: .TransitionCrossDissolve, animations: { () -> Void in
      self.image = image
      //        }, completion: { (bool) -> Void in })
    } else {
      //      _logForUIMode(333)
      randomImage { (image) -> () in
        //        UIView.transitionWithView(self, duration: 0.5, options: .TransitionCrossDissolve, animations: { () -> Void in
        self.image = image
        //          }, completion: { (bool) -> Void in })
      }
    }
    return self
  }

  public func styled() -> UIImageView {
    contentMode = .ScaleAspectFit
    autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
    layer.masksToBounds = true
    return self
  }

  public func styled(image: UIImage) -> UIImageView{
    self.image = image
    styled()
    return self
  }

  public func styledAsFill() -> UIImageView {
    styled()
    contentMode = .ScaleAspectFill
    return self
  }

  public func imaged(iconCode iconCode: String, color: UIColor = K.Color.barButtonItem, size: CGFloat = K.BarButtonItem.size) -> UIImageView {
    image = getImage(iconCode: iconCode, color: color, size: size)
    return self
  }

  public func styledAsFill(image: UIImage) -> UIImageView {
    self.image = image
    styledAsFill()
    return self
  }
}
