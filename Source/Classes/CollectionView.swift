//
//  CollectionView.swift
//
//  Created by ctslin on 2016/11/5.

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
