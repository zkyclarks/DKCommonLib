//
//  DKImageBrowserCell.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/29.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

class DKImageBrowserCell: DKCollectionCell {
    lazy var imageView:UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        addSubview(view)
        return view
    }()
    override var data: DKCellItemModel? {
        didSet {
            guard let model = data as? DKImageBrowserCellModel else {return}
            imageView.image = model.image
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}

class DKImageBrowserCellModel: DKCellItemModel {
    var image:UIImage?
}
