//
//  DKChatInputView.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/19.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

let kChatToolbarH:CGFloat = 46

enum MessageType {
    case text
    case sound
    case image
    case video
    case file
}

@objc protocol DKChatToolbarDelegate {
    func showEmojiView()
    func hideEmojiView()
    func showExtraView()
    func hideExtraView()
    func sendTextMessage()
    func soundInputButtonPressDown()
    func soundInputButtonWillCancel()
    func soundInputButtonPressResume()
    func soundInputButtonUpInside()
    func soundInputButtonCancelled()
}

class DKChatToolbar: UIView , UITextViewDelegate {
    weak var delegate : DKChatToolbarDelegate?
    
    @IBOutlet weak var soundBtn: DKToolbarButton!
    @IBOutlet weak var textInput: UITextView!
    @IBOutlet weak var soundInputBtn: ExtButton!
    @IBOutlet weak var emojiBtn: DKToolbarButton!
    @IBOutlet weak var extraBtn: DKToolbarButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setSubviewStatus()
        setSoundInputBtnActions()
        textInputContentHeight = textInput.contentSize.height
    }
    //MARK: 语音文本输入切换
    @IBAction func soundBtnClicked() {
        if soundBtn.status == 0 {
            soundBtn.status = 1
            soundInputBtn.isHidden = false
            textInput.isHidden = true
        } else {
            soundBtn.status = 0
            soundInputBtn.isHidden = true
            textInput.isHidden = false
        }
    }
    
    @IBAction func emojiBtnClicked() {
        if emojiBtn.status == 0 {
            emojiBtn.status = 1
            if extraBtn.status == 1 {
                extraBtn.status = 0
            }
            if let del = delegate {
                del.showEmojiView()
            }
        } else {
            emojiBtn.status = 0
            if let del = delegate {
                del.hideEmojiView()
            }
        }
    }
    
    @IBAction func extraBtnClicked() {
        if extraBtn.status == 0 {
            extraBtn.status = 1
            if emojiBtn.status == 1 {
                emojiBtn.status = 0
            }
            if let del = delegate {
                del.showExtraView()
            }
        } else {
            extraBtn.status = 0
            if let del = delegate {
                del.hideExtraView()
            }
        }
    }
    
    func resetButtonStatus() {
        emojiBtn.status = 0
        extraBtn.status = 0
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            if let del = delegate {
                del.sendTextMessage()
            }
            return false;
        }
        textViewContentChanged()
        return true;
    }
    var textInputContentHeight:CGFloat = 0
    func textViewContentChanged() {
        if textInputContentHeight > 90 {
            return
        }
        if textInput.text.count < 10 {
            textInputContentHeight = textInput.contentSize.height
        } else if textInput.contentSize.height != textInputContentHeight {
            let offset = textInput.contentSize.height - textInputContentHeight
            let height = frame.height + offset
            let y = frame.minY - offset
            assign(height:height)
            assign(y:y)
            textInputContentHeight = textInput.contentSize.height
        }
    }
    
    
}
//MARK: - set sound input button actions
extension DKChatToolbar {
    func setSoundInputBtnActions() {
        soundInputBtn.addTarget(self, action: #selector(soundInputBtnPressDown), for: UIControlEvents.touchDown)
        soundInputBtn.addTarget(self, action: #selector(soundInputBtnWillCancel), for: UIControlEvents.touchDragExit)
        soundInputBtn.addTarget(self, action: #selector(soundInputBtnPressResume), for: UIControlEvents.touchDragEnter)
        soundInputBtn.addTarget(self, action: #selector(soundInputBtnUpInside), for: UIControlEvents.touchUpInside)
        soundInputBtn.addTarget(self, action: #selector(soundInputBtnCancelled), for: UIControlEvents.touchCancel)
    }
    @objc func soundInputBtnPressDown() {
        guard let del = delegate else { return }
        del.soundInputButtonPressDown()
    }
    @objc func soundInputBtnWillCancel() {
        guard let del = delegate else { return }
        del.soundInputButtonWillCancel()
    }
    @objc func soundInputBtnPressResume() {
        guard let del = delegate else { return }
        del.soundInputButtonPressResume()
    }
    @objc func soundInputBtnUpInside() {
        guard let del = delegate else { return }
        del.soundInputButtonUpInside()
    }
    @objc func soundInputBtnCancelled() {
        guard let del = delegate else { return }
        del.soundInputButtonCancelled()
    }
}

//MARK: - set button and views status
extension DKChatToolbar {
    func setSubviewStatus() {
        // 设置按钮的图片
        soundBtn.imgNames = ["chat_toolbar_voice", "chat_toolbar_keyboard"]
        emojiBtn.imgNames = ["chat_toolbar_smile", "chat_toolbar_keyboard"]
        extraBtn.imgNames = ["chat_toolbar_more", "chat_toolbar_keyboard"]
        // 设置声音按钮
        soundInputBtn.layer.cornerRadius = 4
        soundInputBtn.layer.masksToBounds = true
        soundInputBtn.layer.borderWidth = 1
        soundInputBtn.layer.borderColor = UIColor.gray.cgColor
        soundInputBtn.isHidden = true
        // 设置文本输入框
        textInput.layer.cornerRadius = 4
        textInput.layer.masksToBounds = true
        textInput.layer.borderWidth = 1
        textInput.layer.borderColor = UIColor.gray.cgColor
        textInput.delegate = self
        textInput.returnKeyType = UIReturnKeyType.send
    }
}


class DKToolbarButton : ExtButton {
    var imgNames:[String]? {
        didSet {
            guard let names = imgNames else { return }
            if names.count < 1 { return }
            setImage(UIImage(named: "\(names[0])_nor"), for: .normal)
            setImage(UIImage(named: "\(names[0])_press"), for: .highlighted)
        }
    }
    override var status: Int {
        didSet {
            guard let names = imgNames else { return }
            if names.count < 2 || status > 1 {
                return
            }
            setImage(UIImage(named: "\(names[status])_nor"), for: .normal)
            setImage(UIImage(named: "\(names[status])_press"), for: .highlighted)
        }
    }
}

