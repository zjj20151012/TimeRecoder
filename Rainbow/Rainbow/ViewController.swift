//
//  ViewController.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/27.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var rainbowView: RainbowView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //创建彩虹动画圆环
        let frame = CGRect(x:50, y:80, width:160, height:160)
        rainbowView = RainbowView(frame:frame)
        self.view.addSubview(rainbowView!)
        
//        rainbowView = RainbowView()
//        rainbowView?.frame = CGRect.init(x: 20, y: 20, width: 100, height: 100)
//        rainbowView?.creatRainbow()
//        self.view.addSubview(rainbowView!)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

