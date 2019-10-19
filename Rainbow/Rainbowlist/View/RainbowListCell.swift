//
//  RainbowListCell.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/28.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

var playIndex: IndexPath!

class RainbowListCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var bgView: UIView!

    var playInfoArr: NSArray!
    
    static var curIndex: IndexPath!
    
    class func initRainbowListCell(tableView: UITableView, identify: String) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: identify)
        if (cell == nil) {
            cell = Bundle.main.loadNibNamed("RainbowListCell", owner: self, options: nil)?.last as? UITableViewCell
        }
        return cell!
    }
    
    public func assignData (data: RainbowRecodModel, playInfo: NSArray) {
        print(data)
        self.nameLabel.text = (data.audioName as NSString).substring(to: 17) + "的日记"
        self.playInfoArr = playInfo
        self.bgView.alpha = 0.5
        self.playBtn.addTarget(self, action: #selector(onPlay(sender:)), for: UIControlEvents.touchUpInside)
    }

    @objc func onPlay(sender: UIButton) {
        let cell = sender.superView(of: RainbowListCell.self)!
        let tableView: UITableView = cell.superview as! UITableView
        let indexPath = tableView.indexPath(for: cell)
        let array: NSArray = self.playInfoArr[(indexPath?.section)!] as! NSArray
        let model: RainbowRecodModel = array[(indexPath?.row)!] as! RainbowRecodModel
        let filePath: NSString = model.filePath
        let listModel:RainbowListModel = RainbowListModel.init(index: model.weekday.integerValue)
        print(model.weekday)
        
        playIndex = indexPath!
        
        tableView.reloadData()
//        // 刷新播放状态
//        delay(seconds: 0.5, completion: {
//            cell.bgView.backgroundColor = listModel.color
//            tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.automatic)
//        }) {
//            DispatchQueue.main.sync {
//                cell.bgView.backgroundColor = listModel.color
//                tableView.reloadData()
//            }
//        }
       
        print("index:",indexPath as Any)
        print("cur:",RainbowListCell.curIndex as Any)
        
        // 如果两次IndexPath相等则说明需要继续播放
        if (RainbowListCell.curIndex == nil) {
            CommonRecordManager.sharedManager.play(path: filePath as String)
        } else if (RainbowListCell.curIndex.section == indexPath?.section && RainbowListCell.curIndex.row == indexPath?.row) {
            if CommonRecordManager.sharedManager.checkState() {
                let alert = UIAlertController.init(title: "提示", message: "当前语音日记正在播放中", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction.init(title: "好", style: UIAlertActionStyle.default, handler: nil))
                getCurViewController().present(alert, animated: true, completion: nil)
            } else {
                CommonRecordManager.sharedManager.resume()
            }
        } else {
//            cell.bgView.backgroundColor = listModel.color
//            // 刷新播放状态
//            tableView.reloadRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
//            let lastCell: RainbowListCell = tableView.cellForRow(at: RainbowListCell.curIndex) as! RainbowListCell
//            lastCell.bgView.backgroundColor = UIColor.white
//            tableView.reloadRows(at: [RainbowListCell.curIndex], with: UITableViewRowAnimation.fade)
            CommonRecordManager.sharedManager.play(path: filePath as String)
        }
        RainbowListCell.curIndex = indexPath! as IndexPath
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
