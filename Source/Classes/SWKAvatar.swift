//
//  SWKAvatar.swift
//

import UIKit
import RSKImageCropper

open class SWKAvatar: DefaultView, RSKImageCropViewControllerDelegate {

  var background = UIView()
  let camera = UIButton()
  public var photo = UIImageView(image: getIcon(.user, options: ["color": UIColor.lightGray, "size": 64])
  )

  private var enabledEdit = false {
    didSet {
      camera.isHidden = !enabledEdit
      bindUI()
    }
  }
  private var didShot: (_ image: UIImage) -> () = {_ in }

  public func enabledShotting(run: @escaping (_ image: UIImage) -> ()) {
    enabledEdit = true
    didShot = run
  }

  func cropImage(image: UIImage) {
    let vc = RSKImageCropViewController(image: image)
    vc.delegate = self
    openViewController(vc)
  }

  public func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
    controller.dismiss(animated: true) {
      self.photo.image = croppedImage
      self.photo.asFadable()
      self.didShot(croppedImage)
    }
  }

  public func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
    controller.dismiss(animated: true, completion: nil)
  }

  override open func layoutUI() {
    super.layoutUI()
    layout([background.layout([photo, camera])])
  }

  override open func styleUI() {
    super.styleUI()
    photo.styledAsFill().bordered(0.5, color: K.Color.text.cgColor)
    camera.backgroundColored(UIColor.white)
    camera.isHidden = !enabledEdit
  }

  override open func bindUI() {
    super.bindUI()
    if enabledEdit {
      background.whenTappedWithSubviews(self, action: #selector(cameraTapped))
    }
  }

  func cameraTapped() {
    openImagePicker()
  }

  func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
    parentViewController()!.dismiss(animated: true, completion: nil)
    cropImage(image: image)
  }

  var cameraSize: CGFloat { get { return width * 0.06 } }

  override open func layoutSubviews() {
    super.layoutSubviews()
    background.fillSuperview()
    camera.anchorInCorner(.bottomRight, xPad: 0, yPad: 0, width: 5 * cameraSize, height: camera.width)

    styleUI()
    didLayoutSubViews()
  }

  func didLayoutSubViews() {
    photo.fillSuperview()
    photo.makeCircleLike()
    camera.makeCircleLike().bordered(1.0, color: UIColor.lightGray.cgColor)
    if camera.width > 0 {
      camera.setImage(getIcon(.camera, options: ["color": UIColor.lightGray, "size": camera.width * 0.7]), for: .normal)
    }
  }

}
