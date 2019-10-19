//
//  BaseViewController.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/28.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

let navigationBarTintColor = UIColor.white

class BaseViewController: UIViewController {
    
    /// 当前controller的index
    var controllerIndex: Int?
    
    /// 点击导航栏右按钮的闭包
    var tapRightBarButtonItem: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        navigationController?.interactivePopGestureRecognizer?.delegate = nil

        //开启手势返回
        navigationController?.navigationBar.barTintColor = mainNavigationBarTintColor()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = navigationBarTintColor
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK:------------------------------设置导航栏------------------------------------
    //MARK: 设置导航栏的背景色(默认蓝色)
    func setNavBackgroundColor() {
        self.navigationController?.navigationBar.barTintColor =
            appThemeColor()
    }
    //MARK: 设置导航栏标题
    /**
     设置导航栏的标题，默认白色
     - parameter title: 标题
     */
    func setNavigationTitle(_ title: String) {
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white] as [NSAttributedStringKey: Any]
    }
    
    //MARK:设置导航栏的attributeTitle
    /**
     设置导航栏的attributeTitle
     - parameter title:        标题
     - parameter attributeDic: attribute
     */
    func setNavigationAttributeTitle(_ title: String, attributeDic: [NSAttributedStringKey : Any]) {
        navigationItem.title = title
        navigationController?.navigationBar.titleTextAttributes = attributeDic
    }
    
    //MARK:根据图片设置导航栏左按钮
    /**
     根据图片设置导航栏左按钮
     
     - parameter imageName: 图片名字
     */
    func setNavigationBarLeftButtonWithImageName(_ imageName: String) {
        let button: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigationBarLeftBarButtonAction(_:)))
        navigationItem.leftBarButtonItem = button
    }
    
    //MARK: 从文字设置导航栏左按钮
    /**
     从文字设置导航栏左按钮
     
     - parameter title: title
     */
    func setNavigationBarLeftButtonWithTitle(_ title: String) {
        let button: UIBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigationBarLeftBarButtonAction(_:)))
        navigationItem.leftBarButtonItem = button
    }
    
    //MARK: 导航栏左按钮点击事件
    /**
     导航栏左按钮点击事件，默认返回上一页
     
     - parameter button:
     */
    @objc func navigationBarLeftBarButtonAction(_ button: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:从图片设置导航栏右按钮
    /**
     根据图片设置导航栏右按钮
     - parameter imageName: 图片名字
     */
    func setNavigationBarRightButtonWithImageName(_ imageName: String) {
        let button: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal), style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigationBarRightBarButtonAction(_:)))
        navigationItem.rightBarButtonItem = button
    }
    
    //MARK: 从文字设置导航栏右按钮
    /**
     从文字设置导航栏右按钮
     
     - parameter title: title
     */
    func setNavigationBarRightButtonWithTitle(_ title: String) {
        let button: UIBarButtonItem = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.plain, target: self, action: #selector(navigationBarRightBarButtonAction(_:)))
        navigationItem.rightBarButtonItem = button
    }
    
    //MARK: 导航栏右按钮点击事件
    /**
     导航栏右按钮点击事件
     
     - parameter button:
     */
    @objc func navigationBarRightBarButtonAction(_ button: UIBarButtonItem){
        self.tapRightBarButtonItem?()
    }
    
    //MARK: 导航栏透明
    /// 设置导航栏为透明
    func transparentNavigationBar() {
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            self?.edgesForExtendedLayout = []
            self?.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            self?.navigationController?.navigationBar.shadowImage = UIImage()
            self?.navigationController?.navigationBar.isTranslucent = true
            self?.navigationController?.view.backgroundColor = UIColor.clear
            self?.navigationController?.navigationBar.backgroundColor = UIColor.clear
            }, completion: nil)
    }
    
    //MARK: 取消导航栏透明
    func cancelTansparentNavigationBar() {
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            self?.navigationController?.navigationBar.barTintColor = UIColor.white
            self?.navigationController?.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
            self?.navigationController?.navigationBar.isTranslucent = false
            }, completion: { [weak self] (_) in
                self?.setNavBackgroundColor()
//                self?.navigationController?.navigationBar.tintColor = appThemeColor()
//                self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): appThemeColor()] as [NSAttributedStringKey: Any]
        })
    }
    
    //MARK:------------------------创建提示框-----------------------------
    //MARK: 创建提示框
    /**
     创建提示框
     - parameter title:      标题
     - parameter message:    信息
     - parameter leftTitle:  左按钮标题 默认 字符串 “OK” or “好的”
     - parameter rightTitle: 右按钮标题
     - parameter left:       左按钮点击事件
     - parameter right:      右按钮点击事件
     - parameter complition: 提示框弹出完成之后的闭包
     */
    func alert(alertTitle title: String?, messageString message: String? = nil, leftButtonTitle leftTitle: String = "好", rightButtonTitle rightTitle: String? = nil, leftClosure left: (()->())? = nil, rightClosure right: (()->())? = nil, presentComplition complition: (()->())? = nil) {
        
        let ac: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let leftAc: UIAlertAction = UIAlertAction(title: leftTitle, style: .cancel) { (_) in
            left?()
        }// 左按钮
        ac.addAction(leftAc)
        
        if (rightTitle != nil) {
            let rightAc: UIAlertAction = UIAlertAction(title: rightTitle, style: .default, handler: { (_) in
                right?()
            })// 右按钮
            ac.addAction(rightAc)
        }
        
        present(ac, animated: true) {
            complition?()
        }//提示框弹出结束后的事件
        
    }

    //MARK:----------------设置SVProgressHUD--------------------
    
    //MARK: 成功的弹窗
    /// 成功的弹窗
//    func successSVProgress(title: String?){
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.clear)
//        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
//        SVProgressHUD.showSuccess(withStatus: title)
//        delay(seconds: 1.0, completion: { [weak self] _ in
//            self?.dismissSVProgress()
//        })
//    }
    
    //MARK: 展示加载器
    /**
     展示加载器
     
     - parameter title:    加载器上的标题
     - parameter maskType: mask类型，默认为.Clear
     */
//    func showSVProgress(title: String?, andMaskType maskType :SVProgressHUDMaskType = .clear){
//        if title == nil {
//            SVProgressHUD.show()
//        }else{
//            SVProgressHUD.show(withStatus: NSLocalizedString(title!, comment: ""))
//        }
//        SVProgressHUD.setDefaultMaskType(maskType)
//        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
//    }
    
    //MARK: 进度条
    /// 进度条
    ///
    /// - Parameters:
    ///   - receiveSize: 已接受的数据
    ///   - targetSize: 需要接受的数据
    ///   - title: 标题。默认为空
//    func setSVProgress(receiveSize: Int, andTargetSize targetSize: Int, andTitle title: String? = nil){
//        SVProgressHUD.showProgress(Float(receiveSize / targetSize), status: title)
//    }
    
    //MARK: 隐藏加载指示器
    /**
     隐藏加载指示器
     */
    func dismissSVProgress() {
//        SVProgressHUD.dismiss()
//        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
    }
    

}

