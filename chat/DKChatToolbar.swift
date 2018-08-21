//
//  DKChatInputView.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/19.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit

enum MessageType {
    case text
    case sound
    case image
    case video
    case file
}

class DKChatToolbar: UIView , UITextViewDelegate {
    //MARK: public property
    public var sendMessageBtnTaped : (()->())?
    public var soundButtonPressed : (()->())?
    public var soundButtonCancelled : (()->())?
    public var soundButtonPressEnd : (()->())?
    public var addImageBtnTaped : (()->())?
    public var addFileBtnTaped : (()->())?
    public func getText() -> String {
        return textInput.text
    }
    
    @IBOutlet weak var soundBtn: ExtButton!
    @IBOutlet weak var textInput: UITextView!
    @IBOutlet weak var soundInputBtn: ExtButton!
    @IBOutlet weak var emojiBtn: ExtButton!
    @IBOutlet weak var extraBtn: ExtButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //MARK: 设置按钮的图片
        soundBtn.setImage(UIImage(named: "chat_toolbar_voice_nor"), for: .normal)
        soundBtn.setImage(UIImage(named: "chat_toolbar_voice_press"), for: .highlighted)
        
        emojiBtn.setImage(UIImage(named: "chat_toolbar_smile_nor"), for: .normal)
        emojiBtn.setImage(UIImage(named: "chat_toolbar_smile_press"), for: .highlighted)
        
        extraBtn.setImage(UIImage(named: "chat_toolbar_more_nor"), for: .normal)
        extraBtn.setImage(UIImage(named: "chat_toolbar_more_press"), for: .highlighted)
        
        //MARK: 设置声音按钮
        soundInputBtn.layer.cornerRadius = 4
        soundInputBtn.layer.masksToBounds = true
        soundInputBtn.layer.borderWidth = 1
        soundInputBtn.layer.borderColor = UIColor.gray.cgColor
        soundInputBtn.isHidden = true
        //MARK: 设置文本输入框
        textInput.layer.cornerRadius = 4
        textInput.layer.masksToBounds = true
        textInput.layer.borderWidth = 1
        textInput.layer.borderColor = UIColor.gray.cgColor
        textInput.delegate = self
        textInput.returnKeyType = UIReturnKeyType.send
        
        //MARK: 添加键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardStatusChanged(_ :)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardStatusChanged(_ :)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    //MARK: 语音文本输入切换
    @IBAction func soundBtnClicked() {
        if soundBtn.status == 0 {
            soundBtn.status = 1
            soundBtn.setImage(UIImage(named: "chat_toolbar_keyboard_nor"), for: .normal)
            soundBtn.setImage(UIImage(named: "chat_toolbar_keyboard_press"), for: .highlighted)
            soundInputBtn.isHidden = false
            textInput.isHidden = true
        } else {
            soundBtn.status = 0
            soundBtn.setImage(UIImage(named: "chat_toolbar_voice_nor"), for: .normal)
            soundBtn.setImage(UIImage(named: "chat_toolbar_voice_press"), for: .highlighted)
            soundInputBtn.isHidden = true
            textInput.isHidden = false
        }
    }
    
    @IBAction func emojiBtnClicked() {
        
    }
    
    @IBAction func extraBtnClicked() {
        
    }
    
    @objc private func keyBoardStatusChanged(_ notify:Notification) {
        guard let userInfo = notify.userInfo else { return }
        let keyboardRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let y = keyboardRect.minY - frame.height
        let frm = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
        let info = notify.userInfo;
        let animationDuration = info![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.frame = frm
        }, completion: nil)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"
        {
            if let block = sendMessageBtnTaped {
                block()
            }
            return false;
        }
        return true;
    }
    
    
    
}
