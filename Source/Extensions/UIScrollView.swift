//
//  UIScrollView.swift
//
//  Created by ctslin on 6/19/16.

import Foundation

extension UIScrollView {

  public func scrollToBottom(animated: Bool = true) -> UIScrollView {
    setContentOffset(CGPointMake(0, contentSize.height - bounds.size.height + tabBarHeight()), animated: animated)
    return self
  }

  public func scrollToTop() -> UIScrollView {
    setContentOffset(CGPointMake(0, 0), animated: true)
    return self
  }

  public func scrollToTrailing() -> UIScrollView {
    setContentOffset(CGPointMake(contentSize.width - width, 0), animated: true)
    return self
  }

  public func scrollToTop(target: UIView, duration: NSTimeInterval = 0.2, completion: () -> () = {}) -> UIScrollView {
    //    setContentOffset(CGPointMake(0, target.y), animated: true)
    UIView.animateWithDuration(duration, animations: {
      self.setContentOffset(CGPointMake(0, target.y), animated: false)
    }) { (bool) in
      completion()
    }

    //    setContentOffset(CGPointMake(0, target.y), animated: true)
    return self
  }

  public func scrollToVisible(target: UIView) -> UIScrollView {
    //    var viewRect = target.frame
    //    viewRect.size.height -= keyboardSize.height
    let y = target.bottomEdge()// target.frame.origin.y
    let scrollPoint = CGPointMake(0, y)
    setContentOffset(scrollPoint, animated: true)
    return self
  }

  public func setLastSubiewAs(subview: UIView, bottomPadding: CGFloat = K.Size.Padding.scrollspace) {
    let width = subview.width()
    //    _logForUIMode(width)
    //    let height = subview.frame.origin.y + subview.frame.size.height
    let height = subview.bottomEdge()
    contentSize = CGSize(width: width, height: height + bottomPadding)
  }
}

