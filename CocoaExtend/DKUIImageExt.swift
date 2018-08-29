//
//  DKUIImageExt.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/28.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

extension UIImage {
    func zoomImage(_ toSize:CGSize, force:Bool = false) -> UIImage {
        var destSize = CGSize.zero
        if force {
            destSize = toSize
        } else {
            if toSize.width < size.width {
                destSize.width = toSize.width
            } else {
                destSize.width = size.width
            }
            if toSize.height < size.height {
                destSize.height = toSize.height
            } else {
                destSize.height = size.height
            }
        }
        let whRatio = size.width / size.height
        if whRatio > 1 {
            destSize.height = destSize.width / whRatio
        } else if whRatio < 1 {
            destSize.width = destSize.height * whRatio
        }
        UIGraphicsBeginImageContext(destSize)
        var rect = CGRect.zero
        rect.size = destSize
        self.draw(in: rect)
        let destImg = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return destImg
    }
}
