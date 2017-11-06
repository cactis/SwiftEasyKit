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
import SwiftRandom
import Kingfisher


extension UIImage {
  open func loadFromURL(_ url: String, onComplete: @escaping (_ image: UIImage) -> ()) {
    ImageDownloader.default.downloadImage(with: URL(string: url)!, retrieveImageTask: nil, options: [], progressBlock: nil, completionHandler: { (image, error, url, data) in
      DispatchQueue.main.async {
        onComplete(image!)
      }
    })
  }
  open class func loadFromURL(_ url: String, onComplete: @escaping (UIImage) -> ()){
    ImageDownloader.default.downloadImage(with: URL(string: url)!, retrieveImageTask: nil, options: [], progressBlock: nil, completionHandler: { (image, error, url, data) in
      DispatchQueue.main.async {
        onComplete(image!)
      }
    })
  }
}

extension UIImageView {
  
  open func loadFromURL(_ url: String) -> UIImageView {
    ImageDownloader.default.downloadImage(with: URL(string: url)!, retrieveImageTask: nil, options: [], progressBlock: nil, completionHandler: { (image, error, url, data) in
      DispatchQueue.main.async {
        self.image = image
      }
    })
    return self
  }
  
  public convenience init(fromCode: String, color: UIColor = K.Color.barButtonItem, size: CGFloat = K.BarButtonItem.size) {
    self.init(frame: .zero)
    image = UIImage.fromCode(drawText: fromCode, color: color, size: size)
  }
  
  @discardableResult public func scaledHeight(_ width: CGFloat) -> CGFloat {
    return image!.size.height / (image!.size.width / width)
  }
  
  @discardableResult public func imaged(_ name: String?) -> UIImageView {
    guard let _ = name else { return self }
    if name!.contains("http") {
      loadFromURL(name!)
      //      image = UIImage.loadFromURL(url: name!)
      //      self.kf_setImageWithURL(NSURL(string: name!)!)
    } else {
      loadImage(UIImage(named: name!))
    }
    return self
  }
  
  public convenience init(name: String?) {
    self.init()
    imaged(name)
  }
  
  @discardableResult public func loadImageWithString(_ name: String!) -> UIImageView {
    return imaged(name)
  }
  
  @discardableResult public func loadImage(_ image: UIImage? = placeHoderImage()) -> UIImageView {
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
  
  @discardableResult public func styled() -> UIImageView {
    contentMode = .scaleAspectFit
    autoresizingMask = [.flexibleHeight, .flexibleWidth]
    layer.masksToBounds = true
    return self
  }
  
  @discardableResult public func styled(_ image: UIImage) -> UIImageView{
    self.image = image
    styled()
    return self
  }
  
  @discardableResult public func styledAsFill() -> UIImageView {
    styled()
    contentMode = .scaleAspectFill
    return self
  }
  
  @discardableResult public func imaged(iconCode: String, color: UIColor = K.Color.barButtonItem, size: CGFloat = K.BarButtonItem.size) -> UIImageView {
    image = getImage(iconCode: iconCode, color: color, size: size)
    return self
  }
  
  @discardableResult  public func styledAsFill(_ image: UIImage) -> UIImageView {
    self.image = image
    styledAsFill()
    return self
  }
}
