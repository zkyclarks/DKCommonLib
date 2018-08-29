//
//  DKSwiftProgressHUDExt.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/27.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit
import SwiftProgressHUD

extension SwiftProgressHUD {
    public class func showWait(withTip:String) {
        DispatchQueue.main.async {
            hideAllHUD()
            let window = showWait()
            let view = window!.subviews.last
            view?.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            view?.center = (window?.center)!
            let indicator = view?.subviews.last
            indicator?.center = CGPoint(x: (view?.bounds.width)! / 2, y: (view?.bounds.height)! / 2 - 20)
            let tipLbl = UILabel()
            tipLbl.text = withTip
            tipLbl.font = UIFont.systemFont(ofSize: 14)
            tipLbl.textAlignment = .center
            tipLbl.numberOfLines = 0
            tipLbl.textColor = UIColor.white
            tipLbl.frame = CGRect(x: 8, y: (view?.frame.height)! - 48, width: ((view?.frame.width)! - 16), height: 40)
            view?.addSubview(tipLbl)
        }
    }
    public class func showInfoAuto(_ text:String) {
        DispatchQueue.main.async {
            hideAllHUD()
            showInfo(text, autoClear: true, autoClearTime: 2)
        }
    }
    public class func showSuccessAuto(_ text:String) {
        DispatchQueue.main.async {
            hideAllHUD()
            showSuccess(text, autoClear: true, autoClearTime: 2)
        }
    }
    public class func showFailAuto(_ text:String) {
        DispatchQueue.main.async {
            hideAllHUD()
            showFail(text, autoClear: true, autoClearTime: 2)
        }
    }
}
