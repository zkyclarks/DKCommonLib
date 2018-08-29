//
//  DKChatBoard.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/22.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

let kBoardH:CGFloat = 230

enum BoardShownStatus {
    case NoShown
    case BoardShown
}
public protocol DKChatBoardDelegate : NSObjectProtocol {
    func didSendTextMessage(message:String)
    func didSendImageMessage(message:UIImage)
    func didSendSoundMessage(message:Data)
    func didSendFileMessage(message:Data)
}
class DKChatBoardManager {
    weak var delegate:DKChatBoardDelegate?
    var boardAnimateDuration:TimeInterval = 0.25
    var boardShownStatus:BoardShownStatus = .NoShown
    var boardHideFrame = CGRect.zero
    var boardShowFrame = CGRect.zero
    
    var curBoard:DKBaseView?
    
    @objc func bgViewTaped() {
        AppDelegate.instance.window?.endEditing(true)
        if boardShownStatus == .BoardShown {
            setBoardFrameAnimated(curBoard!, frame: boardHideFrame)
            boardFrame = boardHideFrame
            boardShownStatus = .NoShown
            toolbar.resetButtonStatus()
        }
    }
    
    weak var contentView:UIView? {
        didSet {
            let bgView = UIView.init(frame:(contentView?.bounds)!)
            contentView?.addSubview(bgView)
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(bgViewTaped))
            bgView.addGestureRecognizer(tap)
            
            addNotifications()
            let width = contentView?.frame.width ?? 0
            let height = kChatToolbarH
            let y = (contentView?.frame.height ?? 0) - height
            toolbar.frame = CGRect(x: 0, y: y, width: width, height: height)
            contentView?.addSubview(toolbar)
        }
    }
    lazy var toolbar:DKChatToolbar = {
        guard let view = Bundle.main.loadNibNamed("DKChatToolbar", owner: nil, options: nil)![0] as? DKChatToolbar else {
            fatalError("DKChatBoard.addTopToolbar : 添加输入框失败")
        }
        view.delegate = self
        return view
    }()
    lazy var emojiView:DKEmojiView = {
        let view = DKEmojiView()
        boardHideFrame = CGRect(x: 0, y: (contentView?.frame.height)!, width: (contentView?.frame.width)!, height: kBoardH)
        boardShowFrame = CGRect(x: 0, y: (contentView?.frame.height)! - kBoardH, width: (contentView?.frame.width)!, height: kBoardH)
        view.frame = boardHideFrame
        contentView?.addSubview(view)
        view.delegate = self
        return view
    }()
    lazy var extraView:DKExtraView = {
        let view = DKExtraView()
        view.frame = boardHideFrame
        contentView?.addSubview(view)
        return view
    }()
    
    lazy var soundRecorder:DKChatSoundRecorder = {
        let rec = DKChatSoundRecorder.instance
        rec.delegate = self
        return rec
    }()
    
    lazy var soundTipView:DKChatSoundView = {
        let view = DKChatSoundView()
        view.delegate = self
        contentView?.addSubview(view)
        return view
    }()
    
    var boardFrame:CGRect = CGRect.zero {
        didSet {
            UIView.animate(withDuration: boardAnimateDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                var toolbarFrame = self.toolbar.frame
                let offset = self.toolbar.frame.maxY - self.boardFrame.minY
                toolbarFrame.origin.y -= offset
                self.toolbar.frame = toolbarFrame
            }, completion: nil)
        }
    }
    
    func setBoardFrameAnimated(_ board:UIView, frame:CGRect) {
        UIView.animate(withDuration: boardAnimateDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            board.frame = frame
        }, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notify:NSNotification) {
        guard let userInfo = notify.userInfo else { return }
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        boardAnimateDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        boardFrame = keyboardRect
        toolbar.resetButtonStatus()
    }
    
    @objc func keyboardWillHide(_ notify:NSNotification) {
        guard let userInfo = notify.userInfo else { return }
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        if boardShownStatus == .NoShown {
            boardFrame = keyboardRect
        } else {
            boardFrame = boardShowFrame
        }
    }
    
    deinit {
        removeNotifications()
    }
}


