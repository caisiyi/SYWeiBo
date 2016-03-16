//
//  WBCenterViewController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/16.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit


class WBCenterViewController: UIViewController {
    
    // 底部子控件
    var centerCloseButton: UIButton!
    var centerSeparator: UIView!
    var leftButton: UIButton!
    var rightCloseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        
        // 背景颜色
        view.backgroundColor = UIColor(red: 237/255, green: 237/255, blue: 237/255, alpha: 0.95)
        
    }
    var currentPage:Int = 0
    var popAnimatedFinished:Bool = false
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // 弹出效果
        for item in contentView.subviews {
            if item.tag < 6 {
            let index = item.tag % 6
            let time:NSTimeInterval = Double(CGFloat(index) * 0.08 + 0.2)
            UIView.animateWithDuration(time, animations: { () -> Void in
                item.transform = CGAffineTransformMakeTranslation(0, -kScreenH * 0.65-12)
                item.alpha = 1
                }, completion: { (_) -> Void in
                    UIView.animateWithDuration(0.1, animations: { () -> Void in
                        item.transform = CGAffineTransformMakeTranslation(0, -kScreenH * 0.65)
                        }, completion: { (_) -> Void in
                            if index == 5{
                            self.popAnimatedFinished = true
                            }
                    })
            })
            }
        }
        
        
    }
    
    // MARK: - 添加所有子控件,准备UI
    func prepareUI() {
        
        // 添加中间视图区
        view.addSubview(contentView)
        
        // 添加logo
        view.addSubview(topLogo)
        
        // 添加底部关闭条
        view.addSubview(bottomBar)
        
        // 约束中间视图
        contentView.frame = CGRectMake(0, kScreenH * 0.35, kScreenW * 2, kScreenH * 0.4)
        // 约束logo
        topLogo.frame.origin = CGPointMake(0, 95)
        topLogo.center.x = view.center.x
        
        // 约束底部关闭条
        bottomBar.frame = CGRectMake(0, kScreenH - 40, kScreenW, 40)
        
        // 添加中间视图的子控件
        addContentSubviews()
        
        // 添加底部关闭条的子控件
        addBottomSubviews()
    }
    
    // MARK: - 懒加载
    // 中间视图
    lazy var contentView: UIView = {
        let content = UIView()
        return content
    }()
    
    // logo
    lazy var topLogo: UIImageView = {
        let logo = UIImageView(image: UIImage(named: "compose_slogan"))
        return logo
    }()
    
    // 底部关闭条
    lazy var bottomBar: UIView = {
        let bar = UIView()
        bar.backgroundColor = UIColor.whiteColor()
        
        return bar
    }()
    
}

// MARK: - 中间内容视图区域的控件管理
extension WBCenterViewController {
    
