//
//  IconLabelButton.swift


import UIKit

class IconLabelButton: UIView {

  var icon = UIImageView()
  var label = UILabel()
  var badge: Badge?

  var size: CGFloat!

  var text: String! = Lorem.name() {
    didSet {
      label.text = text
    }
  }

  var image: UIImage! = UIImage.sample() {
    didSet {
      icon.image = image
    }
  }

  var padding: CGFloat!

  init(image: UIImage!, text: String!, size: CGFloat? = 12) {
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

  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    if icon.image != nil {
      groupAndFill(group: .Vertical, views: [icon, label], padding: 0)
    } else {
      groupAndFill(group: .Vertical, views: [label], padding: 0)
    }
    badge?.layoutSubviews()
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
