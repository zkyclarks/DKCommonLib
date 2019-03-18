//
//  DKChatSoundView.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/22.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit
enum DKSoundTipState {
    case Stoped
    case Recoring
    case WillCancel
    case Resume
    case MaxTime
    case TooShort
}

@objc protocol DKSoundTipViewDelegate {
    func onTimeOver()
}
class DKChatSoundView: UIImageView {
    var downcountMaxTime = 60
    var downcountTime  = 60
    var downcountTimer:Timer?
    lazy var imageTip:UIImageView = {
        let view = UIImageView()
        view.contentMode = UIViewContentMode.center
        view.image = UIImage(named: "microphone1")
        addSubview(view)
        return view
    }()
    lazy var cancelImageTip:UIImageView = {
        let view = UIImageView()
        view.contentMode = UIViewContentMode.center
        view.image = UIImage(named: "sound_record_cancel")
        view.isHidden = true
        addSubview(view)
        return view
    }()
    lazy var countdownTip:UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = UIFont.boldSystemFont(ofSize: 14)
        view.textAlignment = NSTextAlignment.center
        addSubview(view)
        return view
    }()
    lazy var tip:UILabel = {
        let view = UILabel()
        view.textColor = UIColor.white
        view.font = UIFont.systemFont(ofSize: 12)
        view.textAlignment = NSTextAlignment.center
        view.layer.cornerRadius = 2
        view.backgroundColor = UIColor.clear
        view.text = "手指上滑，取消发送"
        addSubview(view)
        return view
    }()
    var recordState:DKSoundTipState = .Stoped {
        didSet {
            switch recordState {
            case .Stoped :
                fadeOut()
            case .Recoring :
                setRecordingState()
            case .Resume :
                print("Resume")
                setRecordingState()
                setDowncountTimer()
            case .WillCancel :
                self.cancelImageTip.isHidden = false
                self.imageTip.isHidden = true
                self.tip.text = "松开手指，取消发送"
                self.tip.backgroundColor = UIColor.red
                clearTimer()
            case .MaxTime :
                self.cancelImageTip.isHidden = true
                self.imageTip.isHidden = false
                self.tip.text = "录音超过一分钟自动发送"
                self.tip.backgroundColor = UIColor.clear
                recordState = .Stoped
            case .TooShort :
                self.cancelImageTip.isHidden = true
                self.imageTip.isHidden = false
                self.tip.text = "录音太短，取消发送"
                self.tip.backgroundColor = UIColor.red
            }
        }
    }
    
    func setRecordingState() {
        self.cancelImageTip.isHidden = true
        self.imageTip.isHidden = false
        self.tip.text = "手指上滑，取消发送"
        self.tip.backgroundColor = UIColor.clear
    }
    
    weak var delegate:DKSoundTipViewDelegate?

    
    func relayoutFrameOfSubViews() {
        if let img = image {
            frame.size = img.size
        }else {
            image = UIImage(named: "sound_record")
            frame.size = image!.size
        }
        let rect = CGRect(x: width() / 4,
                          y: height() / 4,
                          width: width() / 2,
                          height: height() / 2)
        imageTip.frame = rect
        cancelImageTip.frame = rect
        countdownTip.assign(width:width())
        countdownTip.assign(height:20)
        countdownTip.assign(y:10)
        tip.frame = CGRect(x: (bounds.width - 120) / 2,
                            y: bounds.height - 28,
                            width: 120, height: 20)
        
    }
    func startRecord() {
        relayoutFrameOfSubViews()
        fadeIn()
        startDowncount()
    }
    @objc func onDowncount() {
        if downcountTime == 0 {
            if let t = downcountTimer {
                t.invalidate()
                downcountTimer = nil
            }
            guard let del = delegate else { return }
            del.onTimeOver()
            recordState = .MaxTime
            return
        }
        downcountTime -= 1
        countdownTip.text = "\(downcountTime)"
    }
    
    func startDowncount() {
        downcountTime = downcountMaxTime
        setDowncountTimer()
    }
    func setDowncountTimer() {
        downcountTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onDowncount), userInfo: nil, repeats: true)
        print("setDowncountTimer")
    }
    
    func onRecorderPeakChanged(peaker:Int) {
        let tip = "microphone\(peaker)"
        self.imageTip.image = UIImage(named: tip)
    }
    
    func fadeIn() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber(value: 0.0)
        animation.toValue = NSNumber(value: 1.0)
        animation.duration = 2
        self.layer.add(animation, forKey: "kAnimationFadeInt")
    }
    func fadeOut() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber(value: 1.0)
        animation.toValue = NSNumber(value: 0.0)
        animation.duration = 2
        animation.beginTime = 2
        self.layer.add(animation, forKey: "kAnimationFadeOut")
    }
    func clearTimer() {
        downcountTimer?.invalidate()
        downcountTimer = nil
    }
    deinit {
        clearTimer()
        delegate = nil
    }
}

