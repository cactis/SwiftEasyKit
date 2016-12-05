//
//  SWKAvatar.swift
//

import UIKit
import RSKImageCropper

public class SWKAvatar: DefaultView, RSKImageCropViewControllerDelegate {
  
  var background = UIView()
  let camera = UIButton()
  public var photo = UIImageView(image: getIcon(.User, options: ["color": UIColor.lightGrayColor(), "size": 64])
  )
  
  private var enabledEdit = false {
    didSet {
      camera.hidden = !enabledEdit
    }
  }
  private var didShot: (image: UIImage) -> () = {_ in }
  
  public func enabledShotting(run: (image: UIImage) -> ()) {
    enabledEdit = true
    didShot = run
  }
  
  func cropImage(image: UIImage) {
    let vc = RSKImageCropViewController(image: image)
    vc.delegate = self
    openViewController(vc)
  }
  
  public func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
    controller.dismissViewControllerAnimated(true) {
      self.photo.image = croppedImage
      self.photo.asFadable()
      self.didShot(image: croppedImage)
    }
  }
  
  public func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
    controller.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override public func layoutUI() {
    super.layoutUI()
    layout([background.layout([photo, camera])])
  }
  
  override public func styleUI() {
    super.styleUI()
    photo.styledAsFill().bordered(0.5, color: K.Color.text.CGColor)
    camera.backgroundColored(UIColor.whiteColor())
    camera.hidden = !enabledEdit
  }
  
  override public func bindUI() {
    super.bindUI()
    background.whenTappedWithSubviews(self, action: #selector(cameraTapped))
  }
  
  func cameraTapped() {
    if enabledEdit {
      openImagePicker()
    }
  }
  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    parentViewController()!.dismissViewControllerAnimated(true, completion: nil)
    cropImage(image)
  }
  
  var cameraSize: CGFloat { get { return width * 0.06 } }
  
  override public func layoutSubviews() {
    super.layoutSubviews()
    background.fillSuperview()
    camera.anchorInCorner(.BottomRight, xPad: 0, yPad: 0, width: 5 * cameraSize, height: camera.width)
    
    styleUI()
    didLayoutSubViews()
  }
  
  func didLayoutSubViews() {
    photo.fillSuperview()
    photo.makeCircleLike()
    camera.makeCircleLike().bordered(1.0, color: UIColor.lightGrayColor().CGColor)
    if camera.width > 0 {      
      camera.setImage(getIcon(.Camera, options: ["color": UIColor.lightGrayColor(), "size": camera.width * 0.7]), forState: .Normal)
    }
  }
  
}