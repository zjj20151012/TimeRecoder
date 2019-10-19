//
//  RainbowListModel.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/29.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

class RainbowListModel: NSObject {
    
    var colorArr : [UIColor] = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green,
                    UIColor.blue, UIColor.cyan, UIColor.purple]
    var color    : UIColor!
    
    init(index: NSInteger) {
        super.init()
        // 分别对应周日-周六
        self.color = self.colorArr[index]
    }
}
