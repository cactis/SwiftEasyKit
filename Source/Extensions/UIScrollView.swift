//
//  UIScrollView.swift
//
//  Created by ctslin on 6/19/16.

import Foundation

extension UIScrollView {

  @discardableResult public func scrollToBottom(_ animated: Bool = true, offset: CGFloat = 0) -> UIScrollView {
    setContentOffset(CGPoint(x: 0, y: contentSize.height - bounds.size.height + tabBarHeight() + offset), animated: animated)
    return self
  }

  @discardableResult public func scrollToTop() -> UIScrollView {
    setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    return self
  }

  @discardableResult public func scrollToTrailing() -> UIScrollView {
    setContentOffset(CGPoint(x: contentSize.width - width, y: 0), animated: true)
    return self
  }

  @discardableResult public func scrollToTop(_ target: UIView, duration: TimeInterval = 0.2, completion: @escaping () -> () = {}) -> UIScrollView {
    //    setContentOffset(CGPoint(x: 0, target.y), animated: true)
    UIView.animate(withDuration: duration, animations: {
      self.setContentOffset(CGPoint(x: 0, y: target.y), animated: false)
    }) { (bool) in
      completion()
    }

    //    setContentOffset(CGPoint(x: 0, target.y), animated: true)
    return self
  }

  @discardableResult public func scrollToVisible(_ target: UIView) -> UIScrollView {
    //    var viewRect = target.frame
    //    viewRect.size.height -= keyboardSize.height
    let y = target.bottomEdge()// target.frame.origin.y
    let scrollPoint = CGPoint(x: 0, y: y)
    setContentOffset(scrollPoint, animated: true)
    return self
  }

  public func setLastSubiewAs(_ subview: UIView, bottomPadding: CGFloat = K.Size.Padding.scrollspace) {
    let width = subview.width()
    //    _logForUIMode(width)
    //    let height = subview.frame.origin.y + subview.frame.size.height
    let height = subview.bottomEdge()
    contentSize = CGSize(width: width, height: height + bottomPadding)
  }
}

