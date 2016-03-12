//
//  WBNetworkTool.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/21.
//  Copyright © 2016年 caisiyi. All rights reserved.
//


import UIKit

/// 网络请求方式
enum WBNetworkMethod: String {
    case GET
    case POST
}

/// 网络回调闭包别名
typealias NetworkFinishedCallBack = (result: [String : AnyObject]?, error: NSError?) -> ()

// MARK: - 网络工具类
class WBNetworkTool: NSObject {
    
    // MARK: - 属性
    /// 创建网络请求单例
    static let shareNetworkTool = WBNetworkTool()
    
    /// AFN网络请求对象
    private var afnManager: AFHTTPSessionManager
    
    /**
     重写初始化方法
     */
    override init() {
        afnManager = AFHTTPSessionManager(baseURL: NSURL(string: "https://api.weibo.com"))
        afnManager.responseSerializer.acceptableContentTypes?.insert("text/plain")
    }
    
    // MARK: - OAuth授权信息
    private let client_id = "2357896"
    private let app_secret = "2aa912fbcfb0dbbbd0f5753f2ae7e57f"
    let redirect_uri = "https://api.weibo.com/oauth2/default.html"
    let grant_type = "authorization_code"
    
    /**
     获取授权的URL
     */
    func oauthUrl() -> NSURL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id)&redirect_uri=\(redirect_uri)"
        return NSURL(string: urlString)!
    }
    
}

// MARK: - 发送网络请求
extension WBNetworkTool {
    
    /**
     根据code加载access_token，并返回给调用者
     
     - parameter code:   code码
     - parameter finished: 完成回调
     */
    func loadAccessToken(code: String, finished: NetworkFinishedCallBack) {
        
        // 请求参数
        let parameters = [
            "client_id" : client_id,
            "client_secret" : app_secret,
            "grant_type" : grant_type,
            "redirect_uri" : redirect_uri,
            "code" : code
        ]
        
        // 发送POST请求，获取access_token并返回给调用者
        request(WBNetworkMethod.POST, URLString: "oauth2/access_token", parameters: parameters, finished: finished)
    }
    
    /**
     加载用户数据,负责获取数据,不处理数据
     
     - parameter finished: 完成回调
     */
    func loadUserInfo(finished: NetworkFinishedCallBack) {
        
        // 判断access_token和uid是否已经存在
        if WBUserAccount.shareUserAccount.access_token == nil || WBUserAccount.shareUserAccount.uid == nil {
            // 不存在就不继续执行
            return
        }
        
        // 请求参数
        guard var parameters = tokenDict(finished) else {
            return
        }
        
        // 判断uid是否有值
        if WBUserAccount.shareUserAccount.uid == nil {
            let error = WBNetworkError.emptyUid.error()
            finished(result: nil, error: error)
            return
        }
        parameters["uid"] = WBUserAccount.shareUserAccount.uid!
        
        // 请求URL字符串
        let urlString = "2/users/show.json"
        
        // 发送get请求，加载用户数据
        request(WBNetworkMethod.GET, URLString: urlString, parameters: parameters, finished: finished)
    }
    
    /**
     加载微博数据
     
     - parameter finished: 完成回调
     */
    func loadStatus(since_id since_id: Int? = nil, max_id: Int? = nil ,finished: NetworkFinishedCallBack) {
        
        // 判断access_token是否为空
        if WBUserAccount.shareUserAccount.access_token == nil {
            // 回调错误
            finished(result: nil, error: WBNetworkError.emptyToken.error())
            return
        }
        
        // guard守卫，如果没有值才执行else里，否则赋值给parameters后继续执行后面代码
        guard var parameters = tokenDict(finished) else {
            return
        }
        
        // 两者不能同时都有值
        if since_id != nil || max_id != nil {
            
        if since_id != nil {
            parameters["since_id"] = since_id!
        }
        
        if max_id != nil {
            parameters["max_id"] = max_id! - 1//必须－1,或者获取到的数据最新一条会跟之前的最后一条一样
        }
            
        }
        // 请求URL字符串
        let urlString = "2/statuses/home_timeline.json"
        
        // 发送get请求，加载微博数据
        request(WBNetworkMethod.GET, URLString: urlString, parameters: parameters, finished: finished)
        
    }
    /**
     获取微博未读数量
     - parameter finished: 完成回调
     */
    func loadUnreadCount(finished: NetworkFinishedCallBack)  {
        
        // 判断access_token是否为空
        if WBUserAccount.shareUserAccount.access_token == nil {
            // 回调错误
            finished(result: nil, error: WBNetworkError.emptyToken.error())
            return
        }
        
        // guard守卫，如果没有值才执行else里，否则赋值给parameters后继续执行后面代码
        guard var parameters = tokenDict(finished) else {
            return
        }
        parameters["uid"] = WBUserAccount.shareUserAccount.uid
        
        // 请求URL字符串
        let urlString = "2/remind/unread_count.json"
        // 发送get请求
        request(WBNetworkMethod.GET, URLString: urlString, parameters: parameters, finished: finished)
        
    }
    /**
     判断access_token是否为空
     
     - parameter finished: 网络回调
     
     - returns: 返回key为 access_token的字典，可能没有值
     */
    func tokenDict(finished: NetworkFinishedCallBack) -> [String : AnyObject]? {
        
        // 判断access_token是否为空
        if WBUserAccount.shareUserAccount.access_token == nil {
            
            // 失败回调
            finished(result: nil, error: WBNetworkError.emptyToken.error())
            return nil
        }
        
        // 有值就返回一个字典
        return ["access_token" : WBUserAccount.shareUserAccount.access_token!]
        
    }
    
}

// MARK: - 封装GET、POST请求、判断access_token
extension WBNetworkTool {
    
    /**
     GET/POST网络请求
     
     - parameter requestMethod: 请求方式
     - parameter URLString:     请求URL字符串
     - parameter parameters:    请求参数字典
     - parameter finish:        完成回调
     */
    private func request(requestMethod: WBNetworkMethod, URLString: String, parameters: [String : AnyObject], finished: NetworkFinishedCallBack) {
        
        // 根据请求方式，发送请求
        switch requestMethod {
            
            // GET方式
        case .GET:
            self.afnManager.GET(URLString, parameters: parameters, progress: { (progress) -> Void in
                    // 进度
                }, success: { (_, result) -> Void in
                    // 成功回调
                    finished(result: result as? [String : AnyObject], error: nil)
                }, failure: { (_, error) -> Void in
                    // 失败回调
                    finished(result: nil, error: error)
            })
          
            
            // POST方式
        case .POST:
            self.afnManager.POST(URLString, parameters: parameters, progress: { (progress) -> Void in
                    // 进度
                }, success: { (_, result) -> Void in
                    // 成功回调
                    finished(result: result as? [String : AnyObject], error: nil)
                }, failure: { (_, error) -> Void in
                    // 失败回调
                    finished(result: nil, error: error)
            })
           
        }
        
    }
    
}