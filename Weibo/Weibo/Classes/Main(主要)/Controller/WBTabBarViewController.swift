//
//  WBTabBarViewController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/19.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBTabBarViewController: UITabBarController,WBTabBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化子控制器
        let home = HomeViewController()
        self.addChildVc(home, title: "首页", image: "tabbar_home", selectedImage: "tabbar_home_selected")
        
        let message = MessageViewController()
        self.addChildVc(message, title: "消息", image: "tabbar_message_center", selectedImage: "tabbar_message_center_selected")
        
        let discover = DiscoverViewController()
        self.addChildVc(discover, title: "发现", image: "tabbar_discover", selectedImage: "tabbar_discover_selected")
        
        let profile = ProfileViewController()
        self.addChildVc(profile, title: "我", image: "tabbar_profile", selectedImage: "tabbar_profile_selected")
        
        // 更换系统自带的tabbar
        let tabBar = WBTabBar()
        tabBar.WBdelegate = self
        //tabBar.delegate = self;
        self.setValue(tabBar, forKey: "tabBar")
        
        

        // 设置计时器,每60秒获得未读数
        let timer = NSTimer(timeInterval: 10, target: self, selector: "setupUnreadCount", userInfo: nil, repeats: true)
        // 主线程也会抽时间处理一下timer（不管主线程是否正在其他事件
        NSRunLoop.mainRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        // Do any additional setup after loading the view.
    }
    func setupUnreadCount(){
        WBNetworkTool.shareNetworkTool.loadUnreadCount { (result, error) -> () in
            if result != nil {
                let count = result!["status"] as! Int
                //拿到首页对应的tabBarItems
                let HomeTabBarItem = self.tabBar.items!.first!
                if count == 0 {
                HomeTabBarItem.badgeValue = nil
                UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                }else{
                HomeTabBarItem.badgeValue = "\(count)"
                UIApplication.sharedApplication().applicationIconBadgeNumber = count
                }
            }
        }
    }
   
    func tabBarDidClickPlusButton(tabBar: WBTabBar) {
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.redColor()
        self.presentViewController(vc, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     *  添加一个子控制器
     *
     *  @param childVc       子控制器
     *  @param title         标题
     *  @param image         图片
     *  @param selectedImage 选中的图片
     */
    func addChildVc(childVc:UIViewController,title:String,image:String,selectedImage:String){
        
        // 设置子控制器的文字
        childVc.title = title // 同时设置tabbar和navigationBar的文字
        //    childVc.tabBarItem.title = title // 设置tabbar的文字
        //    childVc.navigationItem.title = title // 设置navigationBar的文字
        
        // 设置子控制器图片
        childVc.tabBarItem.image = UIImage(named: image)
        childVc.tabBarItem.selectedImage = UIImage(named: selectedImage)?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        // 设置文字的样式
        let textAttrs = [NSForegroundColorAttributeName:WBColor(red: 123, green: 123, blue: 123)]
        let selectTextAttrs = [NSForegroundColorAttributeName:UIColor.orangeColor()]
        
        childVc.tabBarItem.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal)
        childVc.tabBarItem.setTitleTextAttributes(selectTextAttrs, forState: UIControlState.Selected)
        
        childVc.view.backgroundColor = UIColor.whiteColor()
        
        // 先给外面传进来的小控制器 包装 一个导航控制器
        let nav = WBNavigationController(rootViewController: childVc)
         // 添加为子控制器
        self.addChildViewController(nav)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
