//
//  RainbowViewController.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/28.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit
import AVFoundation

class RainbowViewController: BaseViewController {

    @IBOutlet weak var recordView: UIView!
    
    @IBOutlet weak var tipLabel: UILabel!
    
    /// 高斯模糊视图
    fileprivate var visualView: BaseVisualEffectView?
    
    /// 用于计时的Timer
    fileprivate var recidTimer: Timer?
    
    /// 当前录音时长
    fileprivate var curTime: Int = 0
    
    /// 录音的动效
    fileprivate var rainbowView: RainbowView?
    
    /// 音频Manager
    fileprivate let audioManager: CommonRecordManager? = nil
    
    /// 录制完音频后的播放按钮
    fileprivate var playBtn: UIButton? = nil
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        // 检测麦克风访问权限
        _ =  checkMicrophone()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 设置导航栏透明
        transparentNavigationBar()
        setNavBackgroundColor()
        setUI()
        playIndex = nil
    }
    
    //MARK: 设置导航栏
    fileprivate func setNavigation() {
        setNavigationTitle("Rainbow")
        setNavigationBarRightButtonWithTitle("历史日志")
        tapRightBarButtonItem = { [weak self] in
            self?.cancelTansparentNavigationBar()
            self?.navigationController?.pushViewController(RainbowListViewController.getRainbowListVC(), animated: true)
        }
    }
    
    //MARK: 设置UI
    fileprivate func setUI() {
        // 因为就一个按钮设置圆角所以就用这种方式设置了
        self.recordView.layer.masksToBounds = true;
        self.recordView.layer.cornerRadius = 20.0
        // 长按的手势
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(startRecord(pressGesture:)))
        longPressGesture.allowableMovement = 20.0
        longPressGesture.minimumPressDuration = 0.5
        self.recordView.addGestureRecognizer(longPressGesture)
        // 播放按钮
    }
    
    //MARK: 设置播放按钮
    fileprivate func showOrHidePlayBtn(hide: Bool) {
        if (playBtn == nil) {
            playBtn = UIButton.init(frame: CGRect.init(x: (self.view.frame.size.width - 100)/2, y: (self.view.frame.size.height - 100 - 64) / 2, width: 100, height: 100))
            playBtn?.setImage(UIImage.init(named: "rainbow_play"), for: UIControlState.normal)
            playBtn?.alpha = 0.0
            playBtn?.isHidden = true
            playBtn?.addTarget(self, action: #selector(onPlay), for: UIControlEvents.touchUpInside)
        }
        playBtn?.alpha = hide ? 0.0 : 1.0
        playBtn?.isHidden = hide
        if hide {
            CommonRecordManager.sharedManager.stop()
            self.playBtn?.removeFromSuperview()
            self.playBtn = nil
        } else {
            self.view.addSubview(playBtn!)
            self.view.bringSubview(toFront: playBtn!)
        }
    }
    
    //MARK: 设置高斯模糊视图
    fileprivate func setVisualView(){
        visualView = BaseVisualEffectView.noEffectVisualView()
        view.insertSubview(visualView!, belowSubview: self.recordView)
        visualView?.frame = view.bounds
        visualView?.appearLightEffectAnimation()
        cancelTansparentNavigationBar()
    }
    
    //MARK: 点击播放按钮
    @objc func onPlay() {
        CommonRecordManager.sharedManager.play(path: "")
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.toValue = Double(4) * Double.pi
        animation.duration = 1
        animation.repeatCount = 1
        animation.isRemovedOnCompletion = true
        UIView.animate(withDuration: Double(CommonRecordManager.sharedManager.totalLength!)) {
            self.playBtn?.transform = (self.playBtn?.transform.rotated(by: CGFloat(Double.pi)))!
        }
    }
    
    //MARK: 手势识别(长按1s开始录音)
    @objc func startRecord(pressGesture: UILongPressGestureRecognizer) {
        
        // 开始录制
        if (pressGesture.state == UIGestureRecognizerState.began) {
            // 如果当前正在播放音频先取消播放
            showOrHidePlayBtn(hide: true)
            // 开启了权限的情况
            if (checkMicrophone()) {
                // 开启录音计时器
                timerStart()
                // 设置高斯模糊
                self.setVisualView()
                CommonRecordManager.sharedManager.beginRecord()
                // 加载录音动画
                if (rainbowView == nil) {
                    rainbowView = RainbowView(frame: CGRect.init(x: 10, y: (self.view.frame.size.height - 150 - 64) / 2, width: self.view.frame.size.width - 20, height: 150))
                    self.view.addSubview(rainbowView!)
                    self.view.bringSubview(toFront: rainbowView!)
                    rainbowView?.isHidden = true
                    rainbowView?.alpha = 0.0
                }
                UIView.animate(withDuration: 2.0, animations: { [weak self] in
                    self?.rainbowView?.isHidden = false
                    self?.rainbowView?.alpha = 1.0
                })
            } else {
                alert(alertTitle: "提示", messageString: "您还没有打开麦克风访问权限", leftButtonTitle: "就是不想打开", rightButtonTitle: "现在去打开",
                   leftClosure: {},
                   rightClosure: {
                    // 不延时跳转设置界面会报错
                    delay(seconds: 0.3, completion: {
                         UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
                    }, completionBackground: nil)
                   },
                   presentComplition: nil)
            }
        }

        // 结束录制
        if (pressGesture.state == UIGestureRecognizerState.ended) {
            // 取消高斯模糊
            visualView?.dismissAnimation()
            // 设置导航栏透明
            transparentNavigationBar()
            // 结束录音
            CommonRecordManager.sharedManager.stopRecord()
            // 移除录音动画
            UIView.animate(withDuration: 1.0, animations: { [weak self] in
                self?.rainbowView?.alpha = 0.0
                self?.rainbowView?.isHidden = true
                self?.rainbowView?.removeFromSuperview()
                self?.rainbowView = nil
            })
            // 判断录制时间如果时间不足1s删除已经录制的文件
            if (curTime - 1 <= 1) {
                CommonRecordManager.sharedManager.deleteCurFile()
                let alert: UIAlertController = UIAlertController.init(title: "提示", message: "录制的语音日志时间必须超过1s,请重新录制", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction.init(title: "好", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else {
                delay(seconds: 0.5, completion: {
                    self.showOrHidePlayBtn(hide: false)
                }, completionBackground: nil)
            }
            // 暂停录音计时
            timerPause()
            self.tipLabel.text = "记 录 日 志"
        }
    }
    
    //MARK: 启动计时器
    func timerStart() {
        if (recidTimer == nil) {
            recidTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimer), userInfo: nil, repeats: true)
        }
    }
    
    @objc func onTimer() {
        self.tipLabel.text = "已录制" + " " + "\(curTime)" + " " + "S"
        self.curTime += 1
    }
    
    func timerPause() {
        curTime = 0
        recidTimer?.invalidate()
        recidTimer = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
