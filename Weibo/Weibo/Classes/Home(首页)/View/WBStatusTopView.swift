//
//  WBStatusTopView.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/29.
//  Copyright © 2016年 caisiyi. All rights reserved.
//


import UIKit



class WBStatusTopView: UIView {
    
    /// 微博模型
    var status: WBStatus? {
        didSet {
            // 更新topView的数据
            // 头像
            if let url = status?.user?.profileImageUrl {
                
                if !SDWebImageManager.sharedManager().diskImageExistsForURL(url){
                    SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(), progress: { (_, _) -> Void in
                        }, completed: { (image, _, _, _, _) -> Void in
                            let image = image!.roundedCornerImageWithCornerRadius(17.5)
                            SDWebImageManager.sharedManager().saveImageToCache(image, forURL: url)
                            self.iconView.image = image
                    })
                }else{
                    self.iconView.sd_setImageWithURL(url)
                }
                
                
            }
            
            // 认证
            verifiedView.image = status?.user?.verifiedTypeImage
            
            // 用户名称
            nameLabel.text = status?.user?.name
            // 用户名称颜色
            nameLabel.textColor = status?.user?.mbrankImage == nil ? UIColor.darkGrayColor() : UIColor.orangeColor()
            
            // 会员等级
            memberView.image = status?.user?.mbrankImage
            
            // 时间标签
            
            timeLabel.text = status?.created_time
            
            
            // 微博来源
            sourceLabel.text = status?.source
            
        }
    }
    
    // 构造方法，从sb/xib加载调用
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        // 添加控件
        self.layer.addSublayer(topSeparatorView)// addSubview(topSeparatorView)
        addSubview(iconView)
        addSubview(verifiedView)
        addSubview(nameLabel)
        addSubview(memberView)
        addSubview(timeLabel)
        addSubview(sourceLabel)
        addSubview(righeMoreBtn)
        
        // 约束控件
        // 顶部分割线
        //        topSeparatorView.snp_makeConstraints { (make) -> Void in
        //            make.left.top.right.equalTo(0)
        //            make.height.equalTo(10)
        //        }
        //
        // 头像图标
        iconView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 35, height: 35))
            make.top.equalTo(22)
            make.left.equalTo(statusMargin)
        }
        
        // 认证图标
        verifiedView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.bottom.equalTo(iconView.snp_bottom).offset(2)
            make.right.equalTo(iconView.snp_right).offset(2)
        }
        
        // 名称
        nameLabel.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(iconView.snp_right).offset(statusMargin)
            make.top.equalTo(iconView.snp_top).offset(1)
        }
        
        // 会员等级图标
        memberView.snp_makeConstraints { (make) -> Void in
            make.size.equalTo(CGSize(width: 14, height: 14))
            make.left.equalTo(nameLabel.snp_right).offset(5)
            make.centerY.equalTo(nameLabel.snp_centerY)
        }
        
        // 发布时间
        timeLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp_bottom).offset(5)
            make.left.equalTo(nameLabel.snp_left)
        }
        
        // 来源
        sourceLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(timeLabel.snp_top)
            make.left.equalTo(timeLabel.snp_right).offset(statusMargin)
        }
        
        // 右上方小角标
        righeMoreBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel.snp_top)
            make.right.equalTo(-10)
        }
        
    }
    
    
    
    // MARK: - 懒加载topView子控件
    // 用户头像
    private lazy var iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar")
        //        imageView.layer.cornerRadius = 17.5
        //        imageView.layer.shouldRasterize = true
        //        imageView.layer.rasterizationScale = UIScreen.mainScreen().scale
        //        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // 认证图标
    private lazy var verifiedView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // 认证图标
    private lazy var vipBackgroundView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    // 用户名称标签
    private lazy var nameLabel = UILabel(textColor: UIColor.darkGrayColor(), fontSize: 14)
    
    // 会员等级图标
    private lazy var memberView: UIImageView = {
        let image = UIImage(named: "common_icon_membership")
        return UIImageView(image: image)
    }()
    
    // 时间标签
    private lazy var timeLabel = UILabel(textColor: UIColor.lightGrayColor(), fontSize: 9)
    
    // 来源标签
    private lazy var sourceLabel = UILabel(textColor: UIColor.lightGrayColor(), fontSize: 9)
    
    // 顶部分割线
    private lazy var topSeparatorView: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor(white: 0.9, alpha: 0.4).CGColor
        layer.frame = CGRect(x: 0, y: 0, width: kScreenW , height: 10)
        return layer
    }()
    // 右侧小角标
    private lazy var righeMoreBtn:UIButton = {
        let btn = UIButton(imageName: "timeline_icon_more", highlightedImageName: "timeline_icon_more_highlighted")
        return btn
        
    }()
}

