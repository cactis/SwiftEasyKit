//
//  Segment.swift
//
//  Created by ctslin on 2/28/16.

import UIKit

public enum Direction {
  case Horizontal
  case Vertical
}

public class SegmentWithViews: DefaultView, UIScrollViewDelegate {

  public var header = UIView()
  public var segment: Segment!
  public var scrollView = UIScrollView()
  public var views = [UIView]()
  public var segmentHeight: CGFloat = 40
  public var segmentXPad: CGFloat = 0
  public var segmentYPad: CGFloat = 0

  public init(titles: [String]!, iconCodes: [String]! = [], color: (active: UIColor, deactive: UIColor), size: CGFloat = 12, index: Int = 0, views: [UIView], direction: Direction = .Vertical) {

    if iconCodes.count > 0 {
      self.segment = IconFontSegment(titles: titles, iconCodes: iconCodes, color: color, size: size, index: index, direction: direction)
    } else {
      self.segment = TextSegment(titles: titles, size: size, index: index)
    }
    self.views = views
    super.init(frame: CGRectZero)
  }

  override public func layoutUI() {
    super.layoutUI()
    layout([header.layout([segment]), scrollView.layout(views)])
  }

  override public func bindUI() {
    super.bindUI()
    scrollView.delegate = self
    scrollView.pagingEnabled = true
    segment.segmentTapped = {
      self.segmentTapped()
    }
  }

  public func tappedAtIndex(index: Int) {
    segment.tappedAtIndex(index)
  }

  public func segmentTapped() {
    self.delayedJobCancelable(0.2, closure: {
      let index = self.segment.index.cgFloat
      self.scrollView.setContentOffset(CGPoint(x: index * self.scrollView.width, y: 0), animated: true)
    })
  }

  public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    _logForUIMode()
    segment.index = Int(scrollView.contentOffset.x / scrollView.width)
  }


  override public func layoutSubviews() {
    super.layoutSubviews()
    header.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: segmentHeight)
    segment.fillSuperview(left: segmentXPad, right: segmentXPad, top: segmentYPad, bottom: segmentYPad)
    scrollView.alignUnder(header, matchingLeftAndRightFillingHeightWithTopPadding: 0, bottomPadding: tabBarHeight())
    scrollView.groupHorizontally(views.map({$0 as UIView}), fillingHeightWithLeftPadding: 0, spacing: 0, topAndBottomPadding: 0, width: scrollView.width)
    scrollView.contentSize = CGSize(width: scrollView.width * views.count.cgFloat, height: scrollView.height)
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public class IconFontSegmentWithUnderline: IconFontSegment {
  override public func indicatorConstraints() {
    switch direction {
    case .Horizontal:
      indicator.opacity(0.2)
      radiused()
      indicator.radiused()

      let h = group.groupMargins[index].height()
      indicator.alignAbove(group.groupMargins[index], matchingLeftAndRightWithBottomPadding: -1 * h, height: h)
    default:
      indicator.alignUnder(group.groupMargins[index], matchingCenterWithTopPadding: indicatorHeight * 5, width: labels[index].label.textWidth(), height: indicatorHeight)
    }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
  }
}

public class IconFontSegment: TextSegment {
  public var icons = [UILabel]()

  public var direction: Direction = .Vertical {
    didSet { layoutSubviews() }
  }

  override public func didChange() {
    delayedJob(0.3) {
      (0...self.labels.count - 1).forEach { (i) in
        self.labels[i].label.colored(self.deactiveColor)
        self.icons[i].colored(self.deactiveColor)
      }
      self.icons[self.index].colored(self.activeColor)
      self.labels[self.index].label.colored(self.activeColor)
    }
  }

  public init(titles: [String]!, iconCodes: [String]!, color: (active: UIColor, deactive: UIColor), size: CGFloat = 12, index: Int = 0, direction: Direction = .Vertical) {
    super.init(titles: titles, size: size, index: index)
    ({ self.activeColor = color.active })()
    self.deactiveColor = color.deactive
    for i in 0...iconCodes.count - 1 {
      icons.append(UILabel())
      icons[i].iconFonted(iconCodes[i], iconColor: color.deactive, size: size)
      icons[i].adjustsFontSizeToFitWidth = true
      group.groups[i].layout([icons[i]])
    }
    self.index = index
    ({ self.direction = direction })()
  }

  override public func bindUI() {
    super.bindUI()
    group.groups.forEach { (tab) -> () in
      tab.whenTapped(self, action: #selector(Segment.tabTapped(_:)))
    }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    for i in 0...icons.count - 1 {
      switch direction {
      case .Horizontal:
        let h = size
        let bp = h * 0.2
        let lp = (width / icons.count.cgFloat - h - bp - labels[i].label.textWidth()) / 2
        icons[i].anchorToEdge(.Left, padding: lp, width: h, height: h)
        labels[i].alignToTheRightOf(icons[i], matchingCenterWithLeftPadding: bp, width: labels[i].label.textWidth(), height: labels[i].label.textHeight())
        let badge = labels[i].badge
        badge.badgeSize = h
      default:
        let h = height - labels[i].label.textHeight() - 40
        icons[i].anchorTopCenterWithTopPadding(10, width: h, height: h)
        icons[i].centered().sized(h)
        labels[i].alignUnder(icons[i], centeredFillingWidthWithLeftAndRightPadding: 0, topPadding: 10, height: labels[i].label.textHeight())
      }
    }
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }

}

public class IconSegment: Segment {
  public var icons = [UIImageView]()

