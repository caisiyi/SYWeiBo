//
//  WBStatusForwardCell.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/29.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

let _WBStatusForwardCellSharedInstance = WBStatusForwardCell()


class WBStatusForwardCell: WBStatusCell {

    class func GetRowHeight(status: WBStatus)->CGFloat{
        return _WBStatusForwardCellSharedInstance.rowHeight(status)
    }
    
    override var status: WBStatus? {
        didSet {
            
       
            forwardLabel.attributedText = status?.forwardAttributedText
            
            // 更新配图区约束
            pictureView.snp_updateConstraints { (make) -> Void in
                make.size.equalTo(pictureSize)
            }
            bottomView.snp_updateConstraints { (make) -> Void in
                if pictureSize == CGSize.zero {
                    make.top.equalTo(pictureView.snp_bottom).offset(0)
                }else{
                    make.top.equalTo(pictureView.snp_bottom).offset(statusMargin)
                }
            }
            // 更新约束后重新布局
            layoutIfNeeded()
            
        }
    }
    
    /**
     重写父控件prepareUI方法
     */
    override func prepareUI() {
        
        super.prepareUI()
        
        // 添加子控件
        contentView.insertSubview(backButton, belowSubview: pictureView)
        contentView.addSubview(forwardLabel)
        
        // 设置约束
        // 顶部视图topView
        topView.snp_makeConstraints { (make) -> Void in
            make.left.top.right.equalTo(0)
            make.height.equalTo(53)
        }
        
        // 微博内容文本标签
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(statusMargin)
            make.top.equalTo(topView.snp_bottom).offset(statusMargin)
            make.width.equalTo(kScreenW - statusMargin * 2)
        }

        // 转发微博背景
        backButton.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(0)
            make.top.equalTo(contentLabel.snp_bottom).offset(statusMargin)
            make.bottom.equalTo(bottomView.snp_top)
        }
        
        // 转发微博文字
        forwardLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(statusMargin)
            make.right.equalTo(-statusMargin)
            make.top.equalTo(backButton.snp_top).offset(statusMargin)
            make.width.equalTo(kScreenW - statusMargin * 2)
        }
        
        // 微博配图
        pictureView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(statusMargin)
            make.top.equalTo(forwardLabel.snp_bottom).offset(statusMargin)
            make.size.equalTo(CGSizeZero)
        }
        
        // 底部视图
        bottomView.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(pictureView.snp_bottom).offset(statusMargin)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
        }
        
        // 约束底部视图和cell底部重合
        contentView.snp_makeConstraints { (make) -> Void in
            make.bottom.equalTo(bottomView.snp_bottom)
        }

    }
    
    // MARK: - 懒加载
    /// 转发微博文字
    private lazy var forwardLabel: FFLabel = {
        let label = FFLabel(textColor: UIColor.grayColor(), fontSize: 14)
        
      
        
        // 设置换行属性
        label.numberOfLines = 0
        
        return label
    }()
    
    /// 被转发微博背景
    private lazy var backButton: UIButton = {
        
        let button = UIButton(type: UIButtonType.Custom)
        
    
        // 按钮背景
        button.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        
        return button
    }()
}
