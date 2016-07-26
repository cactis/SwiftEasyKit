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
import RandomKit
import SwiftRandom

extension UIView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  func navBarHeight() -> CGFloat {
    return parentViewController()!.navBarHeight()
  }

  func viewNetHeight() -> CGFloat {
    return parentViewController()!.viewNetHeight()
  }

  func tabBarHeight() -> CGFloat {
    return parentViewController()!.tabBarHeight()
  }

  func addHorizontalLineBetween(views: [UIView]) {
    (0...views.count - 2).forEach { (i) in
      addHorizontalLineBetween(views[i], v2: views[i + 1])
    }
  }

  func addHorizontalLineBetween(v1: UIView, v2: UIView) -> UIView {
    let line = addLine()
    let m = (v2.y - v1.bottomEdge()) / 2
    let w = [v1.rightEdge(), v2.rightEdge()].maxElement()! - [v1.x, v2.x].minElement()!
    if v1.x < v2.x {
      line.alignUnder(v1, matchingLeftWithTopPadding: m, width: w, height: K.Line.size)
    } else {
      line.alignAbove(v2, matchingLeftWithBottomPadding: m, width: w, height: K.Line.size)
    }
    return line
  }

  func addVerticalLineBetween(views: [UIView]) {
    (0...views.count - 2).forEach { (i) in
      addVerticalLineBetween(views[i], v2: views[i + 1])
    }
  }

  func addVerticalLineBetween(v1: UIView, v2: UIView) -> UIView {
    let line = addLine()
    let p = (v2.x - v1.rightEdge()) / 2
    let w = [v1.bottomEdge(), v2.bottomEdge()].maxElement()! - [v1.y, v2.y].minElement()!
    if v1.y < v2.y {
      //      line.alignRight(v1, matchingLeftWithTopPadding: m, width: w, height: K.Line.size)
      line.alignToTheRightOf(v1, matchingTopWithLeftPadding: p, width: K.Line.size, height: w)
    } else {
      //      line.alignAbove(v2, matchingLeftWithBottomPadding: m, width: K.Line.size, height: m)
      line.alignToTheLeftOf(v2, matchingTopWithRightPadding: p, width: K.Line.size, height: w)
    }
    return line
  }

  func openViewController(vc: UIViewController, style: UIModalTransitionStyle = .CoverVertical, run: ()->() = {}) {
    openControllerWithDelegate(parentViewController()!, vc: vc, style: style, run: run)
  }

  func openController(vc: UIViewController, type: String = kCATransitionFromTop, subtype: String = kCATransitionReveal, run: () -> () = {}) {
    let nv = UINavigationController()
    let transition: CATransition = CATransition()
    nv.pushViewController(vc, animated: false)
    transition.duration = 0.5
    transition.type = type
    transition.subtype = subtype
    window?.layer.addAnimation(transition, forKey: kCATransition)
    parentViewController()?.presentViewController(nv, animated: false, completion: {
      run()
    })
  }

  func collectionView(layout: UICollectionViewFlowLayout, registeredClass: AnyClass!, identifier: String) -> UICollectionView {
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    layout.scrollDirection = .Horizontal
    layout.itemSize = CGSizeMake(100, 100)
    let padding: CGFloat = 10
    layout.sectionInset = UIEdgeInsetsMake(0, padding, 0, padding)
    collectionView.delegate = self as? UICollectionViewDelegate
    collectionView.dataSource = self as? UICollectionViewDataSource
    collectionView.registerClass(registeredClass, forCellWithReuseIdentifier: identifier)
    return collectionView
  }

  func backgroundColored(color: UIColor) -> UIView {
    backgroundColor = color
    return self
  }

  func blured(target: UIView, style: UIBlurEffectStyle = .Dark) -> UIView {
    let blurEffectView: UIVisualEffectView!
    let blurEffect = UIBlurEffect(style: style)
    blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = target.bounds
    blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation

    //    let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
    //    let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
    //    vibrancyEffectView.frame = view.bounds
    //    blurEffectView.contentView.addSubview(vibrancyEffectView)

    //    addSubview(blurEffectView)
    insertSubview(blurEffectView, atIndex: 0)
    return self
  }

  func removeSubviews() -> UIView {
    subviews.forEach { (v) -> () in
      v.removeFromSuperview()
    }
    return self
  }

  //  func views(var views: [UIView]) -> [UIView] {
  //    for i in 0...views.count - 1 {
  //      views[i] = view()
  //    }
  //    return views
  //  }

  func addTableView(registeredClass: AnyClass!, identifier: String) -> UITableView {
    return addView(tableView(registeredClass, identifier: identifier)) as! UITableView
  }

  func tableView(registeredClass: AnyClass!, identifier: String) -> UITableView {
    let tableView = UITableView(frame: bounds)
    tableView.delegate = (self.parentViewController() ?? self ) as? UITableViewDelegate
    tableView.dataSource = (self.parentViewController() ?? self) as? UITableViewDataSource
    tableView.estimatedRowHeight = 20.0
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.separatorStyle = .None
    tableView.registerClass(registeredClass, forCellReuseIdentifier: identifier)
    addSubview(tableView)
    return tableView
  }

  func pushViewController(vc: UIViewController) -> Void {
    parentViewController()?.pushViewController(vc)
  }

  func layout(views: [UIView]) -> UIView {
    views.forEach { (view) -> () in
      self.addSubview(view)
    }
    return self
  }

  func setFieldsGroup(fields: [UITextField]) -> Void {
    let delegate = parentViewController() as! UITextFieldDelegate
    for index in 0...fields.count - 2 {
      fields[index].delegate = delegate
      fields[index].nextField = fields[index + 1]
    }
    fields.last?.delegate = delegate
  }

  func setViewsGroup(fields: [UITextView]) -> Void {
    let delegate = parentViewController() as! UITextViewDelegate
    for index in 0...fields.count - 2 {
      fields[index].delegate = delegate
      fields[index].nextField = fields[index + 1]
    }
    fields.last?.delegate = delegate
  }

  func openPopupDialogFromView(view: UIView, completion: () -> () = {}) {
    let popupVC = PopupViewController()
    popupVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    popupVC.contentView = view
    parentViewController()!.presentViewController(popupVC, animated: true) { () -> Void in
      completion()
    }
  }

  func openPopupDialog(viewClass: NSObject.Type, completion: () -> () = {}) {
    let popupVC = PopupViewController()
    popupVC.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
    let popupView = viewClass.init()
    popupVC.contentView = popupView as! UIView
    parentViewController()!.presentViewController(popupVC, animated: true) { () -> Void in
      completion()
    }
  }

  func addTextArea(placeholder: String, options: NSDictionary = NSDictionary()) -> UITextView {
    let view: UITextView = UITextView()
    if options["bordered"] != nil {
      view.bordered(1.0, color: UIColor.lightGrayColor().lighter().CGColor)
    }
    view.editable = true
    view.layer.borderColor = UIColor.lightGrayColor().CGColor
    view.layer.borderWidth = 1.0
    view.font = UIFont.systemFontOfSize(16)
    view.textContainerInset = UIEdgeInsetsMake(5, 2, 5, 2)
    addSubview(view)
    return view
  }

  func addTextField(placeholder: String, text: String = "", options: NSDictionary = NSDictionary()) -> TextField {
    let view = TextField()
    view.placeholder = placeholder
    view.font = UIFont.systemFontOfSize(16)
    view.contentVerticalAlignment = .Center
    view.text = text
    view.textColor = K.Color.text
    addSubview(view)
    return view
  }

  func addTextFieldWithBorder(placeholder: String, text: String = "", options: NSDictionary = NSDictionary()) -> TextField {
    let view = addTextField(placeholder, options: options)
    view.layer.borderColor = UIColor.lightGrayColor().lighter().CGColor
    view.layer.borderWidth = 1.0
    view.text = text
    addSubview(view)
    return view
  }

  func addTextAreaWithBorder(placeholder: String, value: String = "", options: NSDictionary = NSDictionary()) -> UITextView {
    let view = addTextArea(placeholder, options: options)
    view.layer.borderColor = UIColor.lightGrayColor().lighter().CGColor
    view.layer.borderWidth = 1.0
    addSubview(view)
    return view
  }

  func addPassword(placeholder: String, text: String, options: NSDictionary = NSDictionary()) -> TextField {
    let password = addPassword(placeholder, options: options)
    password.text = text
    return password
  }

  func addPassword(placeholder: String, options: NSDictionary = NSDictionary()) -> TextField {
    let text = addTextField(placeholder, options: options)
    text.secureTextEntry = true
    return text
  }

  func animate(duration: Double = 0.5, onComplete: () -> ()) {
    UIView.animateWithDuration(duration) { () -> Void in
      onComplete()
    }
  }

  func asFadable() -> UIView {
    UIView.transitionWithView(self, duration: 0.5, options: .TransitionCrossDissolve, animations: nil, completion: nil)
    return self
  }

  func addMap(options: NSDictionary = NSDictionary()) -> MKMapView {
    let view: MKMapView = MKMapView()
    addSubview(view)
    return view
  }

  func addSample() -> UILabel {
    let label = self.addLabel(LoremIpsum.sentence())
    return label
  }

  func addScrollView() -> UIScrollView {
    let scrollView = UIScrollView()
    addSubview(scrollView)
    return scrollView
  }

  func topEdge() -> CGFloat {
    return y
  }

  func leftEdge() -> CGFloat {
    return x
  }

  func rightEdge() -> CGFloat {
    return x + width
  }

  func bottomEdge() -> CGFloat {
    return frame.origin.y + frame.size.height
  }

  func addLine(color: UIColor = K.Line.Color.horizontal) -> UIView {
    let line = addView()
    line.backgroundColor = color
    return line
  }

  func addView(v: UIView = UIView(), options: NSDictionary = NSDictionary()) -> UIView {
    let v = view(v, options: options)
    addSubview(v)
    return v
  }

  func view(v: UIView = UIView(), options: NSDictionary = NSDictionary()) -> UIView {
    return v
  }

  func addMarginedView(options: NSDictionary = NSDictionary()) -> UIView {
    let view = addView()
    let marginedView = view.addView()
    return marginedView
  }

  func addIconButton(text: String, icon: UIImage, target: AnyObject, action: Selector, options: NSDictionary = NSDictionary()) -> UIButton {
    let button: UIButton = addButton(text, options: options)
    button.setImage(icon, forState: .Normal)
    return button
  }


  func iconButton(icon: FontAwesome, size: CGFloat = K.BarButtonItem.size * 2, color: UIColor = K.Color.barButtonItem, options: NSDictionary = NSDictionary()) -> UIButton {
    let btn = button("", options: options)
    btn.setImage(UIImage.fontAwesomeIconWithName(icon, textColor: color, size: CGSize(width: size, height: size)), forState: .Normal)
    return btn
  }

  func addIconButton(icon: UIImage, target: AnyObject, action: Selector, options: NSDictionary = NSDictionary()) -> UIButton {
    let button = addButton("", target: target, action: action, options: options)
    button.setImage(icon, forState: .Normal)
    return button
  }

  func addButton(text: String = "", target: AnyObject, action: Selector, options: NSDictionary = NSDictionary()) -> UIButton {
    let button: UIButton = addButton(text, options: options)
    //    view.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
    button.radiused(2)
    button.whenTapped(target, action: action)
    //    button.whenTapped { () -> Void in
    //      self.performSelector(action)
    //    }
    return button
  }

  func addSubmit(text: String = "", options: NSDictionary = NSDictionary()) -> UIButton {
    let button = addButton(text, options: options)
    button.styledAsSubmit()
    return button
  }
  func addSubmit(text: String = "確定", target: AnyObject, action: Selector, options: NSDictionary = NSDictionary()) -> UIButton {
    let button = addButton(text, target: target, action: action, options: options)
    button.styledAsSubmit()
    return button
  }

  func addButton(text: String = Lorem.name(), options: NSDictionary = NSDictionary()) -> UIButton {
    let btn = button(text, options: options)
    addSubview(btn)
    return btn
  }

  func button(text: String = Lorem.name(), options: NSDictionary = NSDictionary()) -> UIButton {
    let view: UIButton = UIButton(type: .Custom)
    view.styled(text, options: options)
    return view
  }

  func addImageView(image: UIImage! = UIImage.sample()) -> UIImageView {
    let view = imageView(image)
    addSubview(view)
    return view
  }

  //  func imageViewAsFill(image: UIImage! = UIImage.sample()) -> UIImageView {
  //    let view = UIImageView()
  //    view.image = image
  //    view.contentMode = .ScaleAspectFill
  ////    view.autoresizingMask = [.FlexibleHeight]//, .FlexibleWidth]
  ////    view.layer.masksToBounds = true
  //    view.clipsToBounds = true
  //    return view
  //  }

  func imageView(image: UIImage! = UIImage.sample()) -> UIImageView {
    let imageView = UIImageView()
    imageView.styled(image)
    return imageView
  }

  func addImageViewAsFill(image: UIImage! = UIImage.sample()) -> UIImageView {
    let view = imageView(image)
    view.styledAsFill()
    addSubview(view)
    return view
  }

  func addIcon(name: FontAwesome) -> UIImageView {
    let imageView = UIImageView()
    imageView.image = UIImage.fontAwesomeIconWithName(name, textColor: UIColor.grayColor(), size: CGSize(width: 12, height: 12))
    self.addSubview(imageView)
    return imageView
  }

  func addIconLabelButton(image: UIImage!, title: String!, size: CGFloat = 14, target: AnyObject, action: Selector?) -> IconLabelButton {
    let view = IconLabelButton(image: image, text: title, size: size)
    view.whenTapped(target, action: action!)
    addSubview(view)
    return view
  }

  func iconLabel(title: String = Lorem.sentence(), icon: FontAwesome = .Gear, options: NSDictionary = NSDictionary()) -> IconLabel {
    let color = options["color"] as? UIColor ?? K.Color.text
    let size = options["fontSize"] as? CGFloat ?? K.Size.Text.small
    let cgSize = CGSize(width: size, height: size)
    let image = UIImage.fontAwesomeIconWithName(icon, textColor: color, size: cgSize)
    let iconLabel = IconLabel(iconImage: image, text: title)
    iconLabel.label.font = UIFont.systemFontOfSize(size)
    iconLabel.label.textColor = color
    return iconLabel
  }

  func addIconLabel(title: String = Lorem.sentence(), icon: FontAwesome = .Gear, options: NSDictionary = NSDictionary()) -> IconLabel {
    let color = options["color"] as? UIColor ?? K.Color.text
    let size = options["fontSize"] as? CGFloat ?? K.Size.Text.small
    let cgSize = CGSize(width: size, height: size)
    let image = UIImage.fontAwesomeIconWithName(icon, textColor: color, size: cgSize)
    return addIconLabel(title, image: image, options: options)
  }

  func addIconLabel(title: String, image: UIImage, options: NSDictionary = NSDictionary()) -> IconLabel {
    let fontSize = options["fontSize"] as? CGFloat ?? K.Size.Text.small
    let color = options["color"] as? UIColor ?? K.Color.text
    let iconLabel = IconLabel(iconImage: image, text: title)
    iconLabel.label.font = UIFont.systemFontOfSize(fontSize)
    iconLabel.label.textColor = color
    addSubview(iconLabel)
    return iconLabel
  }

  func addLabelWithIcon(title: String, icon: FontAwesome, options: NSDictionary = NSDictionary()) -> UIButton {
    let fontSize = options["fontSize"] as? CGFloat ?? K.Size.Text.normal
    let color = options["color"] as? UIColor ?? K.Color.dark
    let button = UIButton(type: .Custom)
    button.setImage(UIImage.fontAwesomeIconWithName(icon, textColor: color, size: CGSize(width: fontSize + 2, height: fontSize + 2)), forState: .Normal)
    button.setTitle(title, forState: .Normal)
    //    _logForUIMode(color)
    button.setTitleColor(color, forState: .Normal)
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
    button.contentHorizontalAlignment = .Left
    button.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
    button.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
    addSubview(button)
    return button
  }

  func groupsView(count: Int? = 2, padding: CGFloat? = 0, group: Neon.Group? = .Horizontal, margin: UIEdgeInsets? = UIEdgeInsetsZero) -> GroupsView {
    return GroupsView(count: count, padding: padding, group: group, margin: margin)
  }

  func addGroupsView(count: Int? = 2, padding: CGFloat? = 0, group: Neon.Group? = .Horizontal, margin: UIEdgeInsets? = UIEdgeInsetsZero) -> GroupsView {
    let gv = groupsView(count, padding: padding, group: group, margin: margin)
    addSubview(gv)
    return gv
  }

  func addMultilineLabel(text: String? = LoremIpsum.firstName(), options: NSDictionary = NSDictionary()) -> UILabel {
    let view = addLabel(text, options: options).multilinized()
    return view
  }

  func addLabel(text: String? = LoremIpsum.firstName(), options: NSDictionary = NSDictionary()) -> UILabel {
    let view = label(text, options: options)
    addSubview(view)
    return view
  }

  func label(text: String? = LoremIpsum.firstName(), options: NSDictionary = NSDictionary()) -> UILabel {
    let view = UILabel()
    if options["html"] != nil {
      view.attributedText = text!.toHtml()
    } else {
      view.text = text
    }
    return view.styled(options)
  }

  func addMultiLineLabelWithSize(size: CGFloat!, text: String? = Lorem.sentence(), options: NSDictionary = NSDictionary()) -> UILabel {
    let view = addLabelWithSize(size, text: text, options: options)
    return view.multilinized()
  }

  func addLabelWithSize(size: CGFloat!, text: String? = Lorem.sentence(), options: NSDictionary = NSDictionary()) -> UILabel {
    let label = addLabel(text, options: options)
    label.font = UIFont.systemFontOfSize(size)
    return label
  }

  func _coloredWithSuperviews() -> UIView {
    _coloredWithSuperviews(0)
    return self
  }

  func shadowedRadius() -> UIView {
    layer.shadowColor = superview!.backgroundColor?.darker().darker().CGColor
    layer.shadowRadius = layer.cornerRadius
    layer.shadowOffset = CGSizeMake(3, 3)
    return self
  }

  func shadowed(color: UIColor = K.Color.body.darker().darker(), offset: CGSize = CGSizeMake(0, 1)) -> UIView {
    layer.shadowColor = color.CGColor
    layer.masksToBounds = false
    layer.shadowOffset = offset
    layer.shadowRadius = 1
    layer.shadowOpacity = 0.2
    return self
  }

  func makeCircleLike() -> UIView {
    let radius = width / 2
    return radiused(radius)
  }

  func radiused(radius: CGFloat = 5) -> UIView {
    layer.cornerRadius = radius
    layer.masksToBounds = true
    return self
  }

  func _coloredWithSuperviews(index: Int) -> UIView {
    if _isSimulator() && index < K.Color.palettes.count {
      backgroundColor = K.Color.palettes[index].colorWithAlphaComponent(0.5)
      //      _guideLined()
      if let s = superview {
        s._coloredWithSuperviews(index + 1)
      }
    }
    return self
  }

  func _colored(color: UIColor) -> UIView {
    if _isSimulator() {
      backgroundColor = color
      _bordered()
    }
    return self
  }

  func _colored() -> UIView {
    _colored(K.Color.palettes.first!)
    return self
  }

  func _coloredWithIndex(index: Int) -> UIView {
    let color = K.Color.palettes[index]
    _colored(color)
    return self
  }

  func bordered(width: CGFloat = 1.0, color: CGColor = K.Color.border.CGColor) -> UIView {
    layer.borderWidth = width
    layer.borderColor = color
    return self
  }

  func _bordered(width: CGFloat = 1.0, color: CGColor = UIColor.blackColor().CGColor) -> UIView {
    if _isSimulator() {
      bordered(width, color: color)
    }
    return self
  }

  func whenTapped(target: AnyObject, action: Selector) -> UIView {
    let tap = getSingleTap(target, action: action)
    enablTapped(tap)
    //    tap.cancelsTouchesInView = true
    return self
  }

  func whenTappedWithSubviews(target: AnyObject, action: Selector) -> UIView {
    whenTapped(target, action: action)
    subviews.forEach { (view) -> () in
      view.whenTapped(target, action: action)
    }
    return self
  }

  private func getSingleTap(target: AnyObject, action: Selector) -> UIGestureRecognizer {
    return getTap(1, target: target, action: action)
  }

  private func getTap(number: Int, target: AnyObject, action: Selector) -> UIGestureRecognizer {
    let singleTap = UITapGestureRecognizer(target: target, action: action)
    singleTap.numberOfTapsRequired = 1
    singleTap.numberOfTouchesRequired = number
    return singleTap
  }

  private func enablTapped(tap: UIGestureRecognizer) -> UIView {
    userInteractionEnabled = true
    addGestureRecognizer(tap)
    return self
  }


  func opacity(value: Float = 0.75) -> UIView {
    layer.opacity = value
    return self
  }

  func basePoint() -> CGPoint {
    return self.convertPoint(bounds.origin, toView: nil)
  }

  func _guideLined() -> UIView {
    if _isSimulator() {
      if let v = superview {
        let v1 = v.addLine(K.Color.Text.important)
        let v2 = v.addLine(K.Color.Text.important)
        let v3 = v.addLine(K.Color.Text.important)
        let v4 = v.addLine(K.Color.Text.important)
        v1.anchorAndFillEdge(.Top, xPad: 0, yPad: topEdge(), otherSize: K.Line.size)
        v2.anchorAndFillEdge(.Top, xPad: 0, yPad: bottomEdge(), otherSize: K.Line.size)
        v3.anchorAndFillEdge(.Left, xPad: leftEdge(), yPad: 0, otherSize: K.Line.size)
        v4.anchorAndFillEdge(.Left, xPad: rightEdge(), yPad: 0, otherSize: K.Line.size)
        if let s = v.superview {
          s._guideLined()
        }
      }
    }
    return self
  }

  func bottomBordered() -> UIView {
    let border = CALayer()
    border.frame = CGRect(x: 0, y: height - 1, width: width, height: K.Line.size)
    border.backgroundColor = K.Line.Color.horizontal.CGColor
    self.layer.addSublayer(border)
    return self
  }

  func openImagePicker(sourceType: UIImagePickerControllerSourceType = .Camera) -> UIImagePickerController {
    var type = sourceType
    if _isSimulator() { type = .PhotoLibrary }
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = type
    parentViewController()!.presentViewController(picker, animated: true, completion: nil)
    return picker
  }
}