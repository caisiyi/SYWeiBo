//
//  WBNavigationController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/19.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        
        // 设置整个项目所有item的主题样式
        let item = UIBarButtonItem.appearance()
        
        // 设置普通状态
        // key：NS****AttributeName
        let textAttrs = [NSForegroundColorAttributeName:UIColor.orangeColor(),NSFontAttributeName:UIFont.systemFontOfSize(13)]
        item.setTitleTextAttributes(textAttrs, forState: UIControlState.Normal)
        // 设置不可用状态
        let disableTextAttrs = [NSForegroundColorAttributeName:UIColor(red: 0.6, green: 0.6, blue: 0.6,alpha: 0.7),NSFontAttributeName:UIFont.systemFontOfSize(13)]
        item.setTitleTextAttributes(disableTextAttrs, forState: UIControlState.Disabled)

        
        
    }
    /**
    *  显示最新微博的数量
    *
    *  @param count 最新微博的数量
    */
    func showNewStatusCount(count:Int){
        // 1.创建label
        let label = UILabel()
        label.backgroundColor = UIColor(patternImage: UIImage(named: "timeline_new_status_background")!)
        label.frame.size = CGSize(width: UIScreen.mainScreen().bounds.size.width, height: 35)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont.systemFontOfSize(16)
        // 2.设置不同count的文本
        if count == 0 {
            label.text = "当前没有新的微博"
        }else{
            label.text = "共更新\(count)条微博"
        }
        // 3.添加
        label.frame.origin.y = 64 - label.frame.height
        // 将label添加到导航控制器的view中，并且是盖在导航栏下边
        view.insertSubview(label, belowSubview: navigationBar)
        // 4.动画
        // 如果某个动画执行完毕后，又要回到动画执行前的状态，建议使用transform来做动画
        // 先利用1s的时间，让label往下移动一段距离
        let duration = 1.0
        UIView.animateWithDuration(duration, animations: { () -> Void in
            label.transform = CGAffineTransformMakeTranslation(0, label.frame.height)
            }) { (_) -> Void in
            // 延迟1s后，再利用1s的时间，让label往上移动一段距离（回到一开始的状态
              let delay = 1.0
                UIView.animateKeyframesWithDuration(duration, delay: delay, options: UIViewKeyframeAnimationOptions.CalculationModeLinear, animations: { () -> Void in
                    label.transform = CGAffineTransformIdentity
                    }, completion: { (_) -> Void in
                        label.removeFromSuperview()
                })
        }
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
     *  重写这个方法目的：能够拦截所有push进来的控制器
     *
     *  @param viewController 即将push进来的控制器
     */
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {// 这时push进来的控制器viewController，不是第一个子控制器（不是根控制器）
            /* 自动显示和隐藏tabbar */
            viewController.hidesBottomBarWhenPushed = true
            
            /* 设置导航栏上面的内容 */
            
            let backBtn = UIButton(type: UIButtonType.Custom)
            backBtn.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
            // 设置图片
            backBtn.setBackgroundImage(UIImage(named: "navigationbar_back"), forState: UIControlState.Normal)
            backBtn.setBackgroundImage(UIImage(named: "navigationbar_back_highlighted"), forState: UIControlState.Highlighted)
            // 设置尺寸
            backBtn.frame.size = backBtn.currentBackgroundImage!.size
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backBtn)
            
    
            let moreBtn = UIButton(type: UIButtonType.Custom)
            moreBtn.addTarget(self, action: "more", forControlEvents: UIControlEvents.TouchUpInside)
            // 设置图片
            moreBtn.setBackgroundImage(UIImage(named: "navigationbar_more"), forState: UIControlState.Normal)
            moreBtn.setBackgroundImage(UIImage(named: "navigationbar_more_highlighted"), forState: UIControlState.Highlighted)
            // 设置尺寸
            moreBtn.frame.size = moreBtn.currentBackgroundImage!.size
            
            viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: moreBtn)

        }
        super.pushViewController(viewController, animated: animated)
    }
    func back(){
        self.popViewControllerAnimated(true)
    }
    func more(){
        self.popToRootViewControllerAnimated(true)
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
