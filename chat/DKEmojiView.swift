//
//  DKEmojiViews.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/21.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

let kEmojiItemW:CGFloat = 49.3
let kEmojiItemH:CGFloat = 44
let kEmojiItemSpace:CGFloat = 0
@objc public protocol DKEmojiViewDelegate {
    func didClickEmoji(emoji:String)
    func didClickDelete()
    func didClickSend()
}
class DKEmojiView : DKBaseView {
    weak var delegate:DKEmojiViewDelegate?
    lazy var cycleView:DKCycleView = {
        var emojiCodes = [Int]()
        for c in 0xE401...0xE42A {
            emojiCodes.append(c)
        }
        let group = DKCellGroupModel()
        group.cellId = "DKEmojiCellId"
        group.cellType = DKEmojiCell.self
        group.itemSize = CGSize(width: kEmojiItemW, height: kEmojiItemH)
        group.lineSpacing = kEmojiItemSpace
        group.interitemSpacing = kEmojiItemSpace
        
        for c in emojiCodes {
            let emojiModel = DKEmojiCellModel()
            emojiModel.emojiCode = c
            group.datas.append(emojiModel)
        }
        
        let view = DKCycleView.cycleView()
        view.loopable = false
        view.autoscroll = false
        view.isHidePageControl = true
        view.modelGroups = [group]
        view.delegate = self
        return view
    }()
    lazy var deleteButton:ExtButton = {
        let btn = ExtButton(type: UIButtonType.custom)
        btn.setImage(UIImage(named: "face_delete_normal"), for: UIControlState.normal)
        btn.setImage(UIImage(named: "face_delete_press"), for: UIControlState.highlighted)
        btn.addTarget(self, action: #selector(deleteBtnClicked), for: UIControlEvents.touchUpInside)
        addSubview(btn)
        return btn
    }()
    lazy var sendButton:ExtButton = {
        let btn = ExtButton(type: UIButtonType.custom)
        btn.setTitle("发送", for: UIControlState.normal)
        btn.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
        btn.setTitleColor(UIColor.lightGray, for: UIControlState.highlighted)
        btn.setCorner(color: UIColor.darkGray, radius: 2)
        btn.addTarget(self, action: #selector(sendBtnClicked), for: UIControlEvents.touchUpInside)
        addSubview(btn)
        return btn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cycleView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cycleView.frame = CGRect(x: 15, y: 10, width: bounds.width - 30, height: bounds.height - 60)
        sendButton.setSize(CGSize(width: 50, height: 25))
        sendButton.setOrigin(CGPoint(x: width() - 80, y: height() - 40))
        deleteButton.setSize(CGSize(width: 50, height: 30))
        deleteButton.setOrigin(CGPoint(x: width() - 140, y: height() - 40))
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension DKEmojiView: DKCycleViewDelegate {
    func cycleView(_ cycleView: DKCycleView, didSelectItemModel: DKCellItemModel) {
        guard let del = delegate else { return }
        let model = didSelectItemModel as! DKEmojiCellModel
        let codeString = String(UnicodeScalar(model.emojiCode)!)
        del.didClickEmoji(emoji: codeString)
    }
    @objc func deleteBtnClicked() {
        guard let del = delegate else { return }
        del.didClickDelete()
    }
    @objc func sendBtnClicked() {
        guard let del = delegate else { return }
        del.didClickSend()
    }
}


class DKEmojiCell : DKCycleCell {
    lazy var button: DKEmojiButton = {
        let btn = DKEmojiButton.init(type: UIButtonType.custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 40)
        btn.showsTouchWhenHighlighted = true
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    override var data: DKCellItemModel? {
        didSet {
            guard let model = data as? DKEmojiCellModel else { return }
            if model.emojiCode == 0 {
                button.setTitle(nil, for: UIControlState.normal)
                button.setImage(UIImage(named: "face_delete_normal"), for: UIControlState.normal)
                button.setImage(UIImage(named: "face_delete_press"), for: UIControlState.highlighted)
            } else {
                let codeString = String(UnicodeScalar(model.emojiCode)!)
                button.setTitle(codeString, for: UIControlState.normal)
                button.setImage(nil, for: UIControlState.normal)
                button.setImage(nil, for: UIControlState.highlighted)
            }
            self.addSubview(button)
        }
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = bounds
    }
}

class DKEmojiCellModel : DKCellItemModel {
    var emojiCode:Int = 0
}

class DKEmojiButton : ExtButton {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
    }
}
