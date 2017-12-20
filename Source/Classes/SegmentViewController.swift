
//  SegmentViewController.swift//
//  Created by ctslin on 3/15/16.

import UIKit

open class SegmentViewController: DefaultViewController, UITableViewDelegate, UITableViewDataSource {

  // segment, tableViews, collectionDatas
  // * create segment object before layoutUI()
  //  var collectionDatas = [[NSDictionary]]()
  //  var collectionDatas = [[AnyObject]]()

  public var segment: TextSegment!
  public var scrollView = UIScrollView()
  public var tableViews = [UITableView]()

  public let CellIdentifier = "CELL"
  public var cell: TableViewCell!
  public var segmentHeight: CGFloat = 60

  override open func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.isTranslucent = false
  }

  override open func layoutUI() {
    super.layoutUI()
    view.layout([
      segment,
      scrollView.layout(
        tableViews)])
  }

  override open func styleUI() {
    super.styleUI()
    scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(tableViews.count), height: scrollView.frame.height)
  }

  override open func bindUI() {
    super.bindUI()
    scrollView.delegate = self
    scrollView.isPagingEnabled = true
    segment.changed = changed
  }

  public func extraCellBottomPadding() -> CGFloat { return 10 }
  public func headerHeight() -> CGFloat { return K.Size.Header.height }

  override open func updateViewConstraints() {
    super.updateViewConstraints()
    segment.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: segmentHeight)
    scrollView.alignAndFillHeight(align: .underMatchingLeft, relativeTo: segment, padding: 0, width: segment.width)
    scrollView.groupHorizontally(tableViews.map({$0 as UIView}), fillingHeightWithLeftPadding: 0, spacing: 0, topAndBottomPadding: 0, width: segment.width)
    styleUI()
  }

  open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }

  open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier)! as UITableViewCell
    return cell
  }

  open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if cell != nil {
      cell.layoutIfNeeded()
      cell.updateConstraintsIfNeeded()
      cell.layoutSubviews()
      return cell.bottomView.bottomEdge() + extraCellBottomPadding()
    } else {
      return 0
    }
  }

  public enum ScrollDirection {
    case vertical
    case horizontal
  }
  public var lastContentOffset: CGPoint! = .zero
  public var direction: ScrollDirection!
  public func scrollViewDidScroll(_ scrollView: UIScrollView) {
    direction = lastContentOffset.x == scrollView.contentOffset.x ? .vertical : .horizontal
    lastContentOffset = scrollView.contentOffset
  }

  public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if direction == .horizontal {
      let index = Int(scrollView.contentOffset.x / segment.width)
      segment.index = index
    }
  }

  public func indexTapped(_ index: Int) {
    segment.index = index
    changed()
  }

  public func changed() {
    scrollView.setContentOffset(CGPoint(x: CGFloat(segment.index) * segment.width, y: 0), animated: true)
  }

  public func removeCell(tableView: UITableView, indexPath: IndexPath, onComplete: @escaping () -> ()) {
    tableView.beginUpdates()
    removeDataFromCollectionData(tableView: tableView, indexPath: indexPath)
    tableView.asFadable()
    tableView.deleteRows(at: [indexPath], with: .fade)
    tableView.endUpdates()
    tableView.reloadData()
    onComplete()
  }

  open func removeDataFromCollectionData(tableView: UITableView, indexPath: IndexPath) { }
  open func insertDataToCollectionData(currentIndex: Int, targetIndex: Int, indexPath: IndexPath) { }

  public func moveCellTo(currentIndex: Int, targetIndex: Int, indexPath: IndexPath) {
    let tableView = self.tableViews[targetIndex]
//    tableView.reloadData()
//    tableView.beginUpdates()
//    tableView.updateConstraintsIfNeeded()
    self.insertDataToCollectionData(currentIndex: currentIndex, targetIndex: targetIndex, indexPath: indexPath)
    delayedJob(1) {
      self.segment.tappedAtIndex(targetIndex)
      delayedJob(1) {
        tableView.insertRows(at: [IndexPath(item: 0, section: 0)], with: .top)
//        tableView.endUpdates()
        delayedJob(1) {
          self.segment.labels[targetIndex].badge.plus()
//          delayedJob {
//            tableView.reloadData()
//          }
        }
      }
    }
    removeCell(tableView: self.tableViews[currentIndex], indexPath: indexPath, onComplete: {})
    segment.labels[currentIndex].badge.minus()
  }
}
