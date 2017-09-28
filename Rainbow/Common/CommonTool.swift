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


