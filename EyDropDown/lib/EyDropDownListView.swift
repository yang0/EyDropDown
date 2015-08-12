//
//  EyDropDownListView.swift
//  EyDropDown
//
//  Created by 杨凌 on 15/8/10.
//  Copyright (c) 2015年 杨凌. All rights reserved.
//

import UIKit


protocol EyDropDownChooseDelegate: NSObjectProtocol{
    func chooseAtSection(section: Int, index: Int)
}


protocol EyDropDownChooseDataSource: NSObjectProtocol{
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func titleInSection(section: Int, index:Int) -> String
    func defaultShowSection(section: Int) -> Int
}



class EyDropDownListView: UIControl, UITableViewDelegate, UITableViewDataSource {
    static let SECTION_BTN_TAG_BEGIN  = 1000
    static let SECTION_IV_TAG_BEGIN  =  3000
    
    var currentExtendSection:Int = -1

    var dropDownDelegate:EyDropDownChooseDelegate?
    var dropDownDataSource:EyDropDownChooseDataSource?
    
    var mSuperView:UIView?
    var mTableBaseView:UIView?
    var mTableView:UITableView?
    

    
    init(frame: CGRect, datasource:EyDropDownChooseDataSource, delegate:EyDropDownChooseDelegate){
        
        super.init(frame: frame)

        self.backgroundColor = UIColor.whiteColor()
        currentExtendSection = -1
        self.dropDownDataSource = datasource
        self.dropDownDelegate = delegate

        
        var sectionNum = self.dropDownDataSource!.numberOfSections()
        if sectionNum == 0{
            return
        }
        
        //支持一行里面可以放多个下拉列表
        var sectionWidth = frame.size.width / CGFloat(sectionNum)
        for i in 0...sectionNum-1{
            //初始选择框
            var sectionBtn = UIButton(frame: CGRectMake(sectionWidth*CGFloat(i), 1, sectionWidth, frame.size.height-2))
            sectionBtn.tag = EyDropDownListView.SECTION_BTN_TAG_BEGIN + i
            sectionBtn.addTarget(self, action: "sectionBtnTouch:", forControlEvents: UIControlEvents.TouchUpInside)
            
            var sectionBtnTitle = dropDownDataSource!.titleInSection(i, index: dropDownDataSource!.defaultShowSection(i))
            sectionBtn.setTitle(sectionBtnTitle, forState: UIControlState.Normal)
            sectionBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            sectionBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(14.0)
            self.addSubview(sectionBtn)
            
            //加上小三角
            var sectionBtnIv = UIImageView(frame: CGRectMake(sectionWidth*CGFloat(i)+(sectionWidth-16), (self.frame.height-12)/2, 12, 12))
            sectionBtnIv.image = UIImage(named:"down_dark.png")
            sectionBtnIv.contentMode = UIViewContentMode.ScaleToFill
            sectionBtnIv.tag = EyDropDownListView.SECTION_IV_TAG_BEGIN + i
            self.addSubview(sectionBtnIv)
            
            //如果有多个下拉列表，在选择框中间加竖线
            if i < sectionNum && i != 0{
                var lineView = UIView(frame: CGRectMake(sectionWidth*CGFloat(i), frame.size.height/4, 1, frame.size.height/2))
                lineView.backgroundColor = UIColor.lightGrayColor()
                self.addSubview(lineView)
            }
        }

    }


    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func DEGREES_TO_RADIANS(angle: Int) -> CGFloat{
        return CGFloat(Double(angle)/180.0 * M_PI)
    }


    func sectionBtnTouch(btn: UIButton){
        var section = btn.tag - EyDropDownListView.SECTION_BTN_TAG_BEGIN
        
        if currentExtendSection == section{
            self.hideExtendedChooseView()
        }else{
            currentExtendSection = section
            
            let currentIV = self.viewWithTag(EyDropDownListView.SECTION_IV_TAG_BEGIN + currentExtendSection)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                currentIV?.transform = CGAffineTransformRotate(currentIV!.transform, DEGREES_TO_RADIANS(180))
            })
            
