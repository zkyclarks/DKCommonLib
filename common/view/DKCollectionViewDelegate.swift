//
//  DKCollectionViewDelegate.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/21.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

@objc protocol DKCollectionViewDelegate : NSObjectProtocol {
    
    @available(iOS 6.0, *)
    @objc optional func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
    @objc optional func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath)

    
    //MARK: scroll view delegate
    @available(iOS 2.0, *)
    @objc optional func scrollViewDidScroll(_ scrollView: UIScrollView) // any offset changes
    
    // called on start of dragging (may require some time and or distance to move)
    @available(iOS 2.0, *)
    @objc optional func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    
    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    @available(iOS 5.0, *)
    @objc optional func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    
    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    @available(iOS 2.0, *)
    @objc optional func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    
    
    @available(iOS 2.0, *)
    @objc optional func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) // called on finger up as we are moving
    
    @available(iOS 2.0, *)
    @objc optional func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) // called when scroll view grinds to a halt
    
    @available(iOS 2.0, *)
    @objc optional func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
    
    @available(iOS 2.0, *)
    @objc optional func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
    
    @available(iOS 2.0, *)
    @objc optional func scrollViewDidScrollToTop(_ scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top

}

extension DKCollectionView : UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.collectionView(_:didSelectItemAt:))) {
            del.collectionView!(collectionView, didSelectItemAt: indexPath)
        }
    }
    public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.collectionView(_:didDeselectItemAt:))) {
            del.collectionView!(collectionView, didDeselectItemAt: indexPath)
        }
        
    }

    //MARK: - scroll view delegate
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewDidScroll(_:))) {
            del.scrollViewDidScroll!(scrollView)
        }
    }
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewWillBeginDragging(_:))) {
            del.scrollViewWillBeginDragging!(scrollView)
        }
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewWillEndDragging(_:withVelocity:targetContentOffset:))) {
            del.scrollViewWillEndDragging!(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
        }
    }
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewDidEndDragging(_:willDecelerate:))) {
            del.scrollViewDidEndDragging!(scrollView, willDecelerate: decelerate)
        }
    }
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewWillBeginDecelerating(_:))) {
            del.scrollViewWillBeginDecelerating!(scrollView)
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewDidEndDecelerating(_:))) {
            del.scrollViewDidEndDecelerating!(scrollView)
        }
    }
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewDidEndScrollingAnimation(_:))) {
            del.scrollViewDidEndScrollingAnimation!(scrollView)
        }
    }
    public func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        guard let del = delegate else { return false }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewShouldScrollToTop(_:))) {
            return del.scrollViewShouldScrollToTop!(scrollView)
        }
        return false
    }
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        guard let del = dkdelegate else { return }
        if del.responds(to: #selector(DKCollectionViewDelegate.scrollViewDidScrollToTop(_:))) {
            del.scrollViewDidScrollToTop!(scrollView)
        }
    }
}
