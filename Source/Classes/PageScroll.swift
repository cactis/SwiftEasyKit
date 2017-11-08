//
//  PageScroll.swift
//  SwiftEasyKit
//
//  Created by ctslin on 2016/11/6.

import UIKit
import PhotoSlider

open class PageScroll: DefaultView, UIScrollViewDelegate {
  public var paginator = UIPageControl()
  public var scrollView = UIScrollView()
  public var views = [UIView]() { didSet {
    paginator.numberOfPages = views.count
    scrollView.isHidden = true
    scrollView.removeSubviews().layout(views)
    self.scrollView.asFadable()

    views.forEach { (v) in
      v.whenTapped(self, action: #selector(viewTapped(_:)))
    }
    delayedJob(0.2) {
      self.scrollView.subviews.forEach { (view) in
//        view.layoutIfNeeded()
        view.layoutSubviews()
      }
      self.scrollView.isHidden = false
    }
  }}

  public var didScrollBeginDragging: (_ index: Int) -> () = {_ in}
  public var didScrollEndDecelerating: (_ index: Int) -> () = {_ in}
  override open func layoutUI() {
    super.layoutUI()
    layout([scrollView, paginator])
  }

  override open func styleUI() {
    super.styleUI()
    scrollView.isPagingEnabled = true
    scrollView.delegate = self
    paginator.pageIndicatorTintColor = UIColor.lightGray.lighter()
    paginator.currentPageIndicatorTintColor = UIColor.gray.lighter()
  }

  override open func bindUI() {
    super.bindUI()
    paginator.addTarget(self, action: #selector(paginatorChanged(_:)), for: .valueChanged)
  }

  @objc func viewTapped(_ sender: UITapGestureRecognizer) {
    let index = views.index(of: sender.view!)
    let photoSlider = PhotoSlider.ViewController(images: views.map{($0 as? UIImageView)!.image!})
    photoSlider.currentPage = index!
    photoSlider.modalPresentationStyle = .overCurrentContext
    photoSlider.modalTransitionStyle = .crossDissolve
    parentViewController()?.present(photoSlider, animated: true, completion: nil)
  }

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / width)
    paginator.currentPage = index
    didScrollEndDecelerating(index)
  }

  public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    let index = Int(scrollView.contentOffset.x / width)
    didScrollBeginDragging(index)
  }

  @objc func paginatorChanged(_ sender: UIPageControl) {
    scrollView.setContentOffset(CGPoint(x: CGFloat(paginator.currentPage) * width, y: 0), animated: true)
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    scrollView.fillSuperview()
    scrollView.groupHorizontally(views.map({$0 as UIView}), fillingHeightWithLeftPadding: 0, spacing: 0, topAndBottomPadding: 0, width: width)
    scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(views.count), height: scrollView.frame.height)
    paginator.anchorAndFillEdge(.bottom, xPad: 0, yPad: 10, otherSize: height * 0.08)
  }
}
