//
//  UIViewExtension.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/29.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

extension UIView {
    //MARK: 返回该view所在的父view
    func superView<view: UIView>(of: view.Type) -> view? {
        for view in sequence(first: self.superview, next: { $0?.superview }) {
            if let father = view as? view {
                return father
            }
        }
        return nil
    }
}

