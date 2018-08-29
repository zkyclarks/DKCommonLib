//
//  DKCellModel.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/21.
//  Copyright © 2018年 pdd. All rights reserved.
//


public class DKBaseModel: NSObject {

}

public class DKCellGroupModel: DKBaseModel {
    var cellId:String? = nil
    var cellType:UICollectionViewCell.Type? = nil
    var cellNibName:String? = nil
    var headViewId:String? = nil
    var headViewType:UICollectionReusableView.Type? = nil
    var headViewNibName:String? = nil
    var headViewData:[String:Any]? = nil
    var itemSize:CGSize = CGSize.zero
    var sectionInsets:UIEdgeInsets = UIEdgeInsets.zero
    var lineSpacing:CGFloat = 0
    var interitemSpacing:CGFloat = 0
    var headViewSize:CGSize = CGSize.zero
    var footViewSize:CGSize = CGSize.zero
    lazy var datas : [DKCellItemModel] = [DKCellItemModel]()
}

public class DKCellItemModel: DKBaseModel {
    
}

