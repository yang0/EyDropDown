//
//  ViewController.swift
//  EyDropDown
//
//  Created by 杨凌 on 15/8/10.
//  Copyright (c) 2015年 杨凌. All rights reserved.
//

import UIKit

class ViewController: UIViewController, EyDropDownChooseDelegate, EyDropDownChooseDataSource {
    
    let chooseArray = [["浙江", "乌鲁木齐", "北京", "上海"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "下拉列表演示"
        var dropDownView = EyDropDownListView(frame: CGRectMake(0, 60, self.view.frame.size.width/2, 40), datasource: self, delegate: self)
        dropDownView.mSuperView = self.view
        
        self.view.addSubview(dropDownView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func chooseAtSection(section: Int, index: Int) {
        NSLog("选择了section:%d, index:%d", section, index)
    }
    
    func numberOfSections() -> Int {
        return chooseArray.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        var array = chooseArray[section]
        return array.count
    }
    
    func titleInSection(section: Int, index: Int) -> String {
        return chooseArray[section][index]
    }
    
    func defaultShowSection(section: Int) -> Int {
        return 0
    }


}

