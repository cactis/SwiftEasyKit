//
//  CollectionView.swift
//
//  Created by ctslin on 2016/11/5.

import UIKit

open class CollectionView: DefaultView, UICollectionViewDataSource, UICollectionViewDelegate {
  public var collectionView: UICollectionView!
  public var collectionViewLayout = UICollectionViewFlowLayout()
  public let CellIdentifier = "CELL"
  public var sectionInset: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)



  override open func layoutUI() {
    super.layoutUI()
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
  }

  override open func styleUI() {
    super.styleUI()
    collectionView.backgroundColor = K.Color.collectionView
  }

  override open func layoutSubviews() {
    super.layoutSubviews()
    collectionView.fillSuperview()
    styleUI()
  }

  open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return UICollectionViewCell()
  }
//
  open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 0
  }

  open func registerClass(_ registeredClass: AnyClass!,  sectionInset: UIEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10), direction: UICollectionViewScrollDirection = .horizontal) -> UICollectionView {
    return collectionView(collectionViewLayout, registeredClass: registeredClass, identifier: CellIdentifier, sectionInset: sectionInset, direction: direction)
  }

}
