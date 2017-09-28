//
//  UIView.swift
//
//  Created by ctslin on 5/18/16.
//

import Foundation
import MapKit
import LoremIpsum
import FontAwesome_swift
import Neon
// import RandomKit
import SwiftRandom

extension UIView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  public var rightPadding: CGFloat { get { return superview != nil ? superview!.width - rightEdge() : 0 } }
  public var topPadding: CGFloat { get { return topEdge() } }
  public var leftPadding: CGFloat { get { return rightEdge() } }
  public var bottomPadding: CGFloat { get { return superview != nil ? superview!.height - bottomEdge() : 0 } }


  @discardableResult public func saveAsImageToAlbum() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
    return image!
  }

  @discardableResult public func navBarHeight() -> CGFloat {
    return parentViewController()!.navBarHeight()
  }

  @discardableResult public func viewNetHeight() -> CGFloat {
    return parentViewController()!.viewNetHeight()
  }

  @discardableResult public func tabBarHeight() -> CGFloat {
    return parentViewController()!.tabBarHeight()
  }

  public func addHorizontalLineBetween(_ views: [UIView]) {
    (0...views.count - 2).forEach { (i) in
      addHorizontalLineBetween(views[i], v2: views[i + 1])
    }
  }

  @discardableResult public func addHorizontalLineBetween(_ v1: UIView, v2: UIView) -> UIView {
    let line = addLine()
    let m = (v2.y - v1.bottomEdge()) / 2
    let w = [v1.rightEdge(), v2.rightEdge()].max()! - [v1.x, v2.x].min()!
    if v1.x < v2.x {
      line.alignUnder(v1, matchingLeftWithTopPadding: m, width: w, height: K.Line.size)
    } else {
      line.align(above: v2, matchingLeftWithBottomPadding: m, width: w, height: K.Line.size)
    }
    return line
  }

  public func addVerticalLineBetween(_ views: [UIView], fill: Bool = true) {
    (0...views.count - 2).forEach { (i) in
      addVerticalLineBetween(views[i], v2: views[i + 1], fill: fill)
    }
  }

  @discardableResult public func addVerticalLineBetween(_ v1: UIView, v2: UIView, fill: Bool = true) -> UIView {
    let line = addLine()

    if v1.y < v2.y {
      if fill {
        let p = (v2.x - v1.rightEdge()) / 2
        let h = [v1.bottomEdge(), v2.bottomEdge()].max()! - [v1.y, v2.y].min()!
        line.align(toTheRightOf: v1, matchingTopWithLeftPadding: p, width: K.Line.size, height: h)
      } else {
        let p = (v2.x - v1.rightEdge()) / 2
        let h = [v1.bottomEdge(), v2.bottomEdge()].min()! - [v1.y, v2.y].max()!
        line.align(toTheLeftOf: v2, matchingTopWithRightPadding: p, width: K.Line.size, height: h)
      }
    } else {
      if fill {
        let p = (v2.x - v1.rightEdge()) / 2
        let h = [v1.bottomEdge(), v2.bottomEdge()].max()! - [v1.y, v2.y].min()!
        line.align(toTheLeftOf: v2, matchingTopWithRightPadding: p, width: K.Line.size, height: h)
      } else {
        let p = (v2.x - v1.rightEdge()) / 2
        let h = [v1.bottomEdge(), v2.bottomEdge()].min()! - [v1.y, v2.y].max()!
        line.align(toTheRightOf: v1, matchingTopWithLeftPadding: p, width: K.Line.size, height: h)
      }
    }
    return line
  }

  public func openViewController(_ vc: UIViewController, style: UIModalTransitionStyle = .coverVertical, run: @escaping ()->() = {}) {
    openControllerWithDelegate(parentViewController()!, vc: vc, style: style, run: run)
  }

  public func openController(_ vc: UIViewController, type: String = kCATransitionFromTop, subtype: String = kCATransitionReveal, run: @escaping () -> () = {}) {
    let nv = UINavigationController()
    let transition: CATransition = CATransition()
    nv.pushViewController(vc, animated: false)
    transition.duration = 0.5
    transition.type = type
    transition.subtype = subtype
    window?.layer.add(transition, forKey: kCATransition)
    parentViewController()?.present(nv, animated: false, completion: {
      run()
    })
  }

  @discardableResult public func collectionView(_ layout: UICollectionViewFlowLayout, registeredClass: AnyClass!, identifier: String, sectionInset: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10), direction: UICollectionViewScrollDirection = .horizontal) -> UICollectionView {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    layout.scrollDirection = direction
    layout.itemSize = CGSize(width: 100, height: 100)
    layout.sectionInset = sectionInset
    collectionView.delegate = self as? UICollectionViewDelegate
    collectionView.dataSource = self as? UICollectionViewDataSource
    collectionView.register(registeredClass, forCellWithReuseIdentifier: identifier)
    return collectionView
  }

  @objc @discardableResult public func backgroundColored(_ color: UIColor) -> UIView {
    backgroundColor = color
    return self
  }

  @discardableResult public func blured(_ target: UIView, style: UIBlurEffectStyle = .dark) -> UIView {
    let blurEffectView: UIVisualEffectView!
    let blurEffect = UIBlurEffect(style: style)
    blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = target.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation

    //    let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
    //    let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
    //    vibrancyEffectView.frame = view.bounds
    //    blurEffectView.contentView.addSubview(vibrancyEffectView)

    //    addSubview(blurEffectView)
    insertSubview(blurEffectView, at: 0)
    return self
  }

  @discardableResult public func removeSubviews() -> UIView {
    subviews.forEach { $0.removeFromSuperview() }
    return self
  }

  //  public func views(var views: [UIView]) -> [UIView] {
  //    for i in 0...views.count - 1 {
  //      views[i] = view()
  //    }
  //    return views
  //  }

  @discardableResult public func addTableView(_ registeredClass: AnyClass!, identifier: String) -> UITableView {
    return addView(tableView(registeredClass, identifier: identifier)) as! UITableView
  }

  @discardableResult public func tableView(_ registeredClass: AnyClass!, identifier: String, style: UITableViewStyle = .plain) -> UITableView {
    let tableView = UITableView(frame: bounds, style: style)
    tableView.delegate = (self.parentViewController() ?? self ) as? UITableViewDelegate
    tableView.dataSource = (self.parentViewController() ?? self) as? UITableViewDataSource
    tableView.estimatedRowHeight = 20.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorStyle = .none
    tableView.register(registeredClass, forCellReuseIdentifier: identifier)
    addSubview(tableView)
    return tableView
  }

  public func pushViewController(_ vc: UIViewController, checked: Bool = true, delayed: Double = 0, onComplete: () -> () = {}, onDismissViewController: @escaping () -> () = {}) {
//    if let _ = parentViewController() {
//      if !(parentViewController()?.navigationController?.topViewController?.isKindOfClass(vc.self.dynamicType))! {
        parentViewController()?.pushViewController(vc, checked: checked, delayed: delayed, onComplete: onComplete, onDismissViewController: onDismissViewController)
//      }
//    }
  }

  @objc @discardableResult public func layout(_ views: [UIView]) -> UIView {
    views.forEach { (view) -> () in
      self.addSubview(view)
    }
    return self
  }

 public func setFieldsGroup(_ fields: [UITextField], delegate: AnyObject) -> Void {
    let delegateObject = delegate as? UITextFieldDelegate
    for index in 0...fields.count - 2 {
      fields[index].delegate = delegateObject
      fields[index].nextField = fields[index + 1]
    }
    fields.last?.delegate = delegateObject
  }

 public func setFieldsGroup(_ fields: [UITextField]) -> Void {
    let delegate = parentViewController() as! UITextFieldDelegate
    setFieldsGroup(fields, delegate: delegate)
  }

 public func setViewsGroup(_ fields: [UITextView]) -> Void {
    let delegate = parentViewController() as? UITextViewDelegate
    for index in 0...fields.count - 2 {
      fields[index].delegate = delegate
      fields[index].nextField = fields[index + 1]
    }
    fields.last?.delegate = delegate
  }

  public func openPopupDialogFromView(_ view: UIView, completion: @escaping () -> () = {}) {
    let popupVC = PopupViewController()
    popupVC.modalPresentationStyle = .overCurrentContext
    popupVC.contentView = view
    parentViewController()!.present(popupVC, animated: true) { () -> Void in
      completion()
    }
  }

  public func openPopupDialog(_ viewClass: NSObject.Type, delegate: UIView = UIView(), autoDismiss: Bool = false, onCompletion: @escaping (_ popupView: AnyObject) -> () = {_ in }, didDismiss: @escaping (_ popupView: PopupView) -> () = {_ in }, didSuccess: @escaping (_ popupView: PopupView) -> () = {_ in}) {
    let popupVC = PopupViewController()
    popupVC.autoDismiss = autoDismiss
    popupVC.modalPresentationStyle = .overCurrentContext
    let popupView = viewClass.init()
    popupVC.contentView = popupView as! UIView
//    (popupVC as? PopupView)?.didDismiss = didDismiss
    (popupView as? PopupView)?.didDismiss = didDismiss
    (popupView as? PopupView)!.delegate = delegate
    (popupView as? PopupView)?.didSuccess = didSuccess
    parentViewController()!.present(popupVC, animated: true) { () -> Void in
      onCompletion(popupView)
    }
  }

  @discardableResult public func addTextArea(_ placeholder: String, options: NSDictionary = NSDictionary()) -> UITextView {
    let view: UITextView = UITextView()
    if options["bordered"] != nil {
      view.bordered(1.0, color: UIColor.lightGray.lighter().cgColor)
    }
    view.isEditable = true
    view.layer.borderColor = UIColor.lightGray.cgColor
    view.layer.borderWidth = 1.0
    view.font = UIFont.systemFont(ofSize: 16)
    view.textContainerInset = UIEdgeInsetsMake(5, 2, 5, 2)
    addSubview(view)
    return view
  }

  @discardableResult public func addTextField(_ placeholder: String, text: String = "", options: NSDictionary = NSDictionary()) -> TextField {
    let view = TextField()
    view.placeholder = placeholder
    view.font = UIFont.systemFont(ofSize: 16)
    view.contentVerticalAlignment = .center
    view.text = text
    view.textColor = K.Color.text
    addSubview(view)
    return view
  }

  @discardableResult public func addTextFieldWithBorder(_ placeholder: String, text: String = "", options: NSDictionary = NSDictionary()) -> TextField {
    let view = addTextField(placeholder, options: options)
    view.layer.borderColor = UIColor.lightGray.lighter().cgColor
    view.layer.borderWidth = 1.0
    view.text = text
    addSubview(view)
    return view
  }

  @discardableResult public func addTextAreaWithBorder(_ placeholder: String, value: String = "", options: NSDictionary = NSDictionary()) -> UITextView {
    let view = addTextArea(placeholder, options: options)
    view.layer.borderColor = UIColor.lightGray.lighter().cgColor
    view.layer.borderWidth = 1.0
    addSubview(view)
    return view
  }

  @discardableResult public func addPassword(_ placeholder: String, text: String, options: NSDictionary = NSDictionary()) -> TextField {
    let password = addPassword(placeholder, options: options)
    password.text = text
    return password
  }

  @discardableResult public func addPassword(_ placeholder: String, options: NSDictionary = NSDictionary()) -> TextField {
    let text = addTextField(placeholder, options: options)
    text.isSecureTextEntry = true
    return text
  }

  public func animate(_ duration: Double = 0.5, onComplete: @escaping () -> ()) {
    //    UIView.animateWithDuration(duration) { () -> Void in
    //      onComplete()
    //    }
    UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: onComplete, completion: nil)
  }

  @discardableResult public func asFadable(_ duration: Double = 0.5) -> UIView {
    UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: nil, completion: nil)
    return self
  }

  @discardableResult public func addMap(_ options: NSDictionary = NSDictionary()) -> MKMapView {
    let view: MKMapView = MKMapView()
    addSubview(view)
    return view
  }

  @discardableResult public func addSample() -> UILabel {
    let label = self.addLabel(LoremIpsum.sentence())
    return label
  }

  @discardableResult public func addScrollView() -> UIScrollView {
    let scrollView = UIScrollView()
    addSubview(scrollView)
    return scrollView
  }

  @discardableResult public func topEdge() -> CGFloat {
    return y
  }

  @discardableResult public func leftEdge() -> CGFloat {
    return x
  }

  @discardableResult public func rightEdge() -> CGFloat {
    return x + width
  }

  @discardableResult public func bottomEdge() -> CGFloat {
    return frame.origin.y + frame.size.height
  }

  @discardableResult public func addLine(_ color: UIColor = K.Line.Color.horizontal) -> UIView {
    let line = addView()
    line.backgroundColor = color
    return line
  }

  @discardableResult public func addView(_ v: UIView = UIView(), options: NSDictionary = NSDictionary()) -> UIView {
    let v = view(v, options: options)
    addSubview(v)
    return v
  }

  @discardableResult public func view(_ v: UIView = UIView(), options: NSDictionary = NSDictionary()) -> UIView {
    return v
  }

  @discardableResult public func addMarginedView(_ options: NSDictionary = NSDictionary()) -> UIView {
    let view = addView()
    let marginedView = view.addView()
    return marginedView
  }

  @discardableResult public func addIconButton(_ text: String, icon: UIImage, target: AnyObject, action: Selector, options: NSDictionary = NSDictionary()) -> UIButton {
    let button: UIButton = addButton(text, options: options)
    button.setImage(icon, for: .normal)
    return button
  }


  @discardableResult public func iconButton(_ icon: FontAwesome, size: CGFloat = K.BarButtonItem.size * 2, color: UIColor = K.Color.barButtonItem, options: NSDictionary = NSDictionary()) -> UIButton {
    let btn = button("", options: options)
    btn.setImage(UIImage.fontAwesomeIcon(name: icon, textColor: color, size: CGSize(width: size, height: size)), for: .normal)
    return btn
  }

  @discardableResult public func addIconButton(_ icon: UIImage, target: AnyObject, action: Selector, options: NSDictionary = NSDictionary()) -> UIButton {
    let button = addButton("", target: target, action: action, options: options)
    button.setImage(icon, for: .normal)
    return button
  }

  @discardableResult public func addButton(_ text: String = "", target: AnyObject, action: Selector, options: NSDictionary = NSDictionary()) -> UIButton {
    let button: UIButton = addButton(text, options: options)
    //    view.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    button.radiused(2)
    button.whenTapped(target, action: action)
    //    button.whenTapped { () -> Void in
    //      self.performSelector(action)
    //    }
    return button
  }

  @discardableResult public func addSubmit(_ text: String = "", options: NSDictionary = NSDictionary()) -> UIButton {
    let button = addButton(text, options: options)
    button.styledAsSubmit()
    return button
  }
  @discardableResult public func addSubmit(_ text: String = "確定", target: AnyObject, action: Selector, options: NSDictionary = NSDictionary()) -> UIButton {
    let button = addButton(text, target: target, action: action, options: options)
    button.styledAsSubmit()
    return button
  }

  @discardableResult public func addButton(_ text: String = Lorem.name(), options: NSDictionary = NSDictionary()) -> UIButton {
    let btn = button(text, options: options)
    addSubview(btn)
    return btn
  }

  @discardableResult public func button(_ text: String = Lorem.name(), options: NSDictionary = NSDictionary()) -> UIButton {
    let view: UIButton = UIButton(type: .custom)
    view.styled(text, options: options)
    return view
  }

  @discardableResult public func addImageView(_ image: UIImage! = UIImage.sample()) -> UIImageView {
    let view = imageView(image)
    addSubview(view)
    return view
  }

  //  public func imageViewAsFill(image: UIImage! = UIImage.sample()) -> UIImageView {
  //    let view = UIImageView()
  //    view.image = image
  //    view.contentMode = .ScaleAspectFill
  ////    view.autoresizingMask = [.FlexibleHeight]//, .FlexibleWidth]
  ////    view.layer.masksToBounds = true
  //    view.clipsToBounds = true
  //    return view
  //  }

  @discardableResult public func imageView(_ image: UIImage! = UIImage.sample()) -> UIImageView {
    let imageView = UIImageView()
    imageView.styled(image)
    return imageView
  }

  @discardableResult public func addImageViewAsFill(_ image: UIImage! = UIImage.sample()) -> UIImageView {
    let view = imageView(image)
    view.styledAsFill()
    addSubview(view)
    return view
  }

  @discardableResult public func addIcon(_ name: FontAwesome) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage.fontAwesomeIcon(name: name, textColor: UIColor.gray, size: CGSize(width: 12, height: 12))
    self.addSubview(imageView)
    return imageView
  }

  @discardableResult public func addIconLabelButton(_ image: UIImage!, title: String!, size: CGFloat = 14, target: AnyObject, action: Selector?) -> IconLabelButton {
    let view = IconLabelButton(image: image, text: title, size: size)
    view.whenTapped(target, action: action!)
    addSubview(view)
    return view
  }

  @discardableResult public func iconLabel(_ title: String = Lorem.sentence(), icon: FontAwesome = .gear, options: NSDictionary = NSDictionary()) -> IconLabel {
    let color = options["color"] as? UIColor ?? K.Color.text
    let size = options["fontSize"] as? CGFloat ?? K.Size.Text.small
    let cgSize = CGSize(width: size, height: size)
    let image = UIImage.fontAwesomeIcon(name: icon, textColor: color, size: cgSize)
    return iconLabel(title, icon: image, options: options)
  }

  @discardableResult public func iconLabel(_ title: String = Lorem.sentence(), icon: UIImage, options: NSDictionary = NSDictionary()) -> IconLabel {
    let color = options["color"] as? UIColor ?? K.Color.text
    let size = options["fontSize"] as? CGFloat ?? K.Size.Text.small
    let iconLabel = IconLabel(iconImage: icon, text: title)
    iconLabel.label.font = UIFont.systemFont(ofSize: size)
    iconLabel.label.textColor = color
    return iconLabel
  }

  @discardableResult public func addIconLabel(_ title: String = Lorem.sentence(), icon: FontAwesome = .gear, options: NSDictionary = NSDictionary()) -> IconLabel {
    let color = options["color"] as? UIColor ?? K.Color.text
    let size = options["fontSize"] as? CGFloat ?? K.Size.Text.small
    let cgSize = CGSize(width: size, height: size)
    let image = UIImage.fontAwesomeIcon(name: icon, textColor: color, size: cgSize)
    return addIconLabel(title, image: image, options: options)
  }

  @discardableResult public func addIconLabel(_ title: String, image: UIImage, options: NSDictionary = NSDictionary()) -> IconLabel {
    let fontSize = options["fontSize"] as? CGFloat ?? K.Size.Text.small
    let color = options["color"] as? UIColor ?? K.Color.text
    let iconLabel = IconLabel(iconImage: image, text: title)
    iconLabel.label.font = UIFont.systemFont(ofSize: fontSize)
    iconLabel.label.textColor = color
    addSubview(iconLabel)
    return iconLabel
  }

  @discardableResult public func addLabelWithIcon(_ title: String, icon: FontAwesome, options: NSDictionary = NSDictionary()) -> UIButton {
    let fontSize = options["fontSize"] as? CGFloat ?? K.Size.Text.normal
    let color = options["color"] as? UIColor ?? K.Color.dark
    let icon = UIImage.fontAwesomeIcon(name: icon, textColor: color, size: CGSize(width: fontSize + 2, height: fontSize + 2))
    return addLabelWithIcon(title, icon: icon, options: options)
  }

  @discardableResult public func addLabelWithIcon(_ title: String, icon: UIImage, options: NSDictionary = NSDictionary()) -> UIButton {
    let fontSize = options["fontSize"] as? CGFloat ?? K.Size.Text.normal
    let color = options["color"] as? UIColor ?? K.Color.dark
    let button = UIButton(type: .custom)
    button.setImage(icon, for: .normal)
    button.setTitle(title, for: .normal)
    button.setTitleColor(color, for: .normal)
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    button.contentHorizontalAlignment = .left
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
    button.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
    addSubview(button)
    return button
  }

  @discardableResult public func groupsView(_ count: Int? = 2, padding: CGFloat? = 0, group: Neon.Group? = .horizontal, margin: UIEdgeInsets? = .zero) -> GroupsView {
    return GroupsView(count: count, padding: padding, group: group, margin: margin)
  }

  @discardableResult public func addGroupsView(_ count: Int? = 2, padding: CGFloat? = 0, group: Neon.Group? = .horizontal, margin: UIEdgeInsets? = .zero) -> GroupsView {
    let gv = groupsView(count, padding: padding, group: group, margin: margin)
    addSubview(gv)
    return gv
  }

  @discardableResult public func addMultilineLabel(_ text: String? = LoremIpsum.firstName(), options: NSDictionary = NSDictionary()) -> UILabel {
    let view = addLabel(text, options: options).multilinized()
    return view
  }

  @discardableResult public func addLabel(_ text: String? = LoremIpsum.firstName(), options: NSDictionary = NSDictionary()) -> UILabel {
    let view = label(text, options: options)
    addSubview(view)
    return view
  }

  @discardableResult public func label(_ text: String? = LoremIpsum.firstName(), options: NSDictionary = NSDictionary()) -> UILabel {
    let view = UILabel()
    if options["html"] != nil {
      view.attributedText = text!.toHtml()
    } else {
      view.text = text
    }
    return view.styled(options)
  }

  @discardableResult public func addMultiLineLabelWithSize(_ size: CGFloat!, text: String? = Lorem.sentence(), options: NSDictionary = NSDictionary()) -> UILabel {
    let view = addLabelWithSize(size, text: text, options: options)
    return view.multilinized()
  }

  @discardableResult public func addLabelWithSize(_ size: CGFloat!, text: String? = Lorem.sentence(), options: NSDictionary = NSDictionary()) -> UILabel {
    let label = addLabel(text, options: options)
    label.font = UIFont.systemFont(ofSize: size)
    return label
  }

  @discardableResult public func _coloredWithSuperviews() -> UIView {
    _coloredWithSuperviews(0)
    return self
  }

  @discardableResult public func shadowedRadius() -> UIView {
    layer.shadowColor = superview!.backgroundColor?.darker().darker().cgColor
    layer.shadowRadius = layer.cornerRadius
    layer.shadowOffset = CGSize(width: 3, height: 3)
    return self
  }

  @discardableResult public func shadowed(_ color: UIColor = K.Color.body.darker().darker(), offset: CGSize = CGSize(width: 0, height: 1)) -> UIView {
    layer.shadowColor = color.cgColor
    layer.masksToBounds = false
    layer.shadowOffset = offset
    layer.shadowRadius = 1
    layer.shadowOpacity = 0.2
    return self
  }

  @discardableResult public func makeCircleLike() -> UIView {
    let radius = width / 2
    return radiused(radius)
  }

  @discardableResult public func radiused(_ radius: CGFloat = 5) -> UIView {
    layer.cornerRadius = radius
    layer.masksToBounds = true
    return self
  }

  @discardableResult public func _coloredWithSuperviews(_ index: Int) -> UIView {
    if _isSimulator() && index < K.Color.palettes.count {
      backgroundColor = K.Color.palettes[index].withAlphaComponent(0.5)
      if let s = superview {
        s._coloredWithSuperviews(index + 1)
      }
    }
    return self
  }

  @discardableResult public func _colored(_ color: UIColor) -> UIView {
    if _isSimulator() {
      backgroundColor = color
      _bordered()
    }
    return self
  }

  @discardableResult public func _colored() -> UIView {
    _colored(K.Color.palettes.first!)
    return self
  }

  @discardableResult public func _coloredWithIndex(_ index: Int) -> UIView {
    let color = K.Color.palettes[index]
    _colored(color)
    return self
  }

  @discardableResult public func bordered(_ width: CGFloat = 1.0, color: CGColor = K.Color.border.cgColor) -> UIView {
    layer.borderWidth = width
    layer.borderColor = color
    return self
  }

  @discardableResult public func _bordered(_ width: CGFloat = 1.0, color: CGColor = UIColor.black.cgColor) -> UIView {
    if _isSimulator() {
      bordered(width, color: color)
    }
    return self
  }

  @objc @discardableResult public func whenTapped(_ target: AnyObject, action: Selector) -> UIView {
    let tap = getSingleTap(target, action: action)
    enablTapped(tap)
    //    tap.cancelsTouchesInView = true
    return self
  }

  @objc @discardableResult public func whenTappedWithSubviews(_ target: AnyObject, action: Selector) -> UIView {
    whenTapped(target, action: action)
    subviews.forEach { (view) -> () in
      view.whenTapped(target, action: action)
    }
    return self
  }

  @discardableResult private func getSingleTap(_ target: AnyObject, action: Selector) -> UIGestureRecognizer {
    return getTap(1, target: target, action: action)
  }

  @discardableResult private func getTap(_ number: Int, target: AnyObject, action: Selector) -> UIGestureRecognizer {
    let singleTap = UITapGestureRecognizer(target: target, action: action)
    singleTap.numberOfTapsRequired = 1
    singleTap.numberOfTouchesRequired = number
    return singleTap
  }

  @objc @discardableResult private func enablTapped(_ tap: UIGestureRecognizer) -> UIView {
    isUserInteractionEnabled = true
    addGestureRecognizer(tap)
    return self
  }


  @discardableResult public func opacity(_ value: Float = 0.75) -> UIView {
    layer.opacity = value
    return self
  }

