//
//  WBNetworkError.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/24.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import Foundation

// MARK: - 自定义网络请求错误枚举
enum WBNetworkError: Int {
    
    // 空accesstoken
    case emptyToken = -1
    
    // 空uid
    case emptyUid = -2
    
    
    // 错误描述
    var errorDescription: String {
        switch self {
        case .emptyToken:
            return "accesstoken 为空"
        case .emptyUid:
            return "uid 为空"
        }
    }
    
    // 返回 NSError 对象
    func error() -> NSError {
        return NSError(domain: "com.caisiyi.error.network", code: rawValue, userInfo: ["errorDescription" : errorDescription])
    }
}