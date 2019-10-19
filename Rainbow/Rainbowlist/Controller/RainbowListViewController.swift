//
//  RainbowListViewController.swift
//  Rainbow
//
//  Created by 朱佳杰 on 2017/9/28.
//  Copyright © 2017年 corp-ci. All rights reserved.
//

import UIKit

class RainbowListViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let cellIdentify = "RainbowListCell"
    
    @IBOutlet weak var rainbowRecordList: UITableView!
    
    var dataDict: NSDictionary   = NSMutableDictionary.init()
    var dataArr : NSMutableArray = NSMutableArray.init()
    var keyArr  : NSMutableArray = NSMutableArray.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setData()
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: 设置导航栏
    fileprivate func setNavigation() {
        setNavigationTitle("我的语音日记")
    }
    
    //MARK: 设置UI
    func setUI() {
        self.rainbowRecordList.delegate = self
        self.rainbowRecordList.dataSource = self
        self.rainbowRecordList.backgroundView = UIImageView.init(image: UIImage.init(named: "rainbow_list"))
    }
    
    //MARK: 数据的处理
    func setData() {
        let data = getSavedAudio() as NSMutableDictionary
        if data.count == 0 {
            let alert = UIAlertController.init(title: "提示", message: "您还没有录制过任何语音日记,请先录制", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction.init(title: "好", style: UIAlertActionStyle.default, handler: { (nil) in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.dataDict = data
            for (key, value) in self.dataDict {
                self.dataArr.add(value)
                self.keyArr.add(key)
            }
            print(dataDict)
            print("dataArr:", dataArr)
            print("keyArr:", keyArr)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    class func getRainbowListVC() -> RainbowListViewController {
        let sb: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        return sb.instantiateViewController(withIdentifier: "RainbowListViewController") as! RainbowListViewController
    }
    
    //MARK: tableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array: NSArray = self.dataArr[section] as! NSArray
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RainbowListCell = RainbowListCell.initRainbowListCell(tableView: self.rainbowRecordList, identify: RainbowListViewController.cellIdentify) as! RainbowListCell
        cell.backgroundColor = UIColor.clear
        let array: NSArray = dataArr[indexPath.section] as! NSArray
        if playIndex == nil || playIndex != indexPath {
            cell.bgView.backgroundColor = UIColor.white
        } else {
            let array: NSArray = self.dataArr[playIndex.section] as! NSArray
            let model: RainbowRecodModel = array[playIndex.row] as! RainbowRecodModel
            let listModel:RainbowListModel = RainbowListModel.init(index: model.weekday.integerValue)
            cell.bgView.backgroundColor = listModel.color
        }
        cell.assignData(data: array[indexPath.row] as! RainbowRecodModel, playInfo: dataArr)
        return cell
    }
    
    //MARK: tableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel.init()
        label.text = (keyArr[section] as! String) + "日的语音日记"
        label.backgroundColor = UIColor.white
        label.textColor = appThemeColor()
        label.textAlignment = NSTextAlignment.center
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataDict.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonRecordManager.sharedManager.pause()
    }
    
}
