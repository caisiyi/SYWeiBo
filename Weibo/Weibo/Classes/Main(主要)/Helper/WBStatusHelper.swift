//
//  WBStatusHelper.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/12.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBStatusHelper {
    class func defaultURLForImageURL(inout imageUrl:String?){
        //    /*
        //    微博 API 提供的图片 URL 有时并不能直接用，需要做一些字符串替换：
        //    http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6.png //input
        //    http://u1.sinaimg.cn/upload/2014/11/04/common_icon_membership_level6_default.png //output
        //
        //    http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_y.png?version=2015080302 //input
        //    http://img.t.sinajs.cn/t6/skin/public/feed_cover/star_003_os7.png?version=2015080302 //output
        //    */
        guard var url = imageUrl  else{
            return
        }
        let link = url as NSString
        guard link.length == 0 else{
            return
        }
        if link.hasSuffix(".png") {
            if !link.hasSuffix("_default.png") {
                let sub = link.substringToIndex(link.length - 4)
                url = sub.stringByAppendingFormat("_default.png")
            }
        } else{
            let range = link.rangeOfString("_y.png?version")
            if  range .location != NSNotFound {
                let mutable = link.mutableCopy()
                mutable.replaceCharactersInRange(NSMakeRange(range.location + 1, 1), withString: "os7")
                url = mutable as! String
            }
        }
        imageUrl = url
    }

}