    /**
     添加底部关闭条的按钮
     */
    func addBottomSubviews() {
        
        // 中间关闭按钮
        centerCloseButton = UIButton(type: UIButtonType.Custom)
        centerCloseButton.sizeToFit()
        centerCloseButton.setImage(UIImage(named: "tabbar_compose_background_icon_close"), forState: UIControlState.Normal)
        bottomBar.addSubview(centerCloseButton)
        centerCloseButton.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(bottomBar.snp_center)
        }
        centerCloseButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)

        
        // 向左按钮
        leftButton = UIButton(type: UIButtonType.Custom)
        leftButton.hidden = true
        leftButton.sizeToFit()
        leftButton.setImage(UIImage(named: "tabbar_compose_background_icon_return"), forState: UIControlState.Normal)
        bottomBar.addSubview(leftButton)
        leftButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(70)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
        leftButton.addTarget(self, action: "didSwipeedScreen", forControlEvents: UIControlEvents.TouchUpInside)

        // 中间分割线
        centerSeparator = UIView()
        centerSeparator.hidden = true
        centerSeparator.backgroundColor = UIColor(red: 237/255.0, green: 237/255.0, blue: 237/255.0, alpha: 0.8)
        bottomBar.addSubview(centerSeparator)
        centerSeparator.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(bottomBar.snp_centerX)
            make.height.equalTo(bottomBar.snp_height)
            make.top.equalTo(0)
            make.width.equalTo(1)
        }
        
        // 右边的关闭按钮
        rightCloseButton = UIButton(type: UIButtonType.Custom)
        rightCloseButton.hidden = true
        rightCloseButton.sizeToFit()
        rightCloseButton.setImage(UIImage(named: "tabbar_compose_background_icon_close"), forState: UIControlState.Normal)
        bottomBar.addSubview(rightCloseButton)
        rightCloseButton.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(-70)
            make.centerY.equalTo(bottomBar.snp_centerY)
        }
        rightCloseButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
	
        
    }
    
    /**
     添加中间视图的子控件
     */
    func addContentSubviews() {
        
        setupItemButton("文字", imageName: "tabbar_compose_idea")
        setupItemButton("相册/视频", imageName: "tabbar_compose_photo")
        setupItemButton("头条文章", imageName: "tabbar_compose_weibo")
        setupItemButton("签到", imageName: "tabbar_compose_lbs")
        setupItemButton("点评", imageName: "tabbar_compose_review")
        let more = setupItemButton("更多", imageName: "tabbar_compose_more")
        more.addTarget(self, action: "more", forControlEvents: UIControlEvents.TouchUpInside)
        setupItemButton("好友圈", imageName: "tabbar_compose_friend")
        setupItemButton("微博相机", imageName: "tabbar_compose_wbcamera")
        setupItemButton("音乐", imageName: "tabbar_compose_music")
        setupItemButton("红包", imageName: "tabbar_compose_envelope")
        setupItemButton("商品", imageName: "tabbar_compose_envelope")
        setupItemButton("拍摄", imageName: "tabbar_compose_camera")

        
        // 布局
        // 每行六个
        let rowCount = 6
        let itemWidth = kScreenW / 3
        let itemHeight = kScreenH * 0.4 * 0.5
        // 遍历中间内容视图的子控件并布局
        for item in contentView.subviews {
            var page:CGFloat = 0
            if  item.tag >= 6 {
                page = 1
            }
            let index = Int(item.tag) % rowCount
            
            let itemLeft = CGFloat( index % 3 ) * itemWidth + page * kScreenW

            let itemTop =  ( index >= 3 ?  itemHeight : 0 ) + ( page > 0 ?  0 : kScreenH * 0.65 )
           
            item.frame = CGRectMake(itemLeft, itemTop,itemWidth, itemHeight)

            item.alpha =  ( page > 0 ? 1 : 0 )
        }
        
        
    }
    /**
     更多
     */
    func more(){
        // 点击更多后动画，右移视图
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            // 形变
            self.contentView.transform = CGAffineTransformMakeTranslation(-kScreenW, 0)
            // 修改底部子控件隐藏状态
            self.leftButton.hidden = false
            self.rightCloseButton.hidden = false
            self.centerCloseButton.hidden = true
            self.centerSeparator.hidden = false
            self.currentPage = 1
        })
        
        // 添加全屏侧滑手势，左移视图
        let swipe = UISwipeGestureRecognizer(target: self, action: "didSwipeedScreen")
        swipe.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipe)
    }
    /**
     关闭
     */
    func close(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /**
     全屏侧滑手势
     */
    func didSwipeedScreen() {
        
        // 点击更多后动画，右移视图
        UIView.animateWithDuration(0.5) { () -> Void in
            // 形变
            self.contentView.transform = CGAffineTransformMakeTranslation(0, 0)
            // 修改底部子控件隐藏状态
            self.leftButton.hidden = true
            self.rightCloseButton.hidden = true
            self.centerCloseButton.hidden = false
            self.centerSeparator.hidden = true
            self.currentPage = 0
        }
    }
    
    /**
     配置单个按钮
     
     - parameter title:     按钮标题
     - parameter imageName: 按钮图片名称
     
     - returns: 返回配置好的按钮
     */
    func setupItemButton(title: String, imageName: String) -> WBCenterItemButton {
        let itemButton = WBCenterItemButton(type: UIButtonType.Custom)
        itemButton.tag = contentView.subviews.count
        itemButton.titleLabel?.textAlignment = NSTextAlignment.Center
        itemButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
        itemButton.setTitle(title, forState: UIControlState.Normal)
        itemButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        contentView.addSubview(itemButton)
        return itemButton
    }
    /**
     拦截系统dismissViewControllerAnimated方法
     */
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        if popAnimatedFinished{
        for item in contentView.subviews.reverse() {
            if item.tag >= self.currentPage * 6 && item.tag <= ( self.currentPage ) * 6 + 5{
            let index = item.tag % 6
            let time:NSTimeInterval = Double(CGFloat(6 - index) * 0.12 + 0.2)
            UIView.animateWithDuration(time, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                item.transform = CGAffineTransformMakeTranslation(0, kScreenH * 0.3)
                item.alpha = 0
                }, completion: { (_) -> Void in
                    if index == 0 {
                        super.dismissViewControllerAnimated(false, completion: completion)
                    }
            })
            }
        }
        }


    }
    
}
