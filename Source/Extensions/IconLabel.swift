//  IconLabelView.swift

import UIKit

class IconLabelWithBadge: IconLabel {
  var badge = Badge(size: 11, value: "")

  override func layoutUI() {
    super.layoutUI()
    layout([badge])
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}

class IconLabel: DefaultView {

  enum Type: String {
    case UIImage
    case IconFont
    case None
  }

  enum AlignStyle: String {
    case Left
    case Center
    case Right
  }

  private var type: Type = .None
  var alignStyle: AlignStyle = .Left

  var iconBorder = UIView()
  var iconImage = UIImageView()
  var iconFont = UILabel()
  var label = UILabel()

  private var labelWidth_: CGFloat? {
    didSet { layoutSubviews() }
  }

  var labelWidth: CGFloat {
    get { return label.textWidth() }
    set { labelWidth_ = newValue }
  }

  var iconCode: String = "" { didSet { setIconFont() } }
  var iconColor = K.Color.buttonBg { didSet { setIconFont() } }
  var labelColor = K.Color.buttonBg { didSet { setLabelColor() } }

  var color = K.Color.buttonBg { didSet { iconColor = color; labelColor = color } }

  var autoWidth: CGFloat { get { return height + paddingBetween + label.textWidth() } }
  var paddingBetween: CGFloat { get { return paddingBetween_ ?? height * 0.2 } set { paddingBetween_ = newValue } }
  var paddingBetween_: CGFloat?

  var text: String! {
    get { return label.text }
    set { label.text = newValue }
  }

  var image: UIImage! {
    didSet {
      type = .UIImage
      iconImage.image = image
      layoutUI()
    }
  }

  init() { super.init(frame: CGRectZero) }

  init(iconImage: UIImage) {
    self.iconImage.image = iconImage
    super.init(frame: CGRectZero)
  }

  init(iconImage: UIImage!, text: String) {
    type = .UIImage
    self.iconImage.image = iconImage
    super.init(frame: CGRectZero)
    self.text = text
  }

  init(iconCode: String, text: String) {
    self.type = .IconFont
    super.init(frame: CGRectZero)
    ({ self.iconCode = iconCode })()
    self.text = text
  }

  init(iconCode: String) {
    self.type = .IconFont
    super.init(frame: CGRectZero)
    ({ self.iconCode = iconCode })()
  }

  init(iconCode: String, iconColor: UIColor) {
    self.type = .IconFont
    super.init(frame: CGRectZero)
    ({ self.iconCode = iconCode })()
    ({ self.iconColor = iconColor })()
  }

  override func layoutUI() {
    super.layoutUI()
    switch type {
    case .IconFont:
      layout([iconBorder.layout([iconFont]), label])
    case .UIImage:
      layout([iconBorder.layout([iconImage]), label])
    default:
      layout([label])
    }
  }

  private func setIconFont() {
    if iconCode != "" {
      type = .IconFont
      removeSubviews()
      layoutUI()
      iconFont.text(iconCode)
      iconFont.font = UIFont(name: K.Font.icon, size: height)
      iconFont.textColor = iconColor
      layoutSubviews()
    }
  }
  private func setLabelColor() { label.colored(labelColor) }

  override func layoutSubviews() {
    super.layoutSubviews()
    let s = iconBorder.height() * 0.8
    iconFont.font = UIFont(name: K.Font.icon, size: s)

    switch alignStyle {
    case .Center:
      let w = (labelWidth_ ?? label.textWidth())
      iconBorder.anchorAndFillEdge(.Left, xPad: (width - s - paddingBetween - w) / 2, yPad: height * 0.1, otherSize: s)
      label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: paddingBetween * 0.4, width: w, height: iconBorder.height)
      label.sized(s * 0.7)
    default:
      let w = (labelWidth_ ?? label.textWidth()) * 1.2
      iconBorder.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: height)

      switch type {
      case .IconFont:
//        iconFont.anchorInCenter(width: s, height: s)

        label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: paddingBetween, width: w, height: iconBorder.height)
        label.sized(label.height * 0.8)
      case .UIImage:
//        iconImage.anchorInCenter(width: s, height: s)
        label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: paddingBetween, width: w, height: iconBorder.height)
        label.sized(label.height * 0.8)
      default:
        label.sized(height)
        label.anchorInCenter(width: label.textWidth(), height: label.textHeight())
      }
    }
    iconFont.anchorInCenter(width: s, height: s)
    iconImage.anchorInCenter(width: s, height: s)
  }

  func textHeight() -> CGFloat {
    return label.textHeight()
  }

  func text(text: String) -> IconLabel {
    label.text(text).colored(labelColor)
    return self
  }

  func styled(options: NSDictionary = NSDictionary()) -> IconLabel {
    label.styled(options)
    return self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