//  public func basePoint() -> CGPoint {
//    return self.convertPoint(bounds.origin, toView: nil)
//  }

  @discardableResult public func _guideLined() -> UIView {
    if _isSimulator() {
      if let v = superview {
        let v1 = v.addLine(K.Color.Text.important)
        let v2 = v.addLine(K.Color.Text.important)
        let v3 = v.addLine(K.Color.Text.important)
        let v4 = v.addLine(K.Color.Text.important)
        v1.anchorAndFillEdge(.top, xPad: 0, yPad: topEdge(), otherSize: K.Line.size)
        v2.anchorAndFillEdge(.top, xPad: 0, yPad: bottomEdge(), otherSize: K.Line.size)
        v3.anchorAndFillEdge(.left, xPad: leftEdge(), yPad: 0, otherSize: K.Line.size)
        v4.anchorAndFillEdge(.left, xPad: rightEdge(), yPad: 0, otherSize: K.Line.size)
        if let s = v.superview {
          s._guideLined()
        }
      }
    }
    return self
  }

  public func graceful(_ seconds: Double = 0.4, run: () -> ()) {
    isHidden = true
    run()
    delayedJob(seconds) {
      self.asFadable()
      self.isHidden = false
    }
  }

  @discardableResult public func leftBordered(_ color: UIColor = K.Line.Color.horizontal, width: CGFloat = 1.0, padding: CGFloat = 0) -> UIView { return addBorder(.left, color: color, width: width, padding: padding) }
  @discardableResult public func rightBordered(_ color: UIColor = K.Line.Color.horizontal, width: CGFloat = 1.0, padding: CGFloat = 0) -> UIView { return addBorder(.right, color: color, width: width, padding: padding) }
  @discardableResult public func bottomBordered(_ color: UIColor = K.Line.Color.horizontal, width: CGFloat = 1.0, padding: CGFloat = 0) -> UIView { return addBorder(.bottom, color: color, width: width, padding: padding) }
  @discardableResult public func topBordered(_ color: UIColor = K.Line.Color.horizontal, width: CGFloat = 1.0, padding: CGFloat = 0) -> UIView { return addBorder(.top, color: color, width: width, padding: padding) }

  @discardableResult public func openImagePicker(_ sourceType: UIImagePickerControllerSourceType = .camera) -> UIImagePickerController {
    var type = sourceType
    if _isSimulator() { type = .photoLibrary }
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = type
    parentViewController()!.present(picker, animated: true)
    return picker
  }
}

