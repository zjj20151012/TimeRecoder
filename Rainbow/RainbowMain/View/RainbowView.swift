//
//  RainbowView.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/27.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

class RainbowView: UIView, CAAnimationDelegate {
    
    // 动画滚动的时长
    let duration = 0.1
    
    // 渐变层
    var gradientLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        // 创建彩虹渐变层
        gradientLayer =  CAGradientLayer()
        gradientLayer.frame = self.bounds
        
        // 录音的时候动画从下往上
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
        
        // 设置渐变层的颜色
        var rainbowColorArr:[CGColor] = []
        var hue:CGFloat = 0
        
        while hue <= 360 {
            
            let color = UIColor(hue: 1.0 * hue / 360.0, saturation: 1.0, brightness: 1.0, alpha: 1.0)
            rainbowColorArr.append(color.cgColor)
            hue += 5
            
        }
        
        gradientLayer.colors = rainbowColorArr
        
        // 添加渐变层
        self.layer.addSublayer(gradientLayer)
        
        let maskImage = UIImageView.init()
        maskImage.frame = self.bounds
        maskImage.image = UIImage.init(named: "rainbow_word")
        maskImage.alpha = 0.5
        self.addSubview(maskImage)
    
        // 开始播放动画
        performRecord()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        // 继续播放动画
        performRecord()
    }
    
    // 录制音频时执行的动画
    func performRecord() {
        
        // 更新渐变层的颜色
        let fromColors = gradientLayer.colors as! [CGColor]
        let toColors = self.shiftColors(colors: fromColors)
        gradientLayer.colors = toColors
        // 创建动画实现渐变颜色从下向上移动的效果
        let animation = CABasicAnimation(keyPath: "recordAnimation")
        animation.duration = duration
        animation.fromValue = fromColors
        animation.toValue = toColors
        // 动画完成后是否要移除
        animation.isRemovedOnCompletion = true
        animation.fillMode = kCAFillModeForwards
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.delegate = self
        // 将动画添加到图层中
        gradientLayer.add(animation, forKey: "recordAnimation")
    }
    
    // 将颜色数组中的最后一个元素移到数组的最前面
    func shiftColors(colors: [CGColor]) -> [CGColor] {
        
        // 复制一个数组
        var newColors: [CGColor] = colors.map{($0.copy()!) }
        // 获取最后一个元素
        let last: CGColor = newColors.last!
        // 将最后一个元素删除
        newColors.removeLast()
        // 将最后一个元素插入到头部
        newColors.insert(last, at: 0)
        // 返回新的颜色数组
        return newColors
    }
    
}
