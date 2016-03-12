//
//  WBSearchBar.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/20.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBSearchBar: UITextField {
   
    init() {
        
        super.init(frame: CGRectZero)
        
        self.font = UIFont.systemFontOfSize(15)
        self.placeholder = "请输入搜索条件"
        self.backgroundColor = UIColor.whiteColor()
        self.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.layer.borderWidth = 1
        
        // 通过init来创建初始化绝大部分控件，控件都是没有尺寸
        let searchIcon = UIImageView()
        searchIcon.image = UIImage(named: "searchbar_textfield_search_icon")
        searchIcon.frame.size = CGSize(width: 30, height: 30)
        searchIcon.contentMode = UIViewContentMode.Center
        self.leftView = searchIcon
        self.leftViewMode = UITextFieldViewMode.Always
        
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
