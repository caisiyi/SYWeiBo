//
//  UIBarButtonItem+Extension.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/19.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(target:AnyObject,action:Selector,image:String,highImage:String) {
        self.init()
        let btn = UIButton(type: UIButtonType.Custom)
        btn.addTarget(target,action: action,forControlEvents: UIControlEvents.TouchUpInside)
        // 设置图片
        btn.setBackgroundImage(UIImage(named:image), forState: UIControlState.Normal)
        btn.setBackgroundImage(UIImage(named:highImage), forState: UIControlState.Highlighted)
        // 设置尺寸
        btn.frame.size = btn.currentBackgroundImage!.size
        self.customView = btn
    }
}
