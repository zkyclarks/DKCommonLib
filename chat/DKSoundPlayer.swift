//
//  DKSoundPlayer.swift
//  PDDMall
//
//  Created by keyu zhang on 2018/8/23.
//  Copyright © 2018年 pdd. All rights reserved.
//

import UIKit
import AVFoundation

class DKSoundPlayer: NSObject, AVAudioPlayerDelegate {
    static let instance = DKSoundPlayer()
    var soundPlayer:AVAudioPlayer?
    var commonCompletionBlock:(()->())?
    
    deinit {
        stopPlay()
        commonCompletionBlock = nil
    }
    func playWith(data: Data, completion: ()->()) {
        stopPlay()
        do {
            soundPlayer = try AVAudioPlayer(data: data)
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch let err as NSError {
            print("Error creating player : \(err.description)")
        }
    }
    func playWithUrl(url: URL, completion: ()->()) {
        stopPlay()
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.delegate = self
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch let err as NSError {
            print("Error creating player : \(err.description)")
        }
    }
    func stopPlay() {
        if commonCompletionBlock != nil {
            commonCompletionBlock!()
        }
        guard let player = soundPlayer else {
            return
        }
        if player.isPlaying {
            player.stop()
        }
        player.delegate = nil;
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
    
}
