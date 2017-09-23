//
//  UILabel+FontSize.Swift
//
//  Created by Nutchaphon Rewik on 7/11/15.
//  Copyright (c) 2015 Nutchaphon Rewik. All rights reserved.
//

import UIKit

extension UILabel {

  public func adjustFontSizeToFitRect(rect : CGRect){

    if text == nil{
      return
    }

    frame = rect

    let maxFontSize: CGFloat = 100.0
    let minFontSize: CGFloat = 5.0

    var q = Int(maxFontSize)
    var p = Int(minFontSize)

    let constraintSize = CGSize(width: rect.width - 5, height: CGFloat.greatestFiniteMagnitude)

    while(p <= q){
      let currentSize = (p + q) / 2
      font = font.withSize( CGFloat(currentSize) )
      let text = NSAttributedString(string: self.text!, attributes: [NSFontAttributeName:font])
      let textRect = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, context: nil)

      let labelSize = textRect.size

      if labelSize.height < frame.height &&
        labelSize.height >= frame.height - 10 &&
        labelSize.width < frame.width &&
        labelSize.width >= frame.width - 10 {
          break
      }else if labelSize.height > frame.height || labelSize.width > frame.width{
        q = currentSize - 1
      }else{
        p = currentSize + 1
      }
    }

  }
}