  public init(titles: [String]!, images: [UIImage]!, size: CGFloat = 12, index: Int = 0){
    super.init(titles: titles, size: size, index: index)

    for i in 0...images.count - 1 {
      icons.append(UIImageView())
      icons[i].image = images[i]
      group.groups[i].layout([icons[i]])
    }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    for i in 0...icons.count - 1 {
      icons[i].anchorTopCenterWithTopPadding(10, width: 42, height: 42)
      labels[i].alignUnder(icons[i], centeredFillingWidthWithLeftAndRightPadding: 0, topPadding: 10, height: labels[i].label.textHeight())
    }
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public class TextSegment: Segment {

  public var indicatorHeight: CGFloat = K.Size.Segment.underline { didSet { indicatorConstraints() } }

  override public func indicatorConstraints() {
    switch style {
    case .Cover:
      let target = group.groupMargins[index]
      indicator.backgroundColored(K.Color.navigator.lighter().colorWithAlphaComponent(0.25))
      indicator.alignUnder(target, matchingCenterWithTopPadding: -1 * target.height() + 1, width: target.width() - 2, height: target.height() - 2)
    default:
      indicator.alignUnder(group.groupMargins[index], matchingLeftAndRightWithTopPadding: -1 * indicatorHeight + 1, height: indicatorHeight)
    }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    labels.forEach { (tab) -> () in
      switch style {
      case .Cover:
        tab.fillSuperview()
      default:
        tab.anchorInCenter(width: width / titles.count.cgFloat , height: size)
      }
    }
  }
}

public class Segment: DefaultView {

  public var labels: [BadgeLabel]! = []
  public var indicator = UIView()
  public var indicatorColor = K.Color.indicator {
    didSet { indicator.backgroundColored(indicatorColor) }
  }

  public var titles: [String]! = []
  public var size: CGFloat! { didSet { labels.forEach({$0.label.sized(size)}) }}
  public var group: GroupsView!

  public var changed: () -> () = {}
  public var segmentTapped: () -> () = {}

  public var style: IndicatorStyle = .Underline { didSet { } }

  public var textColorFollowedByIndicator = false {
    didSet { indicatorConstraints() }
  }

  public func tappedAtIndex(index: Int) {
    self.index = index
    segmentTapped()
    changed()
  }

  public enum IndicatorStyle {
    case Underline
    case Cover
  }

  public var index: Int = 0 {
    didSet {
      reConstraints()
      didChange()
    }
  }

  public var activeColor: UIColor! = K.Color.indicator { didSet { indicator.backgroundColor = activeColor } }
  public var deactiveColor: UIColor!
  public func didChange() { }

  public init(iconCodes: [String]!, titles: [String]!, size: CGFloat = 12, index: Int = 0) {

    self.titles = titles
    self.size = size
    self.index = index

    group = GroupsView(count: titles.count, padding: 1, group: .Horizontal, margin: UIEdgeInsetsZero)

    for i in 0...titles.count - 1 {
      let label = BadgeLabel(text: titles[i], size: size * 0.8, value: "")
      label.label.text(iconCodes[i], text: titles[i], size: size)
      group.groups[i].layout([label])
      labels.append(label)
    }
    super.init(frame: CGRectZero)
  }

  public init(titles: [String]!, size: CGFloat = 12, index: Int = 0){
    self.titles = titles
    self.size = size
    self.index = index

    group = GroupsView(count: titles.count, padding: 1, group: .Horizontal, margin: UIEdgeInsetsZero)

    for i in 0...titles.count - 1 {
      let label = BadgeLabel(text: titles[i], size: size, value: "")
      group.groups[i].layout([label])
      labels.append(label)
    }
    super.init(frame: CGRectZero)
  }

  override public func layoutUI() {
    super.layoutUI()
    layout([group.layout([indicator])])
  }

  override public func styleUI() {
    super.styleUI()
    backgroundColor = UIColor.whiteColor()
    indicator.backgroundColored(indicatorColor)
  }

  override public func bindUI() {
    super.bindUI()
    group.groups.forEach { (tab) -> () in
      tab.whenTapped(self, action: #selector(Segment.tabTapped(_:)))
    }
  }

  public func tabTapped(sender: AnyObject) {
    index = group.groups.indexOf(sender.view!!)!
    segmentTapped()
    changed()
    reConstraints()
  }

  public func reConstraints() {
    UIView.animateWithDuration(0.5) { () -> Void in
      self.indicatorConstraints()
    }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    group.fillSuperview(left: 0, right: 0, top: 0, bottom: 0)
    indicatorConstraints()
  }

  public func indicatorConstraints() {
    if textColorFollowedByIndicator {
      labels.forEach({ (label) in label.label.colored(deactiveColor) })
      labels[index].label.colored(indicatorColor)
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
