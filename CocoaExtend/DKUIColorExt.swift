//
//  DKUIColorExt.swift
//  PDDMall
//
//  Created by keyu zhang on 2019/1/21.
//  Copyright © 2019 pdd. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
    
    class func randomColor() -> UIColor {
        return UIColor(r: CGFloat(arc4random_uniform(256)), g: CGFloat(arc4random_uniform(256)), b: CGFloat(arc4random_uniform(256)))
    }
    /**
     传入RGBA的16进制字符串，顺序必须是R,G,B,A，得到UIColor
     */
    convenience init(_ rgba:String) {
        var r:CGFloat = 0.0, g:CGFloat = 0.0, b:CGFloat = 0.0, a:CGFloat = 1.0
        if rgba.count >= 6 {
            if let rr = Int(rgba.substring(start: 0, lenth: 2), radix: 16) { r = CGFloat(rr) }
            if let gg = Int(rgba.substring(start: 2, lenth: 2), radix: 16) { g = CGFloat(gg) }
            if let bb = Int(rgba.substring(start: 4, lenth: 2), radix: 16) { b = CGFloat(bb) }
        } else if rgba.count >= 8 {
            if let aa = Int(rgba.prefix(2), radix: 16) { a = CGFloat(aa) }
        }
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
