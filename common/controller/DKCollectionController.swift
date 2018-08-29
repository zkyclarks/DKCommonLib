//
//  DKCollectionController.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/29.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit
import LCRefresh

class DKCollectionController: DKBaseViewController {
    
    var isRefreshing = false
    // MARK: 定义属性
    var viewModel : PDDViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            for modelGroup in vm.groups {
                if let headViewId = modelGroup.headViewId {
                    registerHeadView(headViewId: headViewId, headViewNibName: modelGroup.headViewNibName, headViewType: modelGroup.headViewType)
                }
                if let cellId =  modelGroup.cellId {
                    registerCell(cellId: cellId, nibName: modelGroup.cellNibName, cellType: modelGroup.cellType)
                }
            }
        }
    }
    
    lazy var collectionView : DKCollectionView = {
        // 1.创建布局
        let layout = UICollectionViewFlowLayout()
        // 2.创建UICollectionView
        let collectionView = DKCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    var footerRefreshBlock:(()->())? = nil
    var headerRefreshBlock:(()->())? = nil
    // MARK: 系统回调
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
    }
}

// MARK:- 注册cell

extension DKCollectionController {
    func registerCell(cellId:String, nibName:String?, cellType:UICollectionViewCell.Type?) {
        if cellType != nil {
            collectionView.register(cellType, forCellWithReuseIdentifier: cellId)
        } else if nibName != nil {
            collectionView.register(UINib(nibName: nibName!, bundle: nil), forCellWithReuseIdentifier: cellId)
        }
    }
    func registerHeadView(headViewId:String, headViewNibName:String?, headViewType:UICollectionReusableView.Type?) {
        if headViewType != nil {
            collectionView.register(headViewType, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headViewId)
        } else if headViewNibName != nil {
            collectionView.register(UINib(nibName: headViewNibName!, bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headViewId)
        }
    }
}



// MARK:- 遵守UICollectionView的数据源
extension DKCollectionController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let vm = viewModel else { return 0 }
        return vm.groups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let vm = viewModel else { return 0 }
        if vm.groups.count == 0 { return 0 }
        if vm.groups[section].datas.count == 0 { return 1 }
        return vm.groups[section].datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let vm = viewModel else { return UICollectionViewCell() }
        let group = vm.groups[indexPath.section]
        // 1.取出Cell
        let cellid = group.cellId ?? "defaultId"
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath)
        if let pddcell = cell as? PDDCollectionCell {
            if  group.datas.count > 0 {
                pddcell.data = group.datas[indexPath.item]
                return pddcell
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let vm = viewModel else { return UICollectionReusableView(frame: CGRect.zero) }
        let group = vm.groups[indexPath.section]
        guard let headViewId = group.headViewId else { return UICollectionReusableView(frame: CGRect.zero) }
        // 1.取出HeaderView
        let headerView = self.collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headViewId, for: indexPath) as! PDDCollectionReusableView
        
        // 2.给HeaderView设置数据
        headerView.group = group
        return headerView
    }
}

extension DKCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let vm = viewModel else { return CGSize.zero }
        return vm.groups[indexPath.section].itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        guard let vm = viewModel else { return UIEdgeInsets.zero }
        return vm.groups[section].sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let vm = viewModel else { return 0 }
        return vm.groups[section].lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        guard let vm = viewModel else { return 0 }
        return vm.groups[section].interitemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let vm = viewModel else { return CGSize.zero }
        let group = vm.groups[section]
        return group.headViewSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let vm = viewModel else { return CGSize.zero }
        let group = vm.groups[section]
        return group.footViewSize
    }
}

//添加上拉加载和下啦刷新
extension DKCollectionController {
    
    func setupRefreshFooter () {
        collectionView.refreshFooter = LCRefreshFooter(refreshBlock: { [unowned self] in
            if self.footerRefreshBlock != nil {
                self.footerRefreshBlock!()
            }
        })
    }
    func setupRefreshHeader () {
        collectionView.refreshHeader = LCRefreshHeader(refreshBlock: { [unowned self] in
            if self.headerRefreshBlock != nil {
                self.headerRefreshBlock!()
            }
        })
    }
}
