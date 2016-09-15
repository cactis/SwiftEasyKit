//
//  IconLabelButton.swift


import UIKit

public class IconLabelButton: UIView {

  public var icon = UIImageView()
  public var label = UILabel()
  public var badge: Badge?

  public var size: CGFloat!

  public var text: String! = Lorem.name() {
    didSet {
      label.text = text
    }
  }

  public var image: UIImage! = UIImage.sample() { didSet { icon.image = image } }

  public var padding: CGFloat! = 5
  public var xPad: CGFloat = 0
  public var yPad: CGFloat = 0

  public init(image: UIImage!, text: String!, size: CGFloat? = 12) {
    self.image = image
    self.text = text
    self.size = size!
    super.init(frame: CGRectZero)
    icon = addImageView(image)
    badge = icon.addView(Badge(size: size! * 0.7)) as? Badge
    label = addLabelWithSize(size, text: text)
    label.centered()
  }

  init(text: String!, size: CGFloat? = 12) {
    self.text = text
    self.size = size!
    super.init(frame: CGRectZero)
    label = addLabelWithSize(size, text: text)
    label.centered()
  }

  override init(frame: CGRect) { super.init(frame: frame) }

  override public func layoutSubviews() {
    super.layoutSubviews()
    if icon.image != nil {
      icon.anchorAndFillEdge(.Top, xPad: xPad, yPad: yPad, otherSize: height * 0.75)
      label.alignUnder(icon, matchingCenterWithTopPadding: padding, width: label.textWidth(), height: label.textHeight())
    } else {
      groupAndFill(group: .Vertical, views: [label], padding: padding)
    }
    badge?.layoutSubviews()
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
