//
//  DKChatSoundRecorder.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/23.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox
import SwiftProgressHUD

enum DKRecorderState {
    case Stoped
    case Recoring
    case WillCancel
    case Cancel
    case MaxTime
    case Success
    case TooShort
}

@objc protocol DKChatRecordDelegate {

    func onRecordStart()
    func onRecording()
    func onRecordPeak(_ peak:Int)
    func onRecordWillCancel()
    func onRecordCancel()
    func onRecordResume()
    func onRecordTooShort()
    func onRecordFail()
    func onRecordSuccess(_ recordData:Data)
}

let kChatRecordMaxDuration = 60

class DKChatSoundRecorder {
    static let instance = DKChatSoundRecorder()
    lazy var origCategory = session.category
    lazy var origMode = session.mode
    lazy var origCateOptions = session.categoryOptions
    lazy var session:AVAudioSession = AVAudioSession.sharedInstance()
    var recorder:AVAudioRecorder?
    var recordSavePath:String?
    var recorderTimer:Timer?
    var recorderPeakerTimer:Timer?
    
    var recordState : DKRecorderState?
    var recordPeak : Int = 1
    var recordDuration : Int = 0
    var delegate: DKChatRecordDelegate?
    
    func activeAudioSession() {
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.setActive(true)
//            var audioRouteOverride = UInt32(kAudioSessionOverrideAudioRoute_Speaker)
//            AudioSessionSetProperty(AudioSessionPropertyID(kAudioSessionProperty_OverrideAudioRoute), UInt32(MemoryLayout.size(ofValue: audioRouteOverride)), &audioRouteOverride)
        } catch {
            print("音频设置失败")
        }
    }
    
    deinit {
        stopRecord()
        do {
            try session.setCategory(origCategory, with: origCateOptions)
            try session.setMode(origMode)
        } catch {
            print("还原音频失败")
        }
    }
    
    func initRecord() -> Bool {
        //录音设置
        let recordSetting = [AVFormatIDKey:NSNumber(value: kAudioFormatMPEG4AAC),//设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
                             AVSampleRateKey:NSNumber(value: 44100.0),//设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
                             AVNumberOfChannelsKey:NSNumber(value: 1),//录音通道数  1 或 2
                             AVLinearPCMBitDepthKey:NSNumber(value: 16),//线性采样位数  8、16、24、32
                             AVEncoderAudioQualityKey:NSNumber(value: Int8(AVAudioQuality.high.rawValue))]//录音的质量
        let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
        
        let strUrl = "\(dir)/\(String.uuid()).mp4"
        let url = URL(fileURLWithPath: strUrl)
        recordSavePath = strUrl
        
        do {
            try recorder = AVAudioRecorder(url: url, settings: recordSetting) //初始化
            guard let rec = recorder else {return false}
            rec.isMeteringEnabled = true //开启音量检测
            if rec.prepareToRecord() {
                return true
            } else {
                print("录音机初始化失败")
                return false
            }
        } catch {
            print("还原音频失败")
        }
        return false
    }
    
    func startRecord() {
    // 获取麦克风权限
       
        session.requestRecordPermission { (available) in
            if !available {
                DispatchQueue.main.async {
                    UIAlertView(title: "无法录音", message: "请在“设置-隐私-麦克风”中允许访问麦克风。", delegate: nil, cancelButtonTitle: "确定").show()
                }
            } else {
                DispatchQueue.main.async {[unowned self] in
                    self.startRecording()
                }
            }
        }
    }
    
    func startRecording() {
        if let rec = recorder {
            rec.stop()
            
        } else if !initRecord() {
            SwiftProgressHUD.showInfo("初始化录音机失败", autoClear: true, autoClearTime: 2)
            return
        }
        let rec = recorder!
        rec.record()
        delegate?.onRecording()
        
        recordPeak = 1
        recordDuration = 0
        recordState = .Recoring
        
        recorderTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onRecording), userInfo: nil, repeats: true)
        RunLoop.current.add(recorderTimer!, forMode: RunLoopMode.commonModes)
        recorderPeakerTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(onRecordPeak), userInfo: nil, repeats: true)
        RunLoop.current.add(recorderPeakerTimer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc func onRecordPeak() {
        guard let rec = recorder else {return}
        rec.updateMeters()
        
        var peakPower = rec.peakPower(forChannel: 0)
        peakPower = pow(10, (0.05 * peakPower))
        
        var peak = Int((peakPower * 100)/20 + 1)
        if peak < 1 {
            peak = 1
        } else if peak > 5 {
            peak = 5
        }
        if peak != recordPeak {
            recordPeak = peak
        }
        delegate?.onRecordPeak(peak)
    }
    
    @objc func onRecording() {
        
        recordDuration += 1
        if recordDuration == kChatRecordMaxDuration {
            recordState = .MaxTime
            stopRecord()
        }   else if recordDuration == 1 {
            delegate?.onRecordStart()
        }
    }
        
        
    func willCancelRecord() {
        recordState = .WillCancel
        delegate?.onRecordWillCancel()
    }
    
    func continueRecord() {
        recordState = .Recoring;
        delegate?.onRecordResume()
    }
    
    
    func stopRecord()
    {
        clearTimers()
        
        if recordState == .Cancel {
            recordState = .Stoped
            delegate?.onRecordCancel()
        }
        guard let rec = recorder else {return}
        if rec.currentTime < 0.5 {
            // 录音太短
            recordState = .TooShort
            delegate?.onRecordTooShort()
        }
        else
        {
            var suc = true
            var audioData:Data?
            do {
                audioData = try Data(contentsOf: rec.url)
            } catch {
                delegate?.onRecordFail()
                suc = false
            }
            if suc {
                delegate?.onRecordSuccess(audioData!)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1) {
            self.recordState = .Stoped
        }
        rec.stop()
        if FileManager.default.fileExists(atPath: rec.url.path) {
            if rec.isRecording {
                rec.deleteRecording()
            }
        }
        
    }
    
    private func clearTimers () {
        recorderTimer?.invalidate()
        recorderTimer = nil
        
        recorderPeakerTimer?.invalidate()
        recorderPeakerTimer = nil
    }
    
    func recordTime() -> TimeInterval {
        guard let rec = recorder else {return 0}
        return rec.currentTime + 0.5
    }
}
