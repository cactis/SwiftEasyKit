//
//  ProgressView.swift
//  Created by ctslin on 3/3/16.

import UIKit
import KDCircularProgress

class ProgressView: DefaultView {
  var complete = UIImageView()
  var progress: KDCircularProgress!
  var percentage: CGFloat {
    didSet {
      animateToAngle(0.8)
    }
  }

  func animateToAngle(seconds: Double) {
    delayedJob(seconds) { () -> () in
      let angle = Double(self.percentage * 360)
      self.progress.animateToAngle(Double(angle), duration: 0.5) { (success) -> Void in
      }
    }
  }

  init(percentage: CGFloat = 0) {
    self.percentage = percentage
    super.init(frame: CGRectZero)
  }

  override func layoutUI() {
    super.layoutUI()
//    if percentage < 1 {
      progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: width, height: height))
      layout([progress])
//    } else {
      complete.image = UIImage.init(named: "complete")
      layout([complete])
//    }
  }

  override func styleUI() {
    super.styleUI()

    progress.startAngle = -90
    progress.progressThickness = 0.16
    progress.trackThickness = progress.progressThickness
    progress.clockwise = true
    progress.center = center
    //    progress.gradientRotateSpeed = 1
    progress.roundedCorners = false
    progress.glowMode = .NoGlow
    progress.angle = Double(percentage * CGFloat(360))
    progress.trackColor = UIColor.lightGrayColor().lighter()
    progress.setColors(UIColor.yellowColor().tinyDarker(), UIColor.orangeColor(), UIColor.redColor().tinyLighter(), UIColor.purpleColor(), UIColor.magentaColor(), UIColor.greenColor().tinyDarker())
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if percentage < 1 {
      let p = -1 * width * 0.15
      progress.fillSuperview(left: p, right: p, top: p, bottom: p)
    } else {
      let q: CGFloat = -6
      complete.fillSuperview(left: q, right: q, top: q, bottom: q)
    }
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
