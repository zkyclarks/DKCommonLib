//
//  DKCycleView.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/21.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

private let kCycleCellID = "kCycleCellID"

class DKCycleView: UIView {
    public var loopable : Bool = true
    public var autoscroll : Bool = true
    // MARK: 定义属性
    fileprivate var cycleTimer : Timer?
    var cycleModels : [DKCycleCellModel]? {
        didSet {
            // 1.刷新collectionView
            collectionView.reloadData()
            
            // 2.设置pageControl个数
            pageControl.numberOfPages = cycleModels?.count ?? 0
            if pageControl.numberOfPages == 1 {
                return
            }
            // 3.默认滚动到中间某一个位置
            if loopable {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1) {[unowned self] in
                    let indexPath = IndexPath(item: (self.cycleModels?.count ?? 0) * 10, section: 0)
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
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    var isHidePageControl = false {
        didSet {
            pageControl.isHidden = isHidePageControl
        }
    }
    
    // MARK: 系统回调函数
    override func awakeFromNib() {
        super.awakeFromNib()
        // 设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        // 注册Cell
        collectionView.register(DKCycleCell.self, forCellWithReuseIdentifier: kCycleCellID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //设置cell大小
        collectionView.contentSize = collectionView.bounds.size
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size
    }
}

// MARK:- 提供一个快速创建View的类方法
extension DKCycleView {
    class func cycleView() -> PDDCycleView {
        return Bundle.main.loadNibNamed("DKCycleView", owner: nil, options: nil)?.first as! PDDCycleView
    }
}

// MARK:- 遵守UICollectionView的数据源协议
extension DKCycleView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if cycleModels?.count == 1 {
            return 1
        }
        return (cycleModels?.count ?? 0) * 10000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCycleCellID, for: indexPath) as! DKCycleCell
        
        let model = cycleModels![(indexPath as NSIndexPath).item % cycleModels!.count]
        cell.model = model
        
        return cell
    }
}

// MARK:- 遵守UICollectionView的代理协议
extension DKCycleView : UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1.获取滚动的偏移量
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        // 2.计算pageControl的currentIndex
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (cycleModels?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoscroll {
            return
        }
        removeCycleTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoscroll {
            return
        }
        addCycleTimer()
    }
}

// MARK:- 对定时器的操作方法
extension DKCycleView {
    fileprivate func addCycleTimer() {
        if cycleModels?.count == 1 {
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
