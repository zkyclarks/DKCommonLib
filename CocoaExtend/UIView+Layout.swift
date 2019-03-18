//
//  UIView+Layout.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/23.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

extension UIView {
    func assign(size: CGSize) {
        var rect = frame
        rect.size = size
        frame = rect
    }
    func assign(width: CGFloat) {
        var rect = frame
        rect.size.width = width
        frame = rect
    }
    func assign(height: CGFloat) {
        var rect = frame
        rect.size.height = height
        frame = rect
    }
    func assign(origin: CGPoint) {
        var rect = frame
        rect.origin = origin
        frame = rect
    }
    func assign(x: CGFloat) {
        var rect = frame
        rect.origin.x = x
        frame = rect
    }
    func assign(y: CGFloat) {
        var rect = frame
        rect.origin.y = y
        frame = rect
    }
    func x() -> CGFloat {
        return frame.origin.x
    }
    func y() -> CGFloat {
        return frame.origin.y
    }
    func origin() -> CGPoint {
        return frame.origin
    }
    func width() -> CGFloat {
        return frame.size.width
    }
    func height() -> CGFloat {
        return frame.size.height
    }
    func size() -> CGSize {
        return frame.size
    }
    func setCorner(color:UIColor, radius:CGFloat) {
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
}
