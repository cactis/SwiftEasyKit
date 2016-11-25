//
//  ENMBadgedBarButtonItem.swift
//  TestBadge-Swift
//
//  Created by Eric Miller on 6/2/14.
//  Copyright (c) 2014 Xero. All rights reserved.
//

import UIKit
import Foundation
import QuartzCore

let kENMDefaultPadding: CGFloat = 3.0
let kENMDefaultMinSize: CGFloat = 8.0
let kENMDefaultOriginX: CGFloat = 0.0
let kENMDefaultOriginY: CGFloat = 0.0

public class ENMBadgedBarButtonItem: UIBarButtonItem {

  public var badgeLabel: UILabel = UILabel()
  public var badgeValue: String {
    didSet {
      guard !shouldBadgeHide(badgeValue) else {
        removeBadge()
        return
      }

      if (badgeLabel.superview != nil) {
        updateBadgeValueAnimated(true)
      } else {
        badgeLabel = self.createBadgeLabel()
        updateBadgeProperties()
        customView!.addSubview(badgeLabel)

        // Pull the setting of the value and layer border radius off onto the next event loop.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
          self.badgeLabel.text = self.badgeValue
          self.updateBadgeFrame()
        })
      }
    }
  }
  public var badgeBackgroundColor: UIColor = K.Badge.backgroundColor {
    didSet {
      refreshBadgeLabelProperties()
    }
  }
  public var badgeTextColor: UIColor = K.Badge.color {
    didSet {
      refreshBadgeLabelProperties()
    }
  }
  public var badgeFont: UIFont = UIFont.systemFontOfSize(K.Badge.size){
    didSet {
      refreshBadgeLabelProperties()
    }
  }
  public var badgePadding: CGFloat {
    get {
      return kENMDefaultPadding
    }
  }
  public var badgeMinSize: CGFloat {
    get {
      return kENMDefaultMinSize
    }
  }
  public var badgeOriginX: CGFloat = kENMDefaultOriginX
  public var badgeOriginY: CGFloat {
    get {
      return kENMDefaultOriginY
    }
  }
  public var shouldHideBadgeAtZero: Bool = true
  public var shouldAnimateBadge: Bool = true

  init(customView: UIView!, value: String!) {
    badgeValue = value
    badgeOriginX = customView.frame.size.width - badgeLabel.frame.size.width / 2
    super.init()
    self.customView = customView
  }

  required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Utilities
extension ENMBadgedBarButtonItem {

  public func refreshBadgeLabelProperties() {
    badgeLabel.textColor = badgeTextColor;
    badgeLabel.backgroundColor = badgeBackgroundColor;
    badgeLabel.font = badgeFont;
  }

  public func updateBadgeValueAnimated(animated: Bool) {

    if (animated && shouldAnimateBadge && (badgeLabel.text != badgeValue)) {
      let animation: CABasicAnimation = CABasicAnimation()
      animation.keyPath = "transform.scale"
      animation.fromValue = 1.5
      animation.toValue = 1
      animation.duration = 0.2
      animation.timingFunction = CAMediaTimingFunction(controlPoints: 0.4, 1.3, 1.0, 1.0)
      badgeLabel.layer.addAnimation(animation, forKey: "bounceAnimation")
    }

    badgeLabel.text = self.badgeValue;

    let duration: Double = animated ? 0.2 : 0.0
    UIView.animateWithDuration(duration) {
      self.updateBadgeFrame()
    }
  }

  public func updateBadgeFrame() {
    let expectedLabelSize: CGSize = badgeExpectedSize()
    var minHeight = expectedLabelSize.height

    minHeight = (minHeight < badgeMinSize) ? badgeMinSize : expectedLabelSize.height
    var minWidth = expectedLabelSize.width
    let padding = badgePadding

    minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width

    self.badgeLabel.frame = CGRectMake(
      self.badgeOriginX,
      self.badgeOriginY,
      minWidth + padding,
      minHeight + padding
    )
    self.badgeLabel.layer.cornerRadius = (minHeight + padding) / 2
  }

  public func removeBadge() {
    UIView.animateWithDuration(0.2,
                               animations: {
                                self.badgeLabel.transform = CGAffineTransformMakeScale(0.0, 0.0)
      }, completion: { finished in
        self.badgeLabel.removeFromSuperview()
    })
  }
}

// MARK: - Internal Helpers
extension ENMBadgedBarButtonItem {

  public func createBadgeLabel() -> UILabel {
    let frame = CGRectMake(badgeOriginX, badgeOriginY, 15, 15)
    let label = UILabel(frame: frame)
    label.textColor = badgeTextColor
    label.font = badgeFont
    label.backgroundColor = badgeBackgroundColor
    label.textAlignment = NSTextAlignment.Center
    label.layer.cornerRadius = frame.size.width / 2
    label.clipsToBounds = true

    return label
  }

  public func badgeExpectedSize() -> CGSize {
    let frameLabel: UILabel = self.duplicateLabel(badgeLabel)
    frameLabel.sizeToFit()
    let expectedLabelSize: CGSize = frameLabel.frame.size;

    return expectedLabelSize
  }

  public func duplicateLabel(labelToCopy: UILabel) -> UILabel {
    let dupLabel = UILabel(frame: labelToCopy.frame)
    dupLabel.text = labelToCopy.text
    dupLabel.font = labelToCopy.font

    return dupLabel
  }

  public func shouldBadgeHide(value: NSString) -> Bool {
    let b2: Bool = value.isEqualToString("")
    let b3: Bool = value.isEqualToString("0")
    let b4: Bool = shouldHideBadgeAtZero
    if ((b2 || b3) && b4) {
      return true
    }
    return false
  }

  public func updateBadgeProperties() {
    badgeOriginX = self.customView!.frame.size.width - badgeLabel.frame.size.width/2
  }
}