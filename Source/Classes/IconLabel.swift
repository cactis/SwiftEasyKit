//  IconLabelView.swift

import UIKit

open class IconLabelWithBadge: IconLabel {
  public var badge = Badge(size: 11, value: "")

  override open func layoutUI() {
    super.layoutUI()
    layout([badge])
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    badge.align(toTheRightOf: label, matchingTopWithLeftPadding: 10, width: 30, height: 20)
  }
}

open class IconLabel: DefaultView {

  public enum `Type`: String {
    case UIImage
    case IconFont
    case None
  }

  public enum AlignStyle: String {
    case left
    case center
    case right
  }

  public var bolded: Bool = false { didSet { label.bold(bolded) } }

  public var type: Type = .None
  public var alignStyle: AlignStyle = .left

  public var iconBorder = UIView()
  public var iconImage = UIImageView()
  public var iconFont = UILabel()
  public var label = UILabel()

  private var labelWidth_: CGFloat? { didSet { layoutSubviews() } }

  public var labelWidth: CGFloat {
    get { return label.textWidth() }
    set { labelWidth_ = newValue }
  }

  public var iconCode: String = "" { didSet { setIconFont() } }
  public var iconColor = K.Color.buttonBg { didSet { setIconFont() } }
  public var labelColor = K.Color.buttonBg { didSet { setLabelColor() } }

  public var color = K.Color.buttonBg { didSet { iconColor = color; labelColor = color } }

  public var autoWidth: CGFloat { get { return height + paddingBetween + label.textWidth() } }
  public var paddingBetween: CGFloat { get { return paddingBetween_ ?? iconBorder.width() * 0.5 } set { paddingBetween_ = newValue } }
  public var paddingBetween_: CGFloat?

  public var iconSize: CGFloat?

  public var text: String! {
    get { return label.text }
    set { label.text = newValue }
  }

  public var image: UIImage! {
    didSet {
      type = .UIImage
      iconImage.image = image
      layoutUI()
    }
  }

  public init() { super.init(frame: .zero) }

  public init(iconImage: UIImage) {
    self.iconImage.image = iconImage
    super.init(frame: .zero)
  }

  public init(iconImage: UIImage!, text: String, align: AlignStyle = .left) {
    type = .UIImage
    self.iconImage.image = iconImage
    super.init(frame: .zero)
    self.text = text
    self.alignStyle = align
  }

  public init(iconCode: String, text: String) {
    self.type = .IconFont
    super.init(frame: .zero)
    ({ self.iconCode = iconCode })()
    self.text = text
  }

  public init(iconCode: String) {
    self.type = .IconFont
    super.init(frame: .zero)
    ({ self.iconCode = iconCode })()
  }

  public init(iconCode: String, text: String, iconColor: UIColor) {
    self.type = .IconFont
    super.init(frame: .zero)
    ({ self.iconCode = iconCode })()
    ({ self.text = text })()
    ({ self.iconColor = iconColor })()
  }

  public init(iconCode: String, iconColor: UIColor) {
    self.type = .IconFont
    super.init(frame: .zero)
    ({ self.iconCode = iconCode })()
    ({ self.iconColor = iconColor })()
  }

  override open func layoutUI() {
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

  public func setIconFont() {
    if !iconCode.isEmpty {
      type = .IconFont
      removeSubviews()
      layoutUI()
      iconFont.texted(iconCode)
      iconFont.font = UIFont(name: K.Font.icon, size: height)
      iconFont.textColor = iconColor
      layoutSubviews()
    }
  }
  public func setLabelColor() {
    label.colored(labelColor)
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    let s = iconSize ?? iconBorder.height() * 0.8
    iconFont.font = UIFont(name: K.Font.icon, size: s)
    switch alignStyle {
    case .center:
      switch type {
      case .IconFont:
        let w = (labelWidth_ ?? label.textWidth())
        iconBorder.anchorAndFillEdge(.left, xPad: (width - s - paddingBetween - w) / 2, yPad: height * 0.1, otherSize: s)
        label.align(toTheRightOf: iconBorder, matchingTopWithLeftPadding: paddingBetween * 0.4, width: w, height: iconBorder.height)
      case .UIImage:
        let s = height * 0.8
        let h = height * 0.1
        iconBorder.anchorInCorner(.topLeft, xPad: (width - s - paddingBetween - label.textWidth()) / 2, yPad: h, width: s, height: s)
        let p = s * 0.1
        iconImage.fillSuperview(left: p, right: p, top: p, bottom: p)
        label.align(toTheRightOf: iconBorder, matchingTopWithLeftPadding: paddingBetween, width: label.textWidth(), height: iconBorder.height)
      default:
        break
      }

    default:
      let w = (labelWidth_ ?? width - iconBorder.rightEdge())// * 1.2
      let p = height * 0.1
      iconBorder.anchorAndFillEdge(.left, xPad: p, yPad: 0, otherSize: height)
//      label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: [[p, w * 0.2].maxElement()!, 5].minElement()!, width: w, height: iconBorder.height)
      label.align(toTheRightOf: iconBorder, matchingTopWithLeftPadding: iconBorder.width() * 0.2, width: w, height: iconBorder.height)

      switch type {
      case .IconFont:
        label.sized(label.height * 0.7).bold(bolded)
      case .UIImage:
        let p = iconBorder.height * 0.1
        iconImage.fillSuperview(left: p, right: p, top: p, bottom: p)
        label.sized(label.height * 0.8).bold(bolded)
      default:
        let s = height * 0.2
        label.fillSuperview(left: s, right: s, top: s, bottom: s)
      }
    }

    // *** hacked for not center ***
    iconFont.anchorInCenter(withWidth: s, height: s)
  }

  public func textHeight() -> CGFloat {
    return label.textHeight()
  }

  public func texted(_ text: String?) -> IconLabel {
    guard let _ = text else { return self }
    label.texted(text!).colored(labelColor)
    return self
  }

  public func styled(_ options: NSDictionary = NSDictionary()) -> IconLabel {
    label.styled(options)
    return self
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
