//  IconLabelView.swift

import UIKit

public class IconLabelWithBadge: IconLabel {
  public var badge = Badge(size: 11, value: "")

  override public func layoutUI() {
    super.layoutUI()
    layout([badge])
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
  }
}

public class IconLabel: DefaultView {

  public enum Type: String {
    case UIImage
    case IconFont
    case None
  }

  public enum AlignStyle: String {
    case Left
    case Center
    case Right
  }
  
  public var bolded: Bool = false { didSet { label.bold(bolded) } }

  public var type: Type = .None
  public var alignStyle: AlignStyle = .Left

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

  public init() { super.init(frame: CGRectZero) }

  public init(iconImage: UIImage) {
    self.iconImage.image = iconImage
    super.init(frame: CGRectZero)
  }

  public init(iconImage: UIImage!, text: String, align: AlignStyle = .Left) {
    type = .UIImage
    self.iconImage.image = iconImage
    super.init(frame: CGRectZero)
    self.text = text
    self.alignStyle = align
  }

  public init(iconCode: String, text: String) {
    self.type = .IconFont
    super.init(frame: CGRectZero)
    ({ self.iconCode = iconCode })()
    self.text = text
  }

  public init(iconCode: String) {
    self.type = .IconFont
    super.init(frame: CGRectZero)
    ({ self.iconCode = iconCode })()
  }

  public init(iconCode: String, text: String, iconColor: UIColor) {
    self.type = .IconFont
    super.init(frame: CGRectZero)
    ({ self.iconCode = iconCode })()
    ({ self.text = text })()
    ({ self.iconColor = iconColor })()
  }

  public init(iconCode: String, iconColor: UIColor) {
    self.type = .IconFont
    super.init(frame: CGRectZero)
    ({ self.iconCode = iconCode })()
    ({ self.iconColor = iconColor })()
  }

  override public func layoutUI() {
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
      iconFont.text(iconCode)
      iconFont.font = UIFont(name: K.Font.icon, size: height)
      iconFont.textColor = iconColor
      layoutSubviews()
    }
  }
  public func setLabelColor() {
    label.colored(labelColor)
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    let s = iconSize ?? iconBorder.height() * 0.8
    iconFont.font = UIFont(name: K.Font.icon, size: s)
    switch alignStyle {
    case .Center:
      switch type {
      case .IconFont:
        let w = (labelWidth_ ?? label.textWidth())
        iconBorder.anchorAndFillEdge(.Left, xPad: (width - s - paddingBetween - w) / 2, yPad: height * 0.1, otherSize: s)
        label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: paddingBetween * 0.4, width: w, height: iconBorder.height)
//        label.sized(s).bold(bolded)
      case .UIImage:
        let s = height * 0.8
        let h = height * 0.1
//        label.sized(s * 0.6).bold(bolded)
        iconBorder.anchorInCorner(.TopLeft, xPad: (width - s - paddingBetween - label.textWidth()) / 2, yPad: h, width: s, height: s)
        let p = s * 0.1
        iconImage.fillSuperview(left: p, right: p, top: p, bottom: p)
        label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: paddingBetween, width: label.textWidth(), height: iconBorder.height)
      default:
        break
      }

    default:
      let w = (labelWidth_ ?? width - iconBorder.rightEdge())// * 1.2
      iconBorder.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: height)
      label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: paddingBetween, width: w, height: iconBorder.height)
      switch type {
      case .IconFont:
        label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: paddingBetween, width: w, height: iconBorder.height)
//        label.sized(label.height * 0.33).bold(bolded)
      case .UIImage:
        let p = iconBorder.height * 0.1
        iconImage.fillSuperview(left: p, right: p, top: p, bottom: p)
//        label.alignToTheRightOf(iconBorder, matchingTopWithLeftPadding: paddingBetween, width: width - iconBorder.rightEdge(), height: iconBorder.height)
//        label.sized(iconImage.height * 0.8).bold(bolded)
      default:
        label.anchorInCenter(width: label.textWidth(), height: label.textHeight())
      }
      label.sized(label.height * 0.8).bold(bolded)
    }

    // *** hacked for not center ***
    iconFont.anchorInCenter(width: s, height: s)
//    iconImage.anchorInCenter(width: s, height: s)
    //    iconFont.anchorToEdge(.Top, padding: s * 0.2, width: s, height: s)
    //    iconImage.anchorToEdge(.Top, padding: s * 0.2, width: s, height: s)
  }

  public func textHeight() -> CGFloat {
    return label.textHeight()
  }

  public func text(text: String?) -> IconLabel {
    guard let _ = text else { return self }
    label.text(text!).colored(labelColor)
    return self
  }

  public func styled(options: NSDictionary = NSDictionary()) -> IconLabel {
    label.styled(options)
    return self
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
