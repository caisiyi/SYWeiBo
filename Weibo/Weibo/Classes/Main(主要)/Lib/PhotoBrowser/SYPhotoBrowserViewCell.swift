//
//  SYPhotoBrowserViewCell.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/14.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit



class SYPhotoBrowserViewCell: UICollectionViewCell {
    

    // 图片数据模型
    var model: SYPhotoBrowserModel?

    /// 图片URL
    var imageUrl: NSURL? {
        didSet {
            
            guard let imgUrl = imageUrl else {
             
                return
            }
            
            // 重置cell各种属性，防止复用
            resetScrollView()
            
            // 加载转圈控件开始
            loadIndicator.startAnimating()
            
            // 下载图片
            imgView.sd_setImageWithURL(imgUrl) { (image, error, _, _) -> Void in
                
                // 加载转圈控件停止
                self.loadIndicator.stopAnimating()
                
                // 等比例缩放图片,得到正确尺寸
                let imageSize = self.resizeImage(image)
                
                // 图片布局
                if imageSize.height >= kScreenH {
                    // 长图设置滚动
                    self.scrollView.contentSize = imageSize
                    self.imgView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                    
                } else {
                    
                    // 使图片居中
                    let offestY = (kScreenH - imageSize.height) / 2
                    
                    // 设置imageView的frame
                    self.imgView.frame = CGRect(x: 0, y: 0, width: kScreenW, height: imageSize.height)
                    
                    // 不能使用 frame 来布局imageView的位置.在缩放后会停在origin的位置.无法显示完整
                    self.scrollView.contentInset = UIEdgeInsets(top: offestY, left: 0, bottom: offestY, right: 0)
                    
                }
                
            }
            
        }
    }
    
    /**
     根据屏幕尺寸缩放图片
     */
    func resizeImage(image: UIImage) -> CGSize {
        
        // 原始尺寸
        let size = image.size
        
        // 如果图片宽度不等于屏幕宽度应等比缩放到屏幕宽度
        if size.width != kScreenW {
            
            // 缩放后的宽度 / 缩放后的高度 = 原始宽度 / 原始高度
            let imageWidth = kScreenW
            let imageHeight = imageWidth / (size.width / size.height)
            return CGSize(width: imageWidth, height: imageHeight)
            
        }
        
        return size
        
    }
    
    /// 重置scrollView的一些属性,防止因为cell复用导致cell图片显示的不对
    private func resetScrollView() {
        scrollView.contentInset = UIEdgeInsetsZero
        scrollView.contentSize = CGSizeZero
        scrollView.contentOffset = CGPointZero
        imgView.transform = CGAffineTransformIdentity
    }
    
    // MARK: - 构造方法
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
        // 添加子控件
        contentView.addSubview(scrollView)
        scrollView.addSubview(imgView)
        contentView.addSubview(loadIndicator)
        
        // 约束子控件
        scrollView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        loadIndicator.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(contentView.snp_center)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        
        // 缩放比例
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 0.5
        
        // 代理
        scrollView.delegate = self
        
    }
    
  
    
    // MARK: - 懒加载
    // 内容区域
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    // 图片
    lazy var imgView: SYPhotoBrowserImageView = {
        let imgView = SYPhotoBrowserImageView()
        imgView.contentMode = UIViewContentMode.ScaleAspectFill
        return imgView
    }()
    
    // 加载转圈控件
    private lazy var loadIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
    
}
extension UIImageView {
    
}
// MARK: - UIScrollViewDelegate 代理方法
extension SYPhotoBrowserViewCell: UIScrollViewDelegate {
    
    // 需要缩放的view
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imgView
    }

    // 缩放时的动画,让图片始终在中间
    func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView?, atScale scale: CGFloat) {
        
        // 使 imageView显示在中间位置
        var offestX = (scrollView.bounds.width - imgView.frame.width) * 0.5
        var offestY = (scrollView.bounds.height - imgView.frame.height) * 0.5
        
        // 当 offestX < 0 时, 让 offestX = 0
        offestX = offestX < 0 ? 0 : offestX
        offestY = offestY < 0 ? 0 : offestY
        
        UIView.animateWithDuration(0.25) { () -> Void in
            scrollView.contentInset = UIEdgeInsets(top: offestY, left: offestX, bottom: offestY, right: offestX)
        }

        
    }
    
}
