//
//  DKDateExt.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/24.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

extension Date {
    func dateString(formatString:String) -> String {
        let dformatter = DateFormatter()
        dformatter.dateFormat = formatString
        let datestr = dformatter.string(from: self)
        return datestr
    }
    
}
