//
//  PopupView.swift

import UIKit

public class PopupViewController: UIViewController {
  
  public var autoDismiss: Bool = false
  public var maskView: UIView!
  public var contentView: UIView!
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    maskView = view.addView()    
    view.addSubview(contentView)
    maskView.blured(view)
    
    if autoDismiss {
      maskView.whenTapped(self, action: #selector(closeTapped))
    }
  }
  
  func closeTapped() {
    self.dismissViewControllerAnimated(true) { () -> Void in
    }
  }
  
  override public func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    maskView.fillSuperview()
  }
  
}
