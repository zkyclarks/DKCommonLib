//
//  DKJSONTool.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/28.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

extension Dictionary {
    /**
     字典转换为Data
     - parameter dictionary: 字典参数
     - returns: Data
     */
    func toData() -> Data? {
       if (!JSONSerialization.isValidJSONObject(self)) {
            print("is not a valid json object")
            return nil
        }
       //利用自带的json库转换成Data
       //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
       let data = try? JSONSerialization.data(withJSONObject: self, options: [])
       return data
    }
    /**
     字典转换为JSONString
     - parameter dictionary: 字典参数
     - returns: JSONString
     */
    func toJSONString() -> String? {
        if (!JSONSerialization.isValidJSONObject(self)) {
            print("is not a valid json object")
            return nil
        }
        //利用自带的json库转换成Data
        //如果设置options为JSONSerialization.WritingOptions.prettyPrinted，则打印格式更好阅读
        let data = try? JSONSerialization.data(withJSONObject: self, options: [])
        //Data转换成String打印输出
        let str = String(data:data!, encoding: String.Encoding.utf8)
        //输出json字符串
        return str
    }
}



