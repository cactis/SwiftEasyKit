//
//  ImagesCollectionView.swift
//
//  Created by ctslin on 3/26/16.

import UIKit

public class CollectionView: DefaultView, UICollectionViewDataSource, UICollectionViewDelegate {
  public var collectionView: UICollectionView!
  public var collectionViewLayout = UICollectionViewFlowLayout()
  public let CellIdentifier = "CELL"
  public var sectionInset: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)

  public override func layoutUI() {
    super.layoutUI()
    collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
  }

  public override func styleUI() {
    super.styleUI()
    collectionView.backgroundColor = K.Color.collectionView
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    collectionView.fillSuperview()
    styleUI()
  }

  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }

  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }

  public func registerClass(registeredClass: AnyClass!,  sectionInset: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10), direction: UICollectionViewScrollDirection = .Horizontal) -> UICollectionView {
    return collectionView(collectionViewLayout, registeredClass: registeredClass, identifier: CellIdentifier, sectionInset: sectionInset, direction: direction)
  }

}

public class ImagesCollectionView: CollectionView {

  public enum Mode {
    case Show
    case Edit
  }

  public var style: ImageCell.Style! = .Default
  public var checkedIcon: UIImage! = getIcon(.Check, options: ["color": K.Color.buttonBg])

  public var mode: Mode = .Show
  public var checkable: Checkable = .None
  public var bordered: Bool = true
  public var currentBordered: Bool = false
  public var currentIndex: Int! = -1 { didSet { singleChecked(currentIndex) } }
  public var radius: CGFloat = 0
  public var didChecked = {(items: [Photo], checked: Photo) in }

  public convenience init(checkable: Checkable, checkedIcon: UIImage) {
    self.init(checkable: checkable)
    self.checkedIcon = checkedIcon
    self.style = .Custom
  }

  public init(checkable: Checkable, bordered: Bool = true, radius: CGFloat = 0, sectionInset: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)) {
    self.checkable = checkable
    self.bordered = bordered
    self.radius = radius
    super.init(frame: CGRectZero)
    self.sectionInset = sectionInset
  }

  public func singleChecked(index: Int) {
    collectionData.forEach({ $0.checked = false })
    collectionData[index].checked = true
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public var collectionData = [Photo]() { didSet {
    collectionView.reloadData()
  }}

  override public func layoutUI() {
    super.layoutUI()
    collectionView = registerClass(ImageCell.self)
    layout([collectionView])
  }

  override public func styleUI() {
    super.styleUI()
    //    collectionViewLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    let s: CGFloat = [height.int, 20].maxElement()!.cgFloat / 7 * 5
    collectionViewLayout.itemSize = CGSizeMake(s, s)
    //    collectionViewLayout.minimumInteritemSpacing = 0
    //    collectionViewLayout.minimumLineSpacing = 0
  }

  public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionData.count
  }

  public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! ImageCell
    cell.contentView.frame = cell.bounds
    cell.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    cell.loadData(collectionData[indexPath.row])
    cell.whenTapped(self, action: #selector(ImagesCollectionView.cellTapped(_:)))
    cell.radiused(radius)
    cell.style = style
    cell.tag = indexPath.row
    cell.checkedIcon = checkedIcon
    cell.layoutIfNeeded()
    if bordered {
      cell.bordered(1, color: UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor)
    }
    if currentIndex == indexPath.row && currentBordered {
      cell.bordered(5, color: UIColor.fromHex("FFCC00").colorWithAlphaComponent(0.8).CGColor)
    }
    return cell
  }

  public func cellTapped(sender: UIGestureRecognizer) {
    indexTapped((sender.view?.tag)!)
  }

  public func indexTapped(index: Int) {
    let photo = collectionData[index]
    if photo.image != nil {
      currentIndex = index
    }
    switch checkable {
    case .Single:
      singleChecked(index)
    case .Multiple:
      photo.checked = !photo.checked
    default:
      break;
    }
    collectionView.reloadData()
    didChecked(collectionData, photo)
  }

  public class ImageCell: CollectionViewCell {

    public var checked = false {
      didSet { checkedImage.hidden = !checked }
    }

    public enum Style {
      case Default
      case Custom
    }
    public var style: Style = .Default
    public var checkedIcon: UIImage!

    public var data: Photo! {
      didSet {
        if (data.url) != nil {
          photo.loadImageWithString(data.url)
        } else {
          photo.image = data.image
        }
        if (data.checked != nil) { checked = data.checked }
      }
    }

//    var checkedIcon: UIImage!
    public var checkedImage = UIImageView()
    public var photo = UIImageView()

    public func loadData(data: Photo) {
      self.data = data
    }

    override public func layoutUI() {
      super.layoutUI()
      layout([photo, checkedImage])
    }

    override public func styleUI() {
      super.styleUI()
      photo.styledAsFill()
//      checkedImage.backgroundColored(UIColor.whiteColor())
      checkedImage.hidden = true
      bringSubviewToFront(checkedImage)
    }

    override public func layoutSubviews() {
      super.layoutSubviews()
      photo.fillSuperview()
      layoutCheckedImage()
    }

    public func layoutCheckedImage() {
      switch style {
      case .Custom:
        checkedImage.image = checkedIcon
        checkedImage.backgroundColored(UIColor.clearColor())
        checkedImage.fillSuperview()
      default:
        let p = width * 0.1
        let s = width * 0.3
        checkedImage.backgroundColored(UIColor.whiteColor())
        checkedImage.image = checkedIcon
        checkedImage.anchorInCorner(.BottomRight, xPad: p, yPad: p, width: s, height: s)
        checkedImage.radiused(s / 2).bordered(1, color: K.Color.buttonBg.colorWithAlphaComponent(0.2).CGColor)

      }
    }
  }
}

public class Photo: NSObject {

  public var id: Int?
  public var image: UIImage?
  public var url: String?
  public var checked: Bool! = false

  public override init() {
    super.init()
  }

  public init(id: Int, url: String) {
    self.id = id
    self.url = url
    super.init()
  }

  public init(image: UIImage!) {
    self.image = image
    super.init()
  }

  public init(url: String!) {
    self.url = url
    super.init()
  }

  public class func seeds(onComplete: (items: [Photo]) -> ()) {
    var items = [Photo]()
    (0...2).forEach { (i) in
      items.append(Photo(url: randomImageName()))
    }
    onComplete(items: items)
  }
}


public enum Checkable {
  case Single
  case Multiple
  case None
}
