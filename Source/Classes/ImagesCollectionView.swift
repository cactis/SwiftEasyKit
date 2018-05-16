//
//  ImagesCollectionView.swift
//
//  Created by ctslin on 3/26/16.

import UIKit
import ObjectMapper

open class ImagesCollectionView: CollectionView {

  public enum Mode {
    case show
    case edit
  }

  public var didTappedOnCell: (_ index: Int) -> () = { _ in }
  public var didSwippedUpCell: (_ index: Int) -> () = { _ in }

  public var style: ImageCell.Style! = .normal
  public var checkedIcon: UIImage! = getIcon(.check, options: ["color": K.Color.buttonBg])

  public var mode: Mode = .show
  public var checkable: Checkable = .none
  public var bordered: Bool = true
  public var currentBordered: Bool = false
  public var currentIndex: Int! = -1 //{ didSet { singleChecked(currentIndex) } }
  public var radius: CGFloat = 0
  public var didChecked = {(items: [Photo], checked: Photo) in }

  public var placeHolder: UIImage?

  var photosCount: Int { get { return collectionData.filter({$0.image != nil || $0.url != nil}).count } }

  public var collectionData = [Photo]() { didSet { collectionView.reloadData() }}

  public convenience init(checkable: Checkable, checkedIcon: UIImage, placeHolder: UIImage?) {//, maximum: Int = 0) {
    self.init(checkable: checkable)
    self.checkedIcon = checkedIcon
    self.style = .custom
    self.placeHolder = placeHolder
  }

  public init(checkable: Checkable, bordered: Bool = true, radius: CGFloat = 0, sectionInset: UIEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20)) {
    self.checkable = checkable
    self.bordered = bordered
    self.radius = radius
    super.init(frame: .zero)
    self.sectionInset = sectionInset
  }

  public func singleChecked(_ index: Int) {
    collectionData.forEach({ $0.checked = false })
    collectionData[index].checked = true
    currentIndex = index
  }

  @objc public func indexTapped(_ index: Int) {
    let photo = collectionData[index]
    if photo.image != nil || photo.url != nil {
      currentIndex = index
      switch checkable {
      case .single:
        singleChecked(index)
      case .multiple:
        photo.checked = !photo.checked
      default:
        break;
      }
    }
    collectionView.reloadData()
    didChecked(collectionData, photo)
    didTappedOnCell(index)
  }

  override open func layoutUI() {
    super.layoutUI()
    collectionView = registerClass(ImageCell.self)
    layout([collectionView])
  }

  override open func styleUI() {
    super.styleUI()
    let s: CGFloat = [height.int, 20].max()!.cgFloat / 7 * 5
    collectionViewLayout.itemSize = CGSize(width: s, height:  s)
  }

  override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionData.count
  }

  override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath as IndexPath) as! ImageCell
    cell.contentView.frame = cell.bounds
    cell.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    cell.loadData(data: collectionData[indexPath.row])
    cell.whenTapped(self, action: #selector(ImagesCollectionView.cellTapped(_:)))
    let swipe = UISwipeGestureRecognizer(target: self, action: #selector(cellSwippedUp(_:)))
    swipe.direction = .up
    cell.addGestureRecognizer(swipe)
    cell.radiused(radius)
    cell.style = style
    cell.tag = indexPath.row
    cell.checkedIcon = checkedIcon
    if indexPath.row == photosCount {
      cell.placeHolder.image = placeHolder
    } else {
      cell.placeHolder.image = UIImage()
    }
    cell.layoutIfNeeded()
    if bordered { cell.bordered(1, color: UIColor.lightGray.withAlphaComponent(0.5).cgColor) }
    if currentIndex == indexPath.row && currentBordered {
      cell.bordered(5, color: UIColor.fromHex("FFCC00").withAlphaComponent(0.8).cgColor)
    }
    return cell
  }

  @objc public func cellTapped(_ sender: UIGestureRecognizer) { indexTapped((sender.view?.tag)!) }

  @objc public func cellSwippedUp(_ sender: UISwipeGestureRecognizer) {
    let index = sender.view?.tag
    didSwippedUpCell(index!)
  }

  open class ImageCell: CollectionViewCell {

    public var checked = false {
      didSet { checkedImage.isHidden = !checked }
    }

    public enum Style {
      case normal
      case custom
    }
    public var style: Style = .normal
    public var checkedIcon: UIImage!
    public var placeHolder = UIImageView()

    public var data: Photo! {
      didSet {
        if (data.url) != nil {
          photo.imaged(data.url)
        } else {
          photo.image = data.image
        }
        if (data.checked != nil) { checked = data.checked }
      }
    }

    public var checkedImage = UIImageView()
    public var photo = UIImageView()
    public func loadData(data: Photo) { self.data = data }

    override open func layoutUI() {
      super.layoutUI()
      layout([placeHolder, photo, checkedImage])
    }

    override open func styleUI() {
      super.styleUI()
//      let w = width * 0.2
//      placeHolder.fillSuperview(left: w, right: w, top: w, bottom: w)
      photo.styledAsFill()
//      //      checkedImage.backgroundColored(UIColor.white)
//      checkedImage.isHidden = true
//      bringSubviewToFront(checkedImage)
    }

    override open func layoutSubviews() {
      super.layoutSubviews()
      photo.fillSuperview()
      layoutCheckedImage()
    }

    public func layoutCheckedImage() {
      switch style {
      case .custom:
        checkedImage.image = checkedIcon
        checkedImage.backgroundColored(UIColor.clear)
        checkedImage.fillSuperview()
      case .normal:
        let p = width * 0.1
        let s = width * 0.3
        checkedImage.backgroundColored(UIColor.white)
        checkedImage.image = checkedIcon
        checkedImage.anchorInCorner(.bottomRight, xPad: p, yPad: p, width: s, height: s)
//        checkedImage.radiused(K.Color.buttonBg.withAlphaComponent(0.2).cgColor as! CGFloat)
      }
    }
  }

  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

open class Photo: Mappable {

  public var id: Int?
  public var url: String?
  public var thumbUrl: String?
  public var smallUrl: String?

  public var image: UIImage?
  public var checked: Bool! = false

  public func mapping(map: Map) {
    id <- map["id"]
    url <- map["file_url"]
    thumbUrl <- map["thumb_file_url"]
    smallUrl <- map["small_file_url"]
  }

  public init(id: Int?, url: String?) {
    self.id = id
    self.url = url
  }

  public init(image: UIImage!) {
    self.image = image
  }

  public init(url: String!) {
    self.url = url
  }

  open class func seeds(onComplete: (_ items: [Photo]) -> ()) {
    var items = [Photo]()
    (0...2).forEach { (i) in
      items.append(Photo(url: randomImageUrl()))
    }
    onComplete(items)
  }
  required public init?(map: Map) { }
}

extension Sequence where Iterator.Element == Photo {

//  public func clone() -> [Photo] {
//    var copiedArray = NSArray(array: self as! [Photo], copyItems: true)
//    return copiedArray as! [Photo]
//  }

  public func expendTo(_ num: Int) -> [Photo] {
    let photos = (self as? [Photo])
    let diff = num - photos!.count
    if diff >= 1 {
      return photos! + (1...diff).map({_ in Photo(id: nil, url: nil)})
    } else {
      return photos!
    }
  }
}

public enum Checkable {
  case single
  case multiple
  case none
}

