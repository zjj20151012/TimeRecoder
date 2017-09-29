//
//  CommonRecordManager.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/28.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class CommonRecordManager:NSObject {
    
    /// 录制音频的总时长
    var totalLength: Float?
    
    var recorder: AVAudioRecorder?
    
    var player: AVAudioPlayer?
    
    var dateStr: String?
    
    var finalPath: String?
    
    let filePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first?.appending("/")

    // 单例
    static let sharedManager = CommonRecordManager.init()
    private override init(){}

    //MARK: 文件操作
    func writeToFile() {
        let weekday = getWeekDay()
        let dict: NSDictionary = ["audioName" : dateStr! as NSString,
                                  "date" : dateStr! as NSString,
                                  "filePath" : finalPath! as NSString,
                                  "weekday" : String.init(format: "%d", weekday)
                                  ]
        let model = RainbowRecodModel.init(dict: dict as! [String : AnyObject])
        saveAudio(data: model, key: dateStr!)
        readFromFile()
    }
        
    func readFromFile() {
      let data = getSavedAudio()
        NSLog("%@",data)
    }
    
    func deleteCurFile() {
        deleteAudio(key: dateStr!)
    }
    
    //MARK: 开始录音
    func beginRecord() {
        let session = AVAudioSession.sharedInstance()
        // 设置session类型
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let err{
            print("设置失败:\(err.localizedDescription)")
        }
        // 设置session动作
        do {
            try session.setActive(true)
        } catch let err {
            print("初始化失败:\(err.localizedDescription)")
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
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY年MM月dd日hh时mm分ss秒"
            let nowTime = dateFormatter.string(from: date) as String
            finalPath = filePath?.appending(nowTime + ".wav")
            let url = URL(fileURLWithPath: finalPath!)
            dateStr = nowTime
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
                writeToFile()
                print("文件保存到了：\(finalPath!)")
            }else {
                print("没有录音")
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
    
    //MARK: 播放
    func play(path: String) {
        do {
            var filePath: String = path
            if filePath.isEmpty {
                filePath = finalPath!
            }
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: filePath))
            player?.delegate = self
            print("录音长度：\(player!.duration)")
            totalLength = Float((player?.duration)!) 
            player!.play()
        } catch let err {
            print("播放失败:\(err.localizedDescription)")
        }
    }
    
    //MARK: 暂停播放
    func pause() {
        player?.pause()
    }
    
    //MARK: 继续播放
    func resume() {
        player?.play()
    }
    
    //MARK: 停止播放
    func stop() {
        player?.stop()
    }
    
    //MARK: 检测播放状态
    func checkState() -> Bool {
        return (player?.isPlaying)!
    }
}

//MARK: AVAudioPlayerDelegate
extension CommonRecordManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let alert = UIAlertController.init(title: "提示", message: "播放完毕，总时长\(totalLength!) S", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction.init(title: "好", style: UIAlertActionStyle.default, handler: nil))
        getCurViewController().present(alert, animated: true, completion: nil)
    }
}