            self.showChooseListViewInSection(currentExtendSection, choosedIndex: self.dropDownDataSource!.defaultShowSection(currentExtendSection))
        }
    }
    
    func showChooseListViewInSection(section:Int, choosedIndex index:Int){
        if mTableView == nil{
            self.mTableBaseView = UIView(frame: CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.mSuperView!.frame.width, self.mSuperView!.frame.size.height - self.frame.origin.y - self.frame.size.height))
            self.mTableBaseView?.backgroundColor = UIColor(white: 0, alpha: 0.2)
            
            let bgTap = UITapGestureRecognizer(target: self, action: "bgTappedAction:")
            mTableBaseView?.addGestureRecognizer(bgTap)
            
            self.mTableView = UITableView(frame: CGRectMake(self.frame.origin.x, self.frame.origin.y+self.frame.size.height, self.frame.size.width, 240), style: UITableViewStyle.Plain)
            mTableView!.delegate = self
            mTableView!.dataSource = self
        }
        
        //修改tableview的frame
        var sectionWidth = self.frame.size.width/CGFloat(self.dropDownDataSource!.numberOfSections())
        var rect = self.mTableView!.frame
        rect.origin.x = sectionWidth * CGFloat(section)
        rect.size.width = sectionWidth
        rect.size.height = 0
        self.mTableView!.frame = rect
        self.mSuperView!.addSubview(self.mTableBaseView!)
        self.mSuperView!.addSubview(self.mTableView!)
        
        
        //动画设置位置
        rect.size.height = 240
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            //self.mTableBaseView!.alpha = 0.2
            //self.mTableView!.alpha = 0.2
            
            self.mTableBaseView!.alpha = 1.0
            self.mTableView!.alpha = 1.0
            self.mTableView!.frame = rect
        })
        
        self.mTableView!.reloadData()
    }
    
    //隐藏下拉列表及背景
    func hideExtendedChooseView(){
        if currentExtendSection != -1{
            let currentIV = self.viewWithTag(EyDropDownListView.SECTION_IV_TAG_BEGIN + currentExtendSection)
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                currentIV!.transform = CGAffineTransformRotate(currentIV!.transform, self.DEGREES_TO_RADIANS(180))
            })
            
            currentExtendSection = -1
            var rect = self.mTableView!.frame
            rect.size.height = 0
            
            //消除
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.mTableBaseView!.alpha = 0.2
                self.mTableView!.alpha = 0.2
                self.mTableView!.frame = rect
            }, completion: { (Bool) -> Void in
                self.mTableView!.removeFromSuperview()
                self.mTableBaseView!.removeFromSuperview()
            })
        }
    }
    
    //点击下拉列表以外的区域，那么收拢下拉列表
    func bgTappedAction(tap: UITapGestureRecognizer){
        
        self.hideExtendedChooseView()
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if dropDownDelegate != nil{
            var chooseCellTitle = self.dropDownDataSource!.titleInSection(currentExtendSection, index: indexPath.row)
            
            var currentSectionBtn = self.viewWithTag(EyDropDownListView.SECTION_BTN_TAG_BEGIN + currentExtendSection) as! UIButton
            currentSectionBtn.setTitle(chooseCellTitle, forState: UIControlState.Normal)
            
            self.dropDownDelegate!.chooseAtSection(currentExtendSection, index: indexPath.row)
            self.hideExtendedChooseView()
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellIdentifier"
        var cell:UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil{
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        cell!.textLabel!.text = self.dropDownDataSource?.titleInSection(currentExtendSection, index: indexPath.row)
        cell!.textLabel!.font = UIFont.systemFontOfSize(14)
        
        return cell!
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dropDownDataSource!.numberOfRowsInSection(currentExtendSection)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }


}