extension DKChatBoardManager : DKChatToolbarDelegate {
    func showEmojiView() {
        if boardShownStatus == .NoShown {
            setBoardFrameAnimated(emojiView, frame: boardShowFrame)
            boardFrame = boardShowFrame
        } else if boardShownStatus == .BoardShown {
            emojiView.frame = boardShowFrame
            extraView.frame = boardHideFrame
        }
        boardShownStatus = .BoardShown
        contentView?.endEditing(true)
        curBoard = emojiView
    }
    
    func hideEmojiView() {
        if toolbar.soundBtn.status == 0 {
            toolbar.textInput.becomeFirstResponder()
            emojiView.frame = boardHideFrame
            boardShownStatus = .NoShown
            curBoard = nil
        } else {
            setBoardFrameAnimated(curBoard!, frame: boardHideFrame)
            boardFrame = boardHideFrame
            boardShownStatus = .NoShown
        }
        
    }
    
    func showExtraView() {
        if boardShownStatus == .NoShown {
            setBoardFrameAnimated(extraView, frame: boardShowFrame)
            boardFrame = boardShowFrame
        } else if boardShownStatus == .BoardShown {
            extraView.frame = boardShowFrame
            emojiView.frame = boardHideFrame
        }
        boardShownStatus = .BoardShown
        contentView?.endEditing(true)
        curBoard = extraView
    }
    
    func hideExtraView() {
        if toolbar.soundBtn.status == 0 {
            toolbar.textInput.becomeFirstResponder()
            extraView.frame = boardHideFrame
            boardShownStatus = .NoShown
            curBoard = nil
        } else {
            setBoardFrameAnimated(curBoard!, frame: boardHideFrame)
            boardFrame = boardHideFrame
            boardShownStatus = .NoShown
        }
    }
    
    func sendTextMessage() {
        guard let del = delegate else {
            return
        }
        let msg = toolbar.textInput.text ?? ""
        del.didSendTextMessage(message: msg)
    }
    
    func soundInputButtonPressDown() {
        soundRecorder.startRecord()
        soundTipView.downcountMaxTime = 60
        soundTipView.startRecord()
        soundTipView.center = CGPoint(x: (contentView?.center.x)!, y: (contentView?.center.y)! - 30)
    }
    func soundInputButtonWillCancel() {
        soundTipView.recordState = .WillCancel
    }
    
    func soundInputButtonPressResume() {
        soundTipView.recordState = .Resume
    }
    
    func soundInputButtonUpInside() {
        soundTipView.recordState = .Stoped
    }
    
    func soundInputButtonCancelled() {
        
    }
}

extension DKChatBoardManager : DKEmojiViewDelegate {
    func didClickEmoji(emoji: String) {
        let oldTxt = toolbar.textInput.text ?? ""
        toolbar.textInput.text = "\(oldTxt)\(emoji)"
        toolbar.textViewContentChanged()
    }
    func didClickDelete() {
        let oldTxt = toolbar.textInput.text ?? ""
        if oldTxt.count == 0 { return }
        let newTxt = oldTxt.substring(start: 0, lenth: oldTxt.count - 1)
        toolbar.textInput.text = newTxt
        toolbar.textViewContentChanged()
    }
    func didClickSend() {
        sendTextMessage()
    }
}

extension DKChatBoardManager : DKChatRecordDelegate {
    func onRecordStart() {
        
    }
    
    func onRecording() {
        
    }
    
    func onRecordPeak(_ peak: Int) {
        soundTipView.onRecorderPeakChanged(peaker: peak)
    }
    
    func onRecordWillCancel() {
        
    }
    
    func onRecordCancel() {
        
    }
    
    func onRecordResume() {
        
    }
    
    func onRecordTooShort() {
        
    }
    
    func onRecordFail() {
        
    }
    
    func onRecordSuccess(_ recordData: Data) {
        
    }
    

}

extension DKChatBoardManager : DKSoundTipViewDelegate {
    func onTimeOver() {
        
    }
    
    
}

extension DKChatBoardManager {
    func addNotifications() {
        // 添加键盘事件
        let center = NotificationCenter.default
        let sel1 = #selector(keyboardWillShow(_ :))
        let sel2 = #selector(keyboardWillHide(_ :))
        center.addObserver(self, selector: sel1, name: .UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: sel2, name: .UIKeyboardWillHide, object: nil)
    }
    
    func removeNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
