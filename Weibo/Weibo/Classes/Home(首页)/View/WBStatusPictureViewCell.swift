//
//  WBStatusPictureViewCell.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/29.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBStatusPictureViewCell: UICollectionViewCell {
    
    /// 图片URL，接收到数据就立马加载图片
    var imageURL: NSURL? {
        didSet {
            // 加载图片
            iconView.sd_setImageWithURL(imageURL)
            
            // 根据URL字符串后缀判断是否显示gif图标
            let isGif = (imageURL!.absoluteString as NSString).hasSuffix("gif")
            gifView.hidden = !isGif
        }
    }

    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 添加子控件
        contentView.addSubview(iconView)
        contentView.addSubview(gifView)
        
        // 添加约束
        iconView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(contentView.snp_edges)
        }
        
        gifView.snp_makeConstraints { (make) -> Void in
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        }
        
    }
  
    
    // 图片
    lazy var iconView: UIImageView = {
        let imageView = UIImageView()
//        imageView.contentMode = UIViewContentMode.ScaleAspectFill
//        imageView.clipsToBounds = true
        return imageView
    }()
    
    // gif图片
    private lazy var gifView = UIImageView(image: UIImage(named: "timeline_image_gif"))
    
}
