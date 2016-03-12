//
//  NewfeatureViewController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/21.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit


import UIKit

class NewfeatureViewController: UIViewController,UIScrollViewDelegate
{
    var pageControl = UIPageControl()
    var scrollView  = UIScrollView()
    //跳过按钮
    var skipButton = UIButton()
    override func viewDidLoad()
    {
        
        self.navigationController?.navigationBarHidden = true
        super.viewDidLoad()
        //1.创建一个scrollView显示欢迎页
        scrollView.frame = self.view.bounds
        self.view.addSubview(scrollView)
        //2.添加图片到scrollView
        let width = self.view.frame.width
        let height = self.view.frame.height
        for var i = 0; i < (Int)(4) ; i++
        {
            let imageName:String = String(format: "new_feature_%d",i+1)
            let image:UIImage = UIImage(named: imageName)!
            let imageView = UIImageView(frame:CGRectMake(0, 0, width, height))
            imageView.frame = self.view.frame
            imageView.image = image
            var frame:CGRect = imageView.frame
            frame.origin.x = CGFloat(i) * frame.size.width
            imageView.frame = frame
            scrollView.addSubview(imageView)
            // 如果是最后一个imageView，就往里面添加其他内容
            if (i == 3) {
                self.setupLastImageView(imageView)
            }
        }
        //3.配置scrollView
        // 如果想要某个方向上不能滚动，那么这个方向对应的尺寸数值传0即可
        scrollView.contentSize = CGSizeMake(4 * width, 0)
        scrollView.bounces = false; // 去除弹簧效果
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        // 4.添加pageControl：分页，展示目前看的是第几页
        pageControl.numberOfPages = (Int)(4);
        pageControl.currentPageIndicatorTintColor =  UIColor.orangeColor()
        pageControl.pageIndicatorTintColor = UIColor(red: 189, green: 189, blue: 189, alpha: 1)
        pageControl.center.x = scrollView.frame.size.width * 0.5
        pageControl.center.y = scrollView.frame.size.height - 50
        self.view.addSubview(pageControl)
        
    }
   
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width;
        pageControl.currentPage = (Int)(page + 0.5)
      
    }
    func startClick()
    {
        UIApplication.sharedApplication().keyWindow!.rootViewController = WBTabBarViewController()
    }
        func setupLastImageView(imageView:UIImageView)
        {
        //开启交互功能
        imageView.userInteractionEnabled = true
            
        // 1.分享给大家（checkbox）
            let shareBtn = UIButton()
            shareBtn.setImage(UIImage(named:"new_feature_share_false"), forState:UIControlState.Normal)
            shareBtn.setImage(UIImage(named:"new_feature_share_true"), forState:UIControlState.Selected)
            shareBtn.setTitle("分享給大家", forState: UIControlState.Normal)
            shareBtn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            shareBtn.titleLabel?.font = UIFont.systemFontOfSize(15)
            shareBtn.frame.size = CGSize(width: 200, height: 30)
            shareBtn.center.x = imageView.frame.width * 0.5
            shareBtn.center.y = imageView.frame.height * 0.65
            shareBtn.addTarget(self, action: "shareClick:", forControlEvents: UIControlEvents.TouchUpInside)
            // titleEdgeInsets:只影响按钮内部的titleLabel
            shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0)
            imageView.addSubview(shareBtn)
        //开始微博
        let startBtn = UIButton()
        startBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button"), forState: UIControlState.Normal)
        startBtn.setBackgroundImage(UIImage(named: "new_feature_finish_button_highlighted"), forState: UIControlState.Highlighted)
        startBtn.frame.size = startBtn.currentBackgroundImage!.size
        startBtn.setTitle("开始微博", forState: UIControlState.Normal)
        startBtn.center.x = shareBtn.center.x
        startBtn.center.y = imageView.frame.height * 0.75
        startBtn.addTarget(self, action: "startClick", forControlEvents: UIControlEvents.TouchUpInside)
        imageView.addSubview(startBtn)
       }
    func shareClick(shareBtn:UIButton)
    {
        shareBtn.selected = !shareBtn.selected
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}