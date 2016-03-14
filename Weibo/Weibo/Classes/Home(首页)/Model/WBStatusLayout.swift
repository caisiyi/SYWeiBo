//
//  WBStatusLayout.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/14.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

var _WBStatusLayout = WBStatusLayout()

class WBStatusLayout: NSObject {
    
    static var defaultLayout:WBStatusLayout{
        return _WBStatusLayout
    }
    
    func getHeight(status:WBStatus) -> WBStatusLayout {
        self.status = status
        return self
    }
    var status:WBStatus?{
        didSet{
            
            picSize = calculateViewSize()
            contentTextHeight = heightForNormalLabel(status?.text ?? "", width: kScreenW - 24, font: contentTextFont)
            if let status = status?.retweeted_status {
            retweetTextHeightTextHeight = heightForNormalLabel(status.text ?? "", width: kScreenW - 24, font: retweetTextFont)
            }
            categoryHeight()
            
        }
    }
    
    func heightForNormalLabel(value:String,width:CGFloat,font:UIFont) -> CGFloat{
        let text = UILabel()
        text.text = value
        text.numberOfLines = 0
        text.font = font
        text.sizeThatFits(CGSize.init(width: width, height: 0))
        text.sizeToFit()
        return text.frame.height
    }
    /**
     计算配图尺寸
     
     - returns: 返回配图的尺寸
     */
    func calculateViewSize() -> CGSize {
        
        let itemWidth: CGFloat = (kScreenW - 34) / 3
        // cell之间的间距
        let margin: CGFloat = 5
        // 最大列数
        let column = 3
        // 获取配图的数量
        let count = status?.pictureURLs?.count ?? 0
        // 无图
        if count == 0 {
            return CGSizeZero
        }
        // 一张图
        if count == 1 {
            var size = CGSize(width: 150, height: 120)
            // 获取图片URL地址
            let urlString = status?.pictureURLs?[0].absoluteString
            // 获取图片，有图片设置size为图片的size，没有则使用默认的
            if let image = SDWebImageManager.sharedManager().imageCache.imageFromDiskCacheForKey(urlString) {
                size = CGSize(width: image.size.width * 3, height: image.size.height * 3)
            }
            // 设置最小宽度
            if size.width < 40 {
                size.width = 40
            }
            return size
        }
        // 四张图片
        if count == 4 {
            let width = 2 * itemWidth + margin
            return CGSize(width: width, height: width)
        }  
        // 其他图片 ： 2, 3, 5, 6, 7, 8, 9
        // 公式： 行数 = (图片数量 + 列数 - 1) / 列数
        let row = (count + column - 1) / column
        // 计算宽度
        let width = (CGFloat(column) * itemWidth) + (CGFloat(column) - 1) * margin
        // 计算高度
        let height = (CGFloat(row) * itemWidth) + (CGFloat(row) - 1) * margin
        return CGSize(width: width, height: height)
        
    }
    
    private var contentTextFont:UIFont = UIFont.systemFontOfSize(15)
    private var retweetTextFont:UIFont = UIFont.systemFontOfSize(14)
    
    var margin:CGFloat?//各种间距
    var marginTop:CGFloat?//顶部灰色留白
    var topViewHeight:CGFloat?//顶部视图
    var contentTextHeight:CGFloat?//微博内容高度
    var picSize:CGSize?//配图高度
    var retweetTextHeightTextHeight:CGFloat?//转发内容高度
    var bottomViewHeight:CGFloat?//底部视图高度
    var totalHeight:CGFloat?//总高度
    func categoryHeight(){
        var marginCount:CGFloat = 1
        if status?.retweeted_status != nil {
            marginCount = 2
        }
        self.totalHeight = (margin ?? 0) * marginCount + (marginTop ?? 0) + (topViewHeight ?? 0)  + (contentTextHeight ?? 0)  + (picSize?.height ?? 0)  + (retweetTextHeightTextHeight ?? 0)  + (bottomViewHeight ?? 0)
    }
    override init() {
        margin = 8
        marginTop = 10
        topViewHeight = 52
        bottomViewHeight = 30
    }
}
