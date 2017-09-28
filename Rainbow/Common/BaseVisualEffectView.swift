//
//  BaseVisualEffectView.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/21.
//  Copyright © 2017年 ucard. All rights reserved.
//

import UIKit

class BaseVisualEffectView: UIVisualEffectView {

    /// 点击事件
    var tapClosure: (()->())?
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapVisualView(tap:)))
        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 没有任何效果的高斯模糊视图，初始化之后，用动画来添加模糊效果
    /// 没有任何效果的高斯模糊视图，初始化之后，用动画来添加模糊效果
    ///
    /// - Returns: BaseVisualEffectView
    class func noEffectVisualView() -> BaseVisualEffectView {
        let visualView: BaseVisualEffectView = BaseVisualEffectView(effect: nil)
        return visualView
    }
    
    //MARK: 白色的高斯模糊
    /// 白色的高斯模糊
    ///
    /// - Returns: BaseVisualEffectView
    class func lightVisualEffectView() -> BaseVisualEffectView {
        let effect: UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let visualView: BaseVisualEffectView = BaseVisualEffectView(effect: effect)
        return visualView
    }

    //MARK: 出现白色模糊的动画
    /// 出现白色模糊的动画
    func appearLightEffectAnimation() {
        if #available(iOS 10.0, *) {
            let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 1.0, curve: UIViewAnimationCurve.linear, animations: {[weak self] in
                self?.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            })
            animator.startAnimation()
        } else {
            self.effect = UIBlurEffect(style: UIBlurEffectStyle.light)
            self.alpha = 0
            UIView.animate(withDuration: 1.0, animations: { [weak self] in
                self?.alpha = 1
            })
        }
    }
    
    //MARK: 消失的动画
     func dismissAnimation() {
        if #available(iOS 10.0, *) {
            let animator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: UIViewAnimationCurve.linear, animations: {[weak self] in
                self?.effect = nil
            })
            animator.startAnimation()
            animator.addCompletion({ [weak self] (position: UIViewAnimatingPosition) in
                if position == UIViewAnimatingPosition.end{
                    self?.removeFromSuperview()
                    self = nil
                }
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: { [weak self] in
                self?.alpha = 0
            }, completion: { [weak self] (_) in
                self?.removeFromSuperview()
                self = nil
            })
        }
    }
    
    //MARK: 点击事件
    @objc func tapVisualView(tap: UITapGestureRecognizer) {
        tap.isEnabled = false//防止重复点击
        dismissAnimation()
        tapClosure?()
    }
}
