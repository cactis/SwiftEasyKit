//
//  ImagesCollectionView.swift
//
//  Created by ctslin on 3/26/16.

import UIKit
import ObjectMapper

public class ImagesCollectionView: CollectionView {
  
  public enum Mode {
    case Show
    case Edit
  }
  
  //  public var maximum: Int = 0
  
  public var didTappedOnCell: (index: Int) -> () = { _ in }
  
  public var style: ImageCell.Style! = .Default
  public var checkedIcon: UIImage! = getIcon(.Check, options: ["color": K.Color.buttonBg])
  
  public var mode: Mode = .Show
  public var checkable: Checkable = .None
  public var bordered: Bool = true
  public var currentBordered: Bool = false
  public var currentIndex: Int! = -1 //{ didSet { singleChecked(currentIndex) } }
  public var radius: CGFloat = 0
  public var didChecked = {(items: [Photo], checked: Photo) in }
  
  public var placeHolder: UIImage?
  
  var photosCount: Int { get {return collectionData.filter({$0.image != nil || $0.url != nil}).count } }
  
  public var collectionData = [Photo]() { didSet {
    collectionView.reloadData()
    }}
  
  public convenience init(checkable: Checkable, checkedIcon: UIImage, placeHolder: UIImage?) {//, maximum: Int = 0) {
    self.init(checkable: checkable)
    self.checkedIcon = checkedIcon
    self.style = .Custom
    self.placeHolder = placeHolder
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
    currentIndex = index
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    if indexPath.row == photosCount { cell.placeHolder.image = placeHolder } else { cell.placeHolder.image = UIImage()}
    cell.layoutIfNeeded()
    if bordered { cell.bordered(1, color: UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor) }
    if currentIndex == indexPath.row && currentBordered {
      cell.bordered(5, color: UIColor.fromHex("FFCC00").colorWithAlphaComponent(0.8).CGColor)
    }
    return cell
  }
  
  public func cellTapped(sender: UIGestureRecognizer) {
    _logForUIMode()
    indexTapped((sender.view?.tag)!)
  }
  
  public func indexTapped(index: Int) {
    _logForUIMode(index, title: "index")
    let photo = collectionData[index]
    if photo.image != nil || photo.url != nil {
      currentIndex = index
      switch checkable {
      case .Single:
        singleChecked(index)
      case .Multiple:
        photo.checked = !photo.checked
      default:
        break;
      }
    }
    collectionView.reloadData()
    didChecked(collectionData, photo)
    
    didTappedOnCell(index: index)
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
    public var placeHolder = UIImageView()
    
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
      layout([placeHolder, photo, checkedImage])
    }
    
    override public func styleUI() {
      super.styleUI()
      let w = width * 0.2
      placeHolder.fillSuperview(left: w, right: w, top: w, bottom: w)
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

public class Photo: Mappable {
  
  public var id: Int?
  public var image: UIImage?
  public var url: String?
  public var checked: Bool! = false
  
  public func mapping(map: Map) {
    id <- map["id"]
    url <- map["file_url"]
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
  
  public class func seeds(onComplete: (items: [Photo]) -> ()) {
    var items = [Photo]()
    (0...2).forEach { (i) in
      items.append(Photo(url: randomImageName()))
    }
    onComplete(items: items)
  }
  required public init?(_ map: Map) { }
}

extension SequenceType where Generator.Element == Photo {

  public func clone() -> [Photo] {
    var copiedArray = NSArray(array: self as! [Photo], copyItems: true)
    return copiedArray as! [Photo]
  }

  public func expendTo(num: Int) -> [Photo] {
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
  case Single
  case Multiple
  case None
}
