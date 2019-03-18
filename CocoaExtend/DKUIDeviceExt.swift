//
//  DKUIDeviceExt.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/25.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

extension UIDevice {
    public static func isSimulator() -> Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
    public static func isIphoneX() -> Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        
        return false
    }
    public static func statusBarHeight() -> CGFloat {
        if UIDevice.isIphoneX() {
            return 44
        } else {
            return 20
        }
    }
}
