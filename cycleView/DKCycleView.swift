//
//  DKCycleView.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/21.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

@objc public protocol DKCycleViewDelegate {
    @objc optional func cycleView(_ cycleView:DKCycleView, didSelectItemModel:DKCellItemModel)
}

private let kCycleCellID = "kCycleCellID"

public class DKCycleView: UIView {
    public var delegate : DKCycleViewDelegate?
    public var loopable : Bool = true
    public var autoscroll : Bool = true
    // MARK: 定义属性
    fileprivate var cycleTimer : Timer?
    var modelGroups : [DKCellGroupModel]? {
        didSet {
            // 1.刷新collectionView
            collectionView.modelGroups = modelGroups
            collectionView.reloadData()
            
            // 2.设置pageControl个数
            pageControl.numberOfPages = modelGroups?.count ?? 0
            if pageControl.numberOfPages <= 1 {
                return
            }
            // 3.默认滚动到中间某一个位置
            if loopable {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {[unowned self] in
                    let indexPath = IndexPath(item: (self.modelGroups?.count ?? 0) * 10, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
                }
            }
            if autoscroll {
                // 4.添加定时器
                removeCycleTimer()
                addCycleTimer()
            }
        }
    }
    
    // MARK: 控件属性
    @IBOutlet weak var collectionView: DKCollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var isHidePageControl = false {
        didSet {
            pageControl.isHidden = isHidePageControl
        }
    }
    
    // MARK: 系统回调函数
    override public func awakeFromNib() {
        super.awakeFromNib()
        // 设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        collectionView.backgroundColor = UIColor.white
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.dkdelegate = self
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        collectionView.contentSize = collectionView.bounds.size
    }
}

// MARK:- 提供一个快速创建View的类方法
extension DKCycleView {
    class func cycleView() -> DKCycleView {
        return Bundle.main.loadNibNamed("DKCycleView", owner: nil, options: nil)?.first as! DKCycleView
    }
}

// MARK:- 遵守DKCollectionViewDelegate的代理协议
extension DKCycleView : DKCollectionViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        // 2.计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (modelGroups?.count ?? 1)
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoscroll {
            return
        }
        removeCycleTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoscroll {
            return
        }
        addCycleTimer()
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! DKEmojiCell
        delegate?.cycleView!(self, didSelectItemModel: item.data!)
    }
}

// MARK:- 对定时器的操作方法
extension DKCycleView {
    fileprivate func addCycleTimer() {
        if (modelGroups?.count)! <= 1 {
            return
        }
        cycleTimer = Timer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(cycleTimer!, forMode: RunLoopMode.commonModes)
    }
    
    fileprivate func removeCycleTimer() {
        cycleTimer?.invalidate() // 从运行循环中移除
        cycleTimer = nil
    }
    
    @objc fileprivate func scrollToNext() {
        // 1.获取滚动的偏移量
        let currentOffsetX = collectionView.contentOffset.x
        let offsetX = currentOffsetX + collectionView.bounds.width
        
        // 2.滚动该位置
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: true)
    }
}
