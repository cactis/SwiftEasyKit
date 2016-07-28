//
//  ImagesCollectionView.swift
//
//  Created by ctslin on 3/26/16.

import UIKit

public class ImagesCollectionView: DefaultView, UICollectionViewDataSource, UICollectionViewDelegate {

  public var collectionView: UICollectionView!
  public var collectionViewLayout = UICollectionViewFlowLayout()
  public let CellIdentifier = "CELL"
  public var checkable: Checkable = .None {
    didSet {
    }
  }

  public var didChecked = {(items: [ImageCellViewModel]) in }

  public init(checkable: Checkable) {
    self.checkable = checkable
    super.init(frame: CGRectZero)
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public var collectionData = [ImageCellViewModel]() {
    didSet {
      collectionView.reloadData()
    }
  }

  override public func layoutUI() {
    super.layoutUI()
    collectionView = collectionView(collectionViewLayout, registeredClass: ImageCell.self, identifier: CellIdentifier)
    layout([collectionView])
  }

  override public func styleUI() {
    super.styleUI()
    collectionView.backgroundColor = UIColor.clearColor()
  }
  override public func bindUI() {
    super.bindUI()
  }

  override public func layoutSubviews() {
    super.layoutSubviews()
    collectionView.fillSuperview()
    let s: CGFloat = height / 7 * 5
    collectionViewLayout.itemSize = CGSizeMake(s, s)
  }

  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionData.count
  }

  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! ImageCell
    cell.contentView.frame = cell.bounds
    cell.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    cell.loadData(collectionData[indexPath.row])
    cell.whenTapped(self, action: #selector(ImagesCollectionView.cellTapped(_:)))
    cell.tag = indexPath.row
    cell.layoutIfNeeded()
    return cell
  }

  public func cellTapped(sender: UIGestureRecognizer) {
    collectionData.forEach({ $0.checked = false })
    collectionData[(sender.view?.tag)!].checked = true
    collectionView.reloadData()
    didChecked(collectionData)
  }

  public class ImageCell: CollectionViewCell {

    public var checked = false {
      didSet { checkedImage.hidden = !checked }
    }

    public var data = ImageCellViewModel() {
      didSet {
        if (data.url) != nil {
          photo.loadImageWithString(data.url)
        } else {
          photo.image = data.image
        }
        if (data.checked != nil) { checked = data.checked }
      }
    }

    public var checkedImage = UIImageView()
    public var photo = UIImageView()

    public func loadData(data: ImageCellViewModel) {
      self.data = data
    }

    override public func layoutUI() {
      super.layoutUI()
      layout([photo, checkedImage])
    }

    override public func styleUI() {
      super.styleUI()
      photo.styledAsFill()
      bordered(1, color: UIColor.lightGrayColor().CGColor)
      checkedImage.backgroundColored(UIColor.whiteColor())
      checkedImage.image = getIcon(.Check, options: ["color": K.Color.buttonBg])
      checkedImage.hidden = true
    }

    override public func layoutSubviews() {
      super.layoutSubviews()
      photo.fillSuperview()
      let p = width * 0.1
      let s = width * 0.3
      checkedImage.anchorInCorner(.BottomRight, xPad: p, yPad: p, width: s, height: s)
      checkedImage.radiused(s / 2).bordered(1, color: K.Color.buttonBg.CGColor)
    }

  }
}

public class ImageCellViewModel: NSObject {
  public var image: UIImage!
  public var url: String!
  public var checked: Bool!

  public class func seeds(onComplete: (items: [ImageCellViewModel]) -> ()) {
    var items = [ImageCellViewModel]()
    (0...2).forEach { (i) in
      let item = ImageCellViewModel()
      item.url = randomImageName()
      items.append(item)
    }
    onComplete(items: items)
  }
}


public enum Checkable {
  case Single
  case Multiple
  case None
}
