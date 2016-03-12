//
//  WBTitleButton.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/25.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBTitleButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //让图片居中，不拉伸
        self.imageView?.contentMode = UIViewContentMode.Center
        
        self.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
        self.setImage(UIImage(named: "navigationbar_arrow_down"), forState: UIControlState.Normal)
        self.setImage(UIImage(named: "navigationbar_arrow_up"), forState: UIControlState.Selected)
        
    }
    override func setTitle(title: String?, forState state: UIControlState) {
        super.setTitle(title, forState: state)
        // 只要修改了文字，就让按钮重新计算自己的尺寸
        self.sizeToFit()
    }
    override func setImage(image: UIImage?, forState state: UIControlState) {
        super.setImage(image, forState: state)
        // 只要修改了图片，就让按钮重新计算自己的尺寸
        self.sizeToFit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
        
        // 1.计算titleLabel的frame
        self.titleLabel!.frame.origin.x = self.imageView!.frame.origin.x
        
        // 2.计算imageView的frame
        self.imageView!.frame.origin.x = CGRectGetMaxX(self.titleLabel!.frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
