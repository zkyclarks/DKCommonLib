//
//  DKCycleCell.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/21.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit
import Kingfisher

class DKImageCycleView: UIView {
    
    // MARK: 控件属性
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleBgView: UIView!
    // MARK: 定义模型属性
    var cycleModel : DKImageViewModel? {
        didSet {
            titleBgView.isHidden = (cycleModel?.isHideTitle ?? false)!
            titleLabel.text = cycleModel?.title
            let iconURL = URL(string: cycleModel?.picUrl ?? "")!
            iconImageView.kf.setImage(with: iconURL, placeholder: UIImage(named: "ImgDefault"))
        }
    }
}
class DKImageViewModel: DKBaseModel {
    var title : String = ""
    var picUrl : String = ""
    var isHideTitle: Bool = false
}
