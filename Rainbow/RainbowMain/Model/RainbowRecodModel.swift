//
//  RainbowRecodModel.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/29.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

class RainbowRecodModel: NSObject,NSCoding {
    
    var filePath : NSString!
    var date     : NSString!
    var audioName: NSString!
    var weekday  : NSString!
    
    // 用字典初始化模型
    init(dict: [String:AnyObject]) {
        super.init()
        self.audioName = dict["audioName"] as! NSString
        self.date = dict["date"] as! NSString
        self.filePath = dict["filePath"] as! NSString
        self.weekday = dict["weekday"] as! NSString
    }
    
    //MARK: NACODING协议
    //将对象写入到文件中
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.filePath, forKey: "filePath")
        aCoder.encode(self.date, forKey: "date")
        aCoder.encode(self.audioName, forKey: "audioName")
        aCoder.encode(self.weekday, forKey: "weekday")
    }
    
    // 从文件中读取对象
    required init(coder aDecoder: NSCoder) {
        super.init()
        self.filePath = aDecoder.decodeObject(forKey: "filePath") as! NSString!
        self.date = aDecoder.decodeObject(forKey: "date") as! NSString!
        self.audioName = aDecoder.decodeObject(forKey: "audioName") as! NSString!
        self.weekday = aDecoder.decodeObject(forKey: "weekday") as! NSString!
    }

}
