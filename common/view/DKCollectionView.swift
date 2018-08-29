//
//  DKCollectionView.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/21.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

public class DKCollectionView: UICollectionView {
    
    var dkdelegate : DKCollectionViewDelegate?
    var modelGroups : [DKCellGroupModel]? {
        didSet {
            dataSource = self
            delegate = self
            guard let vm = modelGroups else { return }
            for modelGroup in vm {
                if let headViewId = modelGroup.headViewId {
                    registerHeadView(headViewId: headViewId, headViewNibName: modelGroup.headViewNibName, headViewType: modelGroup.headViewType)
                }
                if let cellId =  modelGroup.cellId {
                    registerCell(cellId: cellId, nibName: modelGroup.cellNibName, cellType: modelGroup.cellType)
                }
            }
            reloadData()
        }
    }
}

// MARK:- 注册cell

extension DKCollectionView {
    func registerCell(cellId:String, nibName:String?, cellType:UICollectionViewCell.Type?) {
        if cellType != nil {
            register(cellType, forCellWithReuseIdentifier: cellId)
        } else if nibName != nil {
            register(UINib(nibName: nibName!, bundle: nil), forCellWithReuseIdentifier: cellId)
        }
    }
    func registerHeadView(headViewId:String, headViewNibName:String?, headViewType:UICollectionReusableView.Type?) {
        if headViewType != nil {
            register(headViewType, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headViewId)
        } else if headViewNibName != nil {
            register(UINib(nibName: headViewNibName!, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headViewId)
        }
    }
}



// MARK:- 遵守UICollectionView的数据源
extension DKCollectionView : UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let vm = modelGroups else { return 0 }
        return vm.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = modelGroups else { return 0 }
        if vm.count == 0 { return 0 }
        if vm[section].datas.count == 0 { return 1 }
        return vm[section].datas.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vm = modelGroups else { return UICollectionViewCell() }
        let group = vm[indexPath.section]
        // 1.取出Cell
        let cellid = group.cellId ?? "defaultId"
        let cell = dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath)
        if let pddcell = cell as? DKCollectionCell {
            if  group.datas.count > 0 {
                pddcell.data = group.datas[indexPath.item]
                return pddcell
            }
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let vm = modelGroups else { return UICollectionReusableView(frame: CGRect.zero) }
        let group = vm[indexPath.section]
        guard let headViewId = group.headViewId else { return UICollectionReusableView(frame: CGRect.zero) }
        // 1.取出HeaderView
        let headerView = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headViewId, for: indexPath) as! DKCollectionReusableView
        
        // 2.给HeaderView设置数据
        headerView.group = group
        return headerView
    }
}

extension DKCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let vm = modelGroups else { return CGSize.zero }
        return vm[indexPath.section].itemSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let vm = modelGroups else { return UIEdgeInsets.zero }
        return vm[section].sectionInsets
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let vm = modelGroups else { return 0 }
        return vm[section].lineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let vm = modelGroups else { return 0 }
        return vm[section].interitemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let vm = modelGroups else { return CGSize.zero }
        let group = vm[section]
        return group.headViewSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let vm = modelGroups else { return CGSize.zero }
        let group = vm[section]
        return group.footViewSize
    }
}


