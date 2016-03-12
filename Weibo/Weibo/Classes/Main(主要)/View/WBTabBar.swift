//
//  WBTabBar.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/20.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit
protocol WBTabBarDelegate:UITabBarDelegate{
    func tabBarDidClickPlusButton(tabBar:WBTabBar)
}
class WBTabBar: UITabBar {
    var WBdelegate:WBTabBarDelegate?
    
    let plusBtn : UIButton = {
        let plusBtn = UIButton()
        plusBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button"), forState: UIControlState.Normal)
        plusBtn.setBackgroundImage(UIImage(named: "tabbar_compose_button_highlighted"), forState: UIControlState.Highlighted)
        plusBtn.setImage(UIImage(named: "tabbar_compose_icon_add"), forState: UIControlState.Normal)
        plusBtn.setImage(UIImage(named: "tabbar_compose_icon_add_highlighted"), forState: UIControlState.Highlighted)
        plusBtn.frame.size = plusBtn.currentBackgroundImage!.size
        return plusBtn
    }()
    
    init() {
        super.init(frame: CGRectZero)
        plusBtn.addTarget(self, action: "plusClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(plusBtn)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        // 1.设置加号按钮的位置
        self.plusBtn.center.x = self.frame.width * 0.5
        self.plusBtn.center.y = self.frame.height * 0.5
        
        // 2.设置其他tabbarButton的位置和尺寸
        let tabbarButtonW = self.frame.width / 5
        
        var tabbarButtonIndex = 0
        self.subviews.forEach { (child) -> () in
            if  child.isKindOfClass(
                NSClassFromString("UITabBarButton")!) {
                // 设置宽度
                child.frame.size.width = tabbarButtonW
                // 设置x
                child.center.x = CGFloat(tabbarButtonIndex) * tabbarButtonW + tabbarButtonW / 2
                // 增加索引
                tabbarButtonIndex++
                
                if (tabbarButtonIndex == 2) {
                    tabbarButtonIndex++
                }
            }
            
        }
       
        
    }
    func plusClick(){
        WBdelegate?.tabBarDidClickPlusButton(self)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
