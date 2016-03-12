//
//  WBStatusBottomView.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/29.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit


class WBStatusBottomView: UIView {
    
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
        addSubview(separatorViewOne)
        addSubview(separatorViewTwo)
        addSubview(separatorViewTop)
        addSubview(separatorViewBottom)
        
        
    }

    override func layoutSubviews() {
        
        super.layoutSubviews()
        // 转发
        forwardButton.snp_makeConstraints { (make) -> Void in
            make.top.left.equalTo(0)
            make.width.equalTo(kScreenW / 3)
            make.height.equalTo(self.bounds.height)
        }
        // 评论
        commentButton.snp_makeConstraints { (make) -> Void in
            make.top.width.height.equalTo(forwardButton)
            make.left.equalTo(forwardButton.snp_right)
        }
        // 赞
        likeButton.snp_makeConstraints { (make) -> Void in
            make.top.width.height.equalTo(commentButton)
            make.left.equalTo(commentButton.snp_right)
        }
        // 分割线1
        separatorViewOne.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(forwardButton.snp_right)
            make.top.equalTo(8)
            make.width.equalTo(1)
            make.bottom.equalTo(-8)
        }
        // 分割线2
        separatorViewTwo.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(commentButton.snp_right)
            make.top.equalTo(8)
            make.width.equalTo(1)
            make.bottom.equalTo(-8)
        }
        // 顶部分割线
        separatorViewTop.snp_makeConstraints { (make) -> Void in
            make.left.right.top.equalTo(0)
            make.height.equalTo(1)
        }
        // 底部分割线
        separatorViewBottom.snp_makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }
        

    }
    
    // MARK: - 懒加载控件
    // 转发
    private lazy var forwardButton = UIButton(title: "转发", imageName: "timeline_icon_retweet")
    
    // 评论
    private lazy var commentButton = UIButton(title: "评论", imageName: "timeline_icon_comment")
    
    // 赞
    private lazy var likeButton = UIButton(title: "赞", imageName: "timeline_icon_unlike")
    
    // 水平分割线
    private lazy var separatorViewOne = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    private lazy var separatorViewTwo = UIImageView(image: UIImage(named: "timeline_card_bottom_line_highlighted"))
    
    // 顶部分割线
    private lazy var separatorViewTop: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        return view
        }()
    
    // 底部分割线
    private lazy var separatorViewBottom: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 0.4)
        return view
    }()
    
}
