//
//  ProgressView.swift
//  Created by ctslin on 3/3/16.

import UIKit
import KDCircularProgress

open class ProgressView: DefaultView {
  public var complete = UIImageView()
  public var progress: KDCircularProgress!
  public var percentage: CGFloat {
    didSet {
      animateToAngle(seconds: 0.8)
    }
  }

  public func animateToAngle(seconds: Double) {
    delayedJob(seconds) { () -> () in
      let angle = Double(self.percentage * 360)
      self.progress.animate(toAngle: Double(angle), duration: 0.5, completion: { (success) in

      })

    }
  }

  public init(percentage: CGFloat = 0) {
    self.percentage = percentage
    super.init(frame: .zero)
  }

  override open func layoutUI() {
    super.layoutUI()
//    if percentage < 1 {
      progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: width, height: height))
      layout([progress])
//    } else {
      complete.image = UIImage.init(named: "complete")
      layout([complete])
//    }
  }

  override open func styleUI() {
    super.styleUI()

    progress.startAngle = -90
    progress.progressThickness = 0.16
    progress.trackThickness = progress.progressThickness
    progress.clockwise = true
    progress.center = center
    progress.gradientRotateSpeed = 1
    progress.roundedCorners = false
    progress.glowMode = .noGlow
    progress.angle = Double(percentage * CGFloat(360))
    progress.trackColor = UIColor.clear
    progress.set(colors: UIColor.yellow.tinyDarker(), UIColor.orange, UIColor.red.tinyLighter(), UIColor.purple, UIColor.magenta, UIColor.green.tinyDarker())
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    if percentage < 1 {
      let p = -1 * width * 0.15
      progress.fillSuperview(left: p, right: p, top: p, bottom: p)
      progress.trackColor = UIColor.lightGray.lighter()
    } else {
      let q: CGFloat = -6
      complete.fillSuperview(left: q, right: q, top: q, bottom: q)
    }
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
