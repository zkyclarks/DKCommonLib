//
//  ExtUILabel.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/9.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

enum VerticalAlignment
{
    case VerticalAlignmentTop
    case VerticalAlignmentMiddle
    case VerticalAlignmentBottom
}
class ExtUILabel: UILabel {
    var verticalAlignment: VerticalAlignment = .VerticalAlignmentTop {
        didSet {
            setNeedsDisplay()
        }
    }
  
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        var textRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        switch verticalAlignment {
        case .VerticalAlignmentTop:
            textRect.origin.y = bounds.origin.y
        case .VerticalAlignmentBottom:
            textRect.origin.y = bounds.origin.y + bounds.size.height - textRect.size.height
        default:
            textRect.origin.y = bounds.origin.y + (bounds.size.height - textRect.size.height) / 2.0
        }
        return textRect
    }
 
    override func drawText(in rect: CGRect) {
        let actualRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: actualRect)
    }
}
