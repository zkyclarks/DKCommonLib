//
//  DKImageBrowserController.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/29.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

class DKImageBrowserController: DKBaseViewController {
    var zoomable = false
    var images:[UIImage]?
    func show(withImages:[UIImage]? = nil) {
        if let imgs = images {
            images = imgs
        }
        showImages()
    }
    private func showImages() {
        guard let imgs = images else {return}
        let cycleView = DKCycleView.cycleView()
//        cycleView.
        view.addSubview(cycleView)
    }
}
