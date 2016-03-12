//
//  WBStatus.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/25.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBStatus: NSObject {
    
    // MARK: - 属性
    // 转发微博
    var retweeted_status: WBStatus?
    
    /// 用户模型
    var user: WBUser?
    
    /// 微博创建时间
    var created_at: String?
    
    /// 微博ID
    var id: Int = 0
    
    /// 微博信息内容
    var text: String?

    /// 微博来源
    var source: String?
    
    /// 图片地址数组
    var pic_urls: [[String: AnyObject]]? {
        didSet {
            // 判断pic_urls 是否有值,没有值直接返回
            let count = pic_urls?.count ?? 0
            if count == 0 {
                return
            }
            
            // 有值,遍历将pic_urls 里的string转成NSURL存放在pictureURLs数组里面
            storePictureURLs = [NSURL]()
            
            // 原图
            largeStorePictureURLs = [NSURL]()
            
            for dict in pic_urls! {
                // 取出 字典中的值，缩略图URL字符串
                let value = dict["thumbnail_pic"] as! String
                storePictureURLs?.append(NSURL(string: value)!)
                
                // 获取大图URL字符串
                let largeValue = value.stringByReplacingOccurrencesOfString("thumbnail", withString: "large")
                largeStorePictureURLs?.append(NSURL(string: largeValue)!)
            }
        }
    }
    // 执行计算cell行高
    func categoryCellRowHeight(){
        if self.retweeted_status != nil {
            self.rowHeight = WBStatusForwardCell.GetRowHeight(self)
        }else{
            
            self.rowHeight = WBStatusNormalCell.GetRowHeight(self)
        }

    }
    /// 缓存cell行高
    var rowHeight: CGFloat?
    
    // 重写构造方法，为属性赋值
    init(dict: [String : AnyObject]) {
        super.init()
        
        // kvc赋值
        setValuesForKeysWithDictionary(dict)
        
        
        
        
    }
    
    
    /// 缩图：存储微博对应的pic_urls里面对象的URL
    private var storePictureURLs: [NSURL]?
    
    /// 缩图：计算型属性,存储的是pic_urls里面对应的URL
    var pictureURLs: [NSURL]? {
        get {
            return retweeted_status == nil ? storePictureURLs : retweeted_status?.storePictureURLs
        }
    }
    
    /// 原图：存储微博对应的pic_urls里面对象的URL
    private var largeStorePictureURLs: [NSURL]?
    
    /// 原图：计算型属性,存储的是pic_urls里面对应的URL
    var largePictureURLs: [NSURL]? {
        get {
            return retweeted_status == nil ? largeStorePictureURLs : retweeted_status?.largeStorePictureURLs
        }
    }
    
    // 处理字典的key与模型属性不对应问题
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    // 在kvc字典转模型时，user属性特殊处理
    override func setValue(value: AnyObject?, forKey key: String) {
        
        // 如果是user属性
        if key == "user" {
            if let dict = value as? [String : AnyObject] {
                // 字典转模型
                user = WBUser(dict: dict)
            }
            return
        }
        
        // 如果设置retweeted_status属性，先转模型再赋值
        if key == "retweeted_status" {
            if let dict = value as? [String : AnyObject] {
                retweeted_status = WBStatus(dict: dict)
            }
            return
        }
        
        // 调用父类方法
        super.setValue(value, forKey: key)
    }
    
   
    
    /**
     加载微博数据并转模型
     
     - parameter finished: 完成回调
     - parameter list: 模型数组
     - parameter error: 错误
     */
    class func loadStatus(since_id since_id: Int? = nil, max_id: Int? = nil, finished: (list: [WBStatus]?, error: NSError?) -> ()) {
        
        WBNetworkTool.shareNetworkTool.loadStatus(since_id: since_id,max_id: max_id) { (result, error) -> () in
            // 判断是否有错误
            if error != nil {
                finished(list: nil, error: error)
            }
            
            // 获取返回数据里的微博数据
            if let array = result?["statuses"] as? [[String : AnyObject]] {
                
                // 创建模型数组
                var list = [WBStatus]()
                
                for dict in array {
                    // 字典转模型并添加到模型数组中
                    list.append(WBStatus(dict: dict))
                }
                
                // 缓存并回调数据
                cacheWebImage(list, finished: finished)
                
            } else {
                
                // 没有加载到数据
                finished(list: nil, error: nil)
            }
        }
        
    }
    
    /**
     缓存微博图片
     
     - parameter lists:    微博模型数组
     - parameter finished: 缓存完成回调
     */
    class func cacheWebImage(lists: [WBStatus], finished: (list: [WBStatus]?, error: NSError?) -> ()) {
        
        // 定义任务组
        let group = dispatch_group_create()
        
        // 遍历模型数组
        for status in lists {
            
            // 获取配图URL
            guard let urls = status.pictureURLs else {
                // 没有图片继续遍历下一个模型
                continue
            }
            
            // 只缓存一张图片
            if urls.count == 1 {
                
                // 取出图片URL
                let url = urls[0]
                
                // 进入任务组
                dispatch_group_enter(group)
                
                // 使用SDWebImage下载图片
                SDWebImageManager.sharedManager().downloadImageWithURL(url, options: SDWebImageOptions(rawValue: 0), progress: nil, completed: { (_, _, _, _, _) -> Void in
                    // 离开任务组
                    dispatch_group_leave(group)
                })
            }
        }
        
        // 下载完成所有图片才通知调用者微博数据加载完成
        dispatch_group_notify(group, dispatch_get_main_queue()) { () -> Void in
            // 遍历模型数组
            for status in lists {
            status.categoryCellRowHeight()
            }
            // 回调返回微博模型数组
            finished(list: lists, error: nil)
        }
    }
    
    
}
