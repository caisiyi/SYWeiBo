//
//  StringExtension.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/12.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import Foundation

extension String
{
    /// 扩展String,使用正则表达式获取来源
    func linkSource() -> String
    {
        // 匹配规则
        let pattern = ">(.*?)</a>"
        // 创建正则表达式
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        // 匹配
        let result = regular.firstMatchInString(self, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
        
        // 匹配个数
        let count = result?.numberOfRanges ?? 0
        
        // 默认来源
        var text = "微博客户端"
        
        if count > 0
        {
            let range = result!.rangeAtIndex(1)
            // 使用范围截取字符串
            text = (self as NSString).substringWithRange(range)
        }
        
        return "来自 \(text)"
    }
//    func getLinkRanges(finised:()->())  {
//        var linkstring = self
//        // 创建正则表达式
//        guard let detector = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue) else {
//            finised()
//            return
//        }
//        
//        // 1.匹配结果
//        let results = detector.matchesInString(self, options: [], range: NSRange(location: 0, length: self.characters.count))
//        
//        // 2.遍历结果
//        var ranges = [NSRange]()
//        for res in results {
//            ranges.append(res.range)
//        }
//        var count = 0
//        var preRange = 0
//        if ranges.count > 0 {
//            ranges.forEach { (range) -> () in
//                WBStatusHelper.getHttpLinkStyle(NSString(string:self).substringWithRange(range), finished: { (result) -> () in
//                    if result != nil {
//                        let style = "查看图片"
//                        let json = JSON(result!)
//                        let dic = json["urls"].arrayValue.first!
//                        let url = dic["url_long"].string
//                        let string = "<a href=\"\(url!)\">\(style)</a>"
//                        self =  NSString(string:self).stringByReplacingCharactersInRange(NSRange(location: range.location + preRange, length: range.length), withString: string)
//                        preRange += string.characters.count - range.length
//                        count++
//                        if count == ranges.count{
//                            print(self)
//                            finised()
//                        }
//                    }
//                })
//            }
//        }else{
//            finised()
//        }
//    }
    func getStringLinkRanges(finised:(result:String?)->())  {
        var linkstring = self
        // 创建正则表达式
        guard let detector = try? NSDataDetector(types: NSTextCheckingType.Link.rawValue) else {
            finised(result: nil)
            return
        }
        
        // 1.匹配结果
        let results = detector.matchesInString(self, options: [], range: NSRange(location: 0, length: self.characters.count))
        
        // 2.遍历结果
        var ranges = [NSRange]()
        for res in results {
            ranges.append(res.range)
        }
        var count = 0
        var preRange = 0
        if ranges.count > 0 {
        ranges.forEach { (range) -> () in
            WBStatusHelper.getHttpLinkStyle(NSString(string:self).substringWithRange(range), finished: { (result) -> () in
                if result != nil {
                    let style = "查看图片"
                    let json = JSON(result!)
                    let dic = json["urls"].arrayValue.first!
                    let url = dic["url_long"].string
                    let string = "<a href=\"\(url!)\">\(style)</a>"
                    linkstring =  NSString(string:linkstring).stringByReplacingCharactersInRange(NSRange(location: range.location + preRange, length: range.length), withString: string)
                    preRange += string.characters.count - range.length
                    count++
                    if count == ranges.count{
                        finised(result: linkstring)
                    }
                }
            })
        }
        }else{
            finised(result: linkstring)
        }
    }
    
    
    /// 扩展String,使用正则表达式获取来源
    func linkHttp(string:String) -> (String,[NSURL])
    {
        
        //"<a href=\"http://app.weibo.com/t/feed/625Lq9\">查看大图</a>"
        // 匹配规则-取到Url
        let pattern2 = "href=\"(.*?)\""
        // 创建正则表达式
        let regular2 = try! NSRegularExpression(pattern: pattern2, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        var urls:[NSURL] = []
        // 匹配
        let result2 = regular2.matchesInString(self, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
        var ranges2 = [NSRange]()
        for res in result2 {
            ranges2.append(res.range)
        }
        ranges2.forEach { (range) -> () in
            urls.append(
                NSURL(string: NSString(string:string).substringWithRange(NSRange(location: range.location + 6, length: range.length - 7)))!)
        }
        
        // 匹配规则
        let pattern = "<(.*?)</a>"
        
        // 创建正则表达式
        let regular = try! NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.DotMatchesLineSeparators)
        
        // 匹配
        let result = regular.matchesInString(self, options: NSMatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.characters.count))
        
        var linkString = string
        
        // 2.遍历结果
        var ranges = [NSRange]()
        for res in result {
            ranges.append(res.range)
        }
        
        var preRange = 0
        ranges.forEach { (range) -> () in
            let string = "查看大图"
            linkString =  NSString(string:linkString).stringByReplacingCharactersInRange(NSRange(location: range.location + preRange, length: range.length), withString: string)
            preRange += string.characters.count - range.length
        }
        
        result.forEach { (result) -> () in
            
        }
        
        
        return ("\(linkString)",urls)
    }
    
}