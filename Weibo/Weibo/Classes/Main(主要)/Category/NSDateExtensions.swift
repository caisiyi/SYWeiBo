//
//  NSDateExtensions.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/12.
//  Copyright © 2016年 caisiyi. All rights reserved.
//
import UIKit
struct Formatter {
    
    static var fmt : NSDateFormatter?
    static var token: dispatch_once_t = 0
    
}
extension NSDate {
    
    public convenience init?(fromString string: String, format: String) {
        let formatter = NSDateFormatter()
        formatter.dateFormat = format
        if let date = formatter.dateFromString(string) {
            self.init(timeInterval: 0, sinceDate: date)
        } else {
            return nil
        }
    }
    class var defaultFormatter:NSDateFormatter {
        dispatch_once(&Formatter.token) {
            let formatter = NSDateFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en")
            Formatter.fmt = formatter
        }
        return Formatter.fmt!
        
    }
    ///  返回日期描述字符串
    ///
    ///     格式如下
    ///     -   刚刚(一分钟内)
    ///     -   X分钟前(一小时内)
    ///     -   X小时前(当天)
    ///     -   昨天 HH:mm(昨天)
    ///     -   MM-dd HH:mm(一年内)
    ///     -   yyyy-MM-dd HH:mm(更早期)
    func timePassed() -> String {
        
        // 在ios中处理日期使用calendar
        let calendar = NSCalendar.currentCalendar()
        
        // 判断是否是今天
        if calendar.isDateInToday(self) {
            
            // 获取self和当前日期相差的秒数
            let delta = Int(NSDate().timeIntervalSinceDate(self))
            
            if delta < 60 {
                return "刚刚"
            }
            
            if delta < 60 * 60 {
                return "\(delta / 60) 分钟前"
            }
            return "\(delta / 3600) 小时前"
        }
        
        var fmtString = "HH:mm"
        
        // 判断是否是昨天
        if calendar.isDateInYesterday(self) {
            
            fmtString = "昨天 \(fmtString)"
            
        } else {
            
            // 比较年份
            let result = calendar.compareDate(self, toDate: NSDate(), toUnitGranularity: NSCalendarUnit.Year)
            
            if result == NSComparisonResult.OrderedSame {
                
                // 同一年
                fmtString = "MM-dd \(fmtString)"
                
            } else {
                
                // 更早期
                fmtString = "yyyy-MM-dd \(fmtString)"
            }
        }
        
        
        
        // 创建NSDateFormatter
        NSDate.defaultFormatter.dateFormat = fmtString
        
        return NSDate.defaultFormatter.stringFromDate(self)
    }
}

extension NSDate: Comparable {}

public func ==(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.isEqualToDate(rhs)
}

public func <(lhs: NSDate, rhs: NSDate) -> Bool {
    return lhs.compare(rhs) == .OrderedAscending
}


