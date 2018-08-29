//
//  ExtNSString.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/23.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

extension String {
    static func uuid() -> String {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let strUuid = CFUUIDCreateString(kCFAllocatorDefault,uuid)
        let str = String(strUuid!)
        return str
    }
    
    func getHeight(width:CGFloat) -> CGFloat {
        // 计算字符串的宽度，高度
        let font:UIFont = UIFont(name: "EuphemiaUCAS", size: 12.0)!
        let attributes = [kCTFontAttributeName:font] as [NSAttributedStringKey : Any]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = self.boundingRect(with: CGSize(width:width, height:999.9), options: option, attributes: attributes, context: nil)
        return rect.height
    }
}
