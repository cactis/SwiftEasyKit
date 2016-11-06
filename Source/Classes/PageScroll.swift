//
//  PageScroll.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/11/6.

import UIKit

public class PageScroll: DefaultView, UIScrollViewDelegate {
  public var paginator = UIPageControl()
  public var scrollView = UIScrollView()
  public var views = [UIView]() { didSet {
    paginator.numberOfPages = views.count
    scrollView.removeSubviews().layout(views)
    self.scrollView.asFadable()
    delayedJob(0.01) {
      self.views.forEach { (view) in
        view.layoutSubviews()
      }
    }
  }}

  public var didScrollBeginDragging: (index: Int) -> () = {_ in}
  public var didScrollEndDecelerating: (index: Int) -> () = {_ in}
  override public func layoutUI() {
    super.layoutUI()
    layout([scrollView, paginator])
  }
  override public func styleUI() {
    super.styleUI()
    scrollView.pagingEnabled = true
    scrollView.delegate = self
    paginator.pageIndicatorTintColor = UIColor.lightGrayColor().lighter()
    paginator.currentPageIndicatorTintColor = UIColor.grayColor().lighter()
  }

  override public func bindUI() {
    super.bindUI()
    paginator.addTarget(self, action: #selector(paginatorChanged(_:)), forControlEvents: .ValueChanged)
  }

  public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / width)
    paginator.currentPage = index
    didScrollEndDecelerating(index: index)
  }

  public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / width)
    didScrollBeginDragging(index: index)
  }

  func paginatorChanged(sender: UIPageControl) {
    scrollView.setContentOffset(CGPointMake(CGFloat(paginator.currentPage) * width, 0), animated: true)
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    paginator.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 10, otherSize: 30)
    scrollView.fillSuperview()
    scrollView.groupHorizontally(views.map({$0 as UIView}), fillingHeightWithLeftPadding: 0, spacing: 0, topAndBottomPadding: 0, width: width)
    scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(views.count), height: scrollView.frame.height)
  }
}
