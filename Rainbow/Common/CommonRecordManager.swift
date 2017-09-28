//
//  CommonRecordManager.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/28.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import Foundation
import AVFoundation

class CommonRecordManager:NSObject {
    
    /// 录制音频的总时长
    var totalLength: Float?
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/dailyRecord.wav")

    // 单例
    static let sharedManager = CommonRecordManager.init()
    private override init(){}
    
    //MARK: 开始录音
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        // 设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            print("设置类型失败:\(err.localizedDescription)")
        }
        // 设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化动作失败:\(err.localizedDescription)")
        }
        // 录音设置
        let recordSetting: [String: Any] = [AVSampleRateKey: NSNumber(value: 44100),//采样率
            AVFormatIDKey: NSNumber(value: kAudioFormatLinearPCM),//音频格式
            AVLinearPCMBitDepthKey: NSNumber(value: 16),//采样位数
            AVNumberOfChannelsKey: NSNumber(value: 2),//通道数
            AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.min.rawValue)//录音质量
        ];
        // 开始录音
        do {
            let url = URL(fileURLWithPath: filePath!)
            recorder = try AVAudioRecorder(url: url, settings: recordSetting)
            recorder!.prepareToRecord()
            recorder!.record()
            print("开始录音")
        } catch let err {
            print("录音失败:\(err.localizedDescription)")
        }
    }

    //MARK: 结束录音
    func stopRecord() {
        if let recorder = self.recorder {
            if recorder.isRecording {
                print("正在录音，马上结束它，文件保存到了：\(filePath!)")
            }else {
                print("没有录音，但是依然结束它")
            }
            // 处理录制音频后播放声音特别小的问题
            let session: AVAudioSession = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(AVAudioSessionCategoryPlayback)
            } catch let err {
                print("失败:\(err.localizedDescription)")
            }
            recorder.stop()
            self.recorder = nil
        }else {
            print("没有初始化")
        }
    }
    
    //MARK: 删除文件
    func deleteCurFile() {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: filePath!)
            print("删除成功!")
        } catch let err {
            print("删除文件失败:\(err.localizedDescription)")
        }
    }
    
    //MARK: 播放
    func play() {
        do {
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath!))
            player?.delegate = self
            print("歌曲长度：\(player!.duration)")
            totalLength = Float((player?.duration)!) 
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    //MARK: 停止播放
    func stop() {
        player?.stop()
    }
}

extension CommonRecordManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    print("12343")

    }
}
