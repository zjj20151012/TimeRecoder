//
//  RainbowViewController.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/28.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

class RainbowViewController: BaseViewController, UIGestureRecognizerDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 设置导航栏透明
        transparentNavigationBar()
        setUI()
    }
    
    func setNavigation() {
        setNavigationTitle("Rainbow")
        setNavigationBarRightButtonWithTitle("历史日志")
        tapRightBarButtonItem = { [weak self] in
            self?.navigationController?.pushViewController(RainbowListViewController.getRainbowListVC(), animated: true)
        }
    }
    
    //MARK: 设置UI
    fileprivate func setUI() {
        // 因为就一个按钮设置圆角所以就用这种方式设置了
        self.recordView.layer.masksToBounds = true;
        self.recordView.layer.cornerRadius = 20.0
        let longPressGesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(startRecord(pressGesture:)))
        longPressGesture.allowableMovement = 20.0
        self.recordView.addGestureRecognizer(longPressGesture)
    }
    
    //MARK: 设置高斯模糊视图
    fileprivate func setVisualView(){
        
        visualView = BaseVisualEffectView.noEffectVisualView()
        view.insertSubview(visualView!, belowSubview: self.recordView)
        visualView?.frame = view.bounds
        visualView?.appearLightEffectAnimation()
        cancelTansparentNavigationBar()
        
        //MARK: 点击高斯模糊视图，隐藏个人视图
        
    }
    
    @objc func startRecord(pressGesture: UILongPressGestureRecognizer) {
        // 开始录制
        if (pressGesture.state == UIGestureRecognizerState.began) {
            print("1")
            self.setVisualView()
            timerStart()
            rainbowView = RainbowView(frame: CGRect.init(x: 10, y: (self.view.frame.size.height - 150) / 2, width: self.view.frame.size.width - 20, height: 150))
            self.view.addSubview(rainbowView!)
            self.view.bringSubview(toFront: rainbowView!)
        }

        // 结束录制
        if (pressGesture.state == UIGestureRecognizerState.ended) {
            
            print("UIGestureRecognizerStateEnded");
            visualView?.dismissAnimation()
            transparentNavigationBar()
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
        curTime += 1
    }
    
    
    func timerPause() {
        curTime = 0
        recidTimer?.invalidate()
        recidTimer = nil
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
