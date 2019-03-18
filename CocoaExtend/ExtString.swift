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
    
    func substring (start:Int, lenth:Int) -> String {
        guard start < count && lenth < count else { return "" }
        guard lenth > 0 && count - start - lenth >= 0 else { return "" }
        let startIndex = self.index(self.startIndex, offsetBy: start)
        let endIndex = self.index(startIndex, offsetBy: lenth)
        let substr = self[startIndex..<endIndex]
        return String(substr)
    }
}
