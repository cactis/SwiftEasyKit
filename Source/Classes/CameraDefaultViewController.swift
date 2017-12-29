//
//  CameraDefaultViewController.swift
//  SwiftEasyKit
//
//  Created by ctslin on 24/12/2017.
//

import UIKit
import AVFoundation

open class CameraDefaultViewController: DefaultViewController {
  enum Mode {
    case new
    case edit
  }

  var output: AVCaptureStillImageOutput? = AVCaptureStillImageOutput()

  public var liveView = UIImageView()
  public var toolBlock = DefaultView()
  var cameraReady: () -> () = {}

  override open func layoutUI() {
    super.layoutUI()
    view.layout([liveView, toolBlock])
  }

  open override func styleUI() {
    super.styleUI()
    liveView.styledAsFill().backgroundColored(UIColor.lightGray)
  }

  open override func bindUI() {
    super.bindUI()
    (_, output, _) = enableCaptureSessionWithPreview(liveView: liveView) {
      self.cameraReady()
    }
  }

  open func takeShot() {
    output?.getImage(onComplete: { (image) in self.didShot(image) })
  }

  override open func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    liveView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: screenWidth())
    toolBlock.alignUnder(liveView, matchingLeftAndRightFillingHeightWithTopPadding: 0, bottomPadding: 0)
  }

  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    didShot(picker.getImageFromInfo(info)!)
  }

  open var didShot: (_ image: UIImage?) -> () = { _ in }
}
