//
//  ImagesCollectionView.swift
//
//  Created by ctslin on 3/26/16.

import UIKit

class ImagesCollectionView: DefaultView, UICollectionViewDataSource, UICollectionViewDelegate {

  var collectionView: UICollectionView!
  var collectionViewLayout = UICollectionViewFlowLayout()
  let CellIdentifier = "CELL"
  var checkable: Checkable = .None {
    didSet {
    }
  }

  var didChecked = {(items: [ImageCellViewModel]) in }

  init(checkable: Checkable) {
    self.checkable = checkable
    super.init(frame: CGRectZero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  var collectionData = [ImageCellViewModel]() {
    didSet {
      collectionView.reloadData()
    }
  }

  override func layoutUI() {
    super.layoutUI()
    collectionView = collectionView(collectionViewLayout, registeredClass: ImageCell.self, identifier: CellIdentifier)
    layout([collectionView])
  }

  override func styleUI() {
    super.styleUI()
    collectionView.backgroundColor = UIColor.clearColor()
  }
  override func bindUI() {
    super.bindUI()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    collectionView.fillSuperview()
    let s: CGFloat = height / 7 * 5
    collectionViewLayout.itemSize = CGSizeMake(s, s)
  }

  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionData.count
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CellIdentifier, forIndexPath: indexPath) as! ImageCell
    cell.contentView.frame = cell.bounds
    cell.contentView.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    cell.loadData(collectionData[indexPath.row])
    cell.whenTapped(self, action: #selector(ImagesCollectionView.cellTapped(_:)))
    cell.tag = indexPath.row
    cell.layoutIfNeeded()
    return cell
  }

  func cellTapped(sender: UIGestureRecognizer) {
    collectionData.forEach({ $0.checked = false })
    collectionData[(sender.view?.tag)!].checked = true
    collectionView.reloadData()
    didChecked(collectionData)
  }

  class ImageCell: CollectionViewCell {

    var checked = false {
      didSet { checkedImage.hidden = !checked }
    }

    var data = ImageCellViewModel() {
      didSet {
        if (data.url) != nil {
          photo.loadImageWithString(data.url)
        } else {
          photo.image = data.image
        }
        if (data.checked != nil) { checked = data.checked }
      }
    }

    var checkedImage = UIImageView()
    var photo = UIImageView()

    func loadData(data: ImageCellViewModel) {
      self.data = data
    }

    override func layoutUI() {
      super.layoutUI()
      layout([photo, checkedImage])
    }

    override func styleUI() {
      super.styleUI()
      photo.styledAsFill()
      bordered(1, color: UIColor.lightGrayColor().CGColor)
      checkedImage.backgroundColored(UIColor.whiteColor())
      checkedImage.image = getIcon(.Check, options: ["color": K.Color.buttonBg])
      checkedImage.hidden = true
    }

    override func layoutSubviews() {
      super.layoutSubviews()
      photo.fillSuperview()
      let p = width * 0.1
      let s = width * 0.3
      checkedImage.anchorInCorner(.BottomRight, xPad: p, yPad: p, width: s, height: s)
      checkedImage.radiused(s / 2).bordered(1, color: K.Color.buttonBg.CGColor)
    }

  }
}

class ImageCellViewModel: NSObject {
  var image: UIImage!
  var url: String!
  var checked: Bool!

  class func seeds(onComplete: (items: [ImageCellViewModel]) -> ()) {
    var items = [ImageCellViewModel]()
    (0...2).forEach { (i) in
      let item = ImageCellViewModel()
      item.url = randomImageName()
      items.append(item)
    }
    onComplete(items: items)
  }
}


enum Checkable {
  case Single
  case Multiple
  case None
}
