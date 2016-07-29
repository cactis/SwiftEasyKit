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

  public func imaged(name: String!) -> UIImageView {
    //    self.image = UIImage.sample()
    //    _logForUIMode(name.containsString("http"), title: "name.containsString(http)")
    if name.containsString("http") {
      //      UIView.transitionWithView(self, duration: 0.5, options: .TransitionCrossDissolve, animations: { () -> Void in
      self.kf_setImageWithURL(NSURL(string: name)!)
//      self.image = UIImage(data: NSData(contentsOfURL: NSURL(string: name)!)!)
      //        }, completion: { (bool) -> Void iCn
      //          self.sd_setImageWithURL(NSURL(string: name))
      //      })
    } else {
      loadImage(UIImage(named: name))
    }
    return self
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

  public func styledAsFill(image: UIImage) -> UIImageView {
    self.image = image
    styledAsFill()
    return self
  }
}
