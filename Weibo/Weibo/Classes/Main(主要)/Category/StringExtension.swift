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
}