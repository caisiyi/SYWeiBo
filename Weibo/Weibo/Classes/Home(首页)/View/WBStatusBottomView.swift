//
//  WBStatusBottomView.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/29.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit


class WBStatusBottomView: UIView {
    
    /// 微博模型
    var status: WBStatus? {
        didSet {
            // 更新bottomView的数据
            if let count = status?.reposts_count {
                if count != 0 {
                // 转发
                forwardButton.setTitle(" \(count)", forState: UIControlState.Normal)
                }
            }
            if let count = status?.comments_count {
                if count != 0 {
                // 评论
                commentButton.setTitle(" \(count)", forState: UIControlState.Normal)
                }
            }
            if let count = status?.attitudes_count {
                if count != 0 {
                // 点赞
                likeButton.setTitle(" \(count)", forState: UIControlState.Normal)
                }
            }
       
        }
    }
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加子控件
        addSubview(forwardButton)
        addSubview(commentButton)
        addSubview(likeButton)
        
        layer.addSublayer(separatorViewOne)
        layer.addSublayer(separatorViewTwo)
        layer.addSublayer(separatorViewTop)
        layer.addSublayer(separatorViewBottom)
        
        let w:CGFloat = kScreenW / 3
        let h:CGFloat = 30
        // 转发
        forwardButton.frame = CGRectMake(0, 0, w, h)
        // 评论
        commentButton.frame = CGRectMake(w, 0, w, h)
        // 赞
        likeButton.frame = CGRectMake(w * 2, 0, w, h)
        
        // 分割线1
        separatorViewOne.frame = CGRectMake(kScreenW / 3, 8, 1, 14)
        
        // 分割线2
        separatorViewTwo.frame = CGRectMake(kScreenW / 3 * 2, 8, 1, 14)
        
        // 顶部分割线
        separatorViewTop.frame = CGRectMake(0, 0, kScreenW, 1)
        // 底部分割线
        separatorViewBottom.frame = CGRectMake(0, 29, kScreenW, 1)
        

        
    }

    
    // MARK: - 懒加载控件
    // 转发
    private lazy var forwardButton:UIButton = {
        let btn = UIButton(title: " 转发", imageName: "timeline_icon_retweet")
        btn.setBackgroundImage(UIImage(named: "timeline_retweet_background_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "timeline_retweet_background"), forState: UIControlState.Highlighted)
        return btn
    }() 
    
    // 评论
    private lazy var commentButton:UIButton = {
        let btn = UIButton(title: " 评论", imageName: "timeline_icon_comment")
        btn.setBackgroundImage(UIImage(named: "timeline_retweet_background_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "timeline_retweet_background"), forState: UIControlState.Highlighted)
        return btn
    }()
    
    // 赞
    private lazy var likeButton:UIButton = {
        let btn = UIButton(title: " 赞", imageName: "timeline_icon_unlike")
        btn.setBackgroundImage(UIImage(named: "timeline_retweet_background_highlighted"), forState: UIControlState.Highlighted)
        btn.setBackgroundImage(UIImage(named: "timeline_retweet_background"), forState: UIControlState.Highlighted)
        return btn
    }()
    
    // 水平分割线
    private lazy var separatorViewOne: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.9, alpha: 1.0).CGColor
        return layer
    }()
    private lazy var separatorViewTwo: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.9, alpha: 1.0).CGColor
        return layer
    }()

    

    // 顶部分割线
    private lazy var separatorViewTop: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.9, alpha: 1.0).CGColor
        return layer
    }()
    // 底部分割线
    private lazy var separatorViewBottom: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.9, alpha: 1.0).CGColor
        return layer
    }()
   
    
}