public enum viewBorder: String {
  case left = "borderLeft"
  case right = "borderRight"
  case top = "borderTop"
  case bottom = "borderBottom"
}

extension UIView {

  @discardableResult public func addBorder(_ vBorder: viewBorder, color: UIColor = K.Line.Color.horizontal, width: CGFloat = 1.0, padding: CGFloat = 0) -> UIView {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.name = vBorder.rawValue
    removeBorder(vBorder)
    switch vBorder {
    case .left:
      border.frame = CGRect(x: 0 - padding, y: 0, width: width, height: self.frame.size.height)
    case .right:
      border.frame = CGRect(x: self.frame.size.width - width + padding, y: 0, width: width, height: self.frame.size.height)
    case .top:
      border.frame = CGRect(x: 0, y: 0 - padding, width: self.frame.size.width, height: width)
    case .bottom:
      border.frame = CGRect(x: 0, y: self.frame.size.height - width + padding, width: self.frame.size.width, height: width)
    }
    self.layer.addSublayer(border)
    return self
  }

  public func removeBorder(_ border: viewBorder) {
//    var layerForRemove: CALayer?
//    if (self.layer.sublayers?.count)! > 0 {
//      for layer in self.layer.sublayers! {
//        if layer.name == border.rawValue {
//          layerForRemove = layer
//        }
//      }
//      if let layer = layerForRemove {
//        layer.removeFromSuperlayer()
//      }
//    }
  }
}
