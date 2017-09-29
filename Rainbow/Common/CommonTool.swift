//
//  CommonTool.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/21.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

let app: AppDelegate = UIApplication.shared.delegate as! AppDelegate

//MARK: 导航栏的底色
/// 导航栏的底色
///
/// - Returns: UIColor
func mainNavigationBarTintColor() -> UIColor {
    return UIColor(hexColor: "24bcff")
}

//MARK: app的主色调
/// app的主色调
///
/// - Returns: UIColor
func appThemeColor() -> UIColor {
    return UIColor(hexColor: "24bcff")
}

//MARK: 延迟执行某任务
/// 延迟执行某任务
///
/// - Parameters:
///   - seconds: 需要计时的事件
///   - completion: 计时时间到了之后执行的闭包，主线程
///   - completionBackground: 计时时间到了之后执行的闭包，在后台线程
func delay(seconds: Double, completion: (()->())? = nil, completionBackground: (()->())? = nil) {
    
    let popTime: DispatchTime = DispatchTime.now() + Double(Int64(Double(NSEC_PER_SEC) * seconds)) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) { () -> Void in
        completion?()
    }
    
    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).asyncAfter(deadline: popTime) { () -> Void in
        completionBackground?()
    }
}

//MARK: 检测麦克风访问权限
func checkMicrophone() -> Bool {
    var grant: Bool = false
    AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
        grant = granted
    }
    return grant
}

//MARK: 获取当前的控制器
func getCurViewController() -> UIViewController {
    return (app.window?.rootViewController)!
}

///MARK: 获取当前保存的音频文件信息
func getSavedAudio() -> NSMutableDictionary {
    let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/audioRecord.data")
    if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) {
        return data as! NSMutableDictionary
    }
    
    return NSMutableDictionary.init()
}

///MARK: 保存音频文件信息
func saveAudio(data: RainbowRecodModel, key: String) {
    let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/audioRecord.data")
    var dataDict = NSKeyedUnarchiver.unarchiveObject(withFile: filePath)
    if dataDict == nil {
        dataDict = NSMutableDictionary.init()
    }
    
    if (dataDict as! NSMutableDictionary).count >= 1 {
        // 最后一个元素的key
        var lastKey: NSString? = nil
        var lastArr: NSMutableArray = NSMutableArray.init()
        for (index, item) in (dataDict as! NSMutableDictionary).enumerated() {
            if (index == (dataDict as! NSMutableDictionary).count - 1) {
                lastKey = (item.key as! NSString)
                lastArr = (item.value as! NSMutableArray)
            }
        }
        
        //  最后一个元素的key与现在要加的key比较
        let curSub: NSString = (key as NSString).substring(to: 10) as NSString
        // 相等则放在同一个数组里
        if (lastKey == curSub) {
            lastArr.add(data)
            (dataDict as! NSMutableDictionary).setObject(lastArr, forKey: lastKey!)
        } else {
            // 不相等则创建一个新的数组
            let newArr = NSMutableArray.init()
            newArr.add(data)
            (dataDict as! NSMutableDictionary).setObject(newArr, forKey: curSub as NSString)
        }
    }else {
        // 创建一个数组
        let curSub = (key as NSString).substring(to: 10)
        let newArr = NSMutableArray.init()
        newArr.add(data)
        (dataDict as! NSMutableDictionary).setObject(newArr, forKey: curSub as NSString)
    }
    
    NSKeyedArchiver.archiveRootObject(dataDict as Any, toFile: filePath)
}

///MARK: 删除音频信息
func deleteAudio(key: String) {
    let filePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!.appending("/audioRecord.data")
    let dataDict = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as! NSMutableDictionary
    print("删除前:",dataDict)
    // 最后一个元素
    var lastArr: NSMutableArray = NSMutableArray.init()
    for (index, item) in dataDict.enumerated() {
        if (index == dataDict.count - 1) {
            lastArr = (item.value as! NSMutableArray)
            // 删除该数组中最后的元素
            lastArr.removeLastObject()
            // 更新字典
            dataDict.setObject(lastArr, forKey: item.key as! NSString)
        }
    }
    print("删除后:",dataDict)
    NSKeyedArchiver.archiveRootObject(dataDict, toFile: filePath)
    
}

///MARK: 获取星期信息
func getWeekDay() -> Int {
    var timers: [Int] = [] // 返回的数组
    let calendar: Calendar = Calendar(identifier: .gregorian)
    var comps: DateComponents = DateComponents()
    comps = calendar.dateComponents([.year,.month,.day, .weekday, .hour, .minute,.second], from: Date())
    timers.append(comps.year! % 2000) // 年 ，后2位数
    timers.append(comps.month!) // 月
    timers.append(comps.day!) // 日
    timers.append(comps.hour!) // 小时
    timers.append(comps.minute!) // 分钟
    timers.append(comps.second!) // 秒
    timers.append(comps.weekday! - 1) //星期
    return timers[6]
}

