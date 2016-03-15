//
//  WBOAuthViewController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/21.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBOAuthViewController: UIViewController, UIWebViewDelegate {
    
    // MARK: - 懒加载
    private lazy var webView: UIWebView = {
        let web = UIWebView()
        web.delegate = self
        return web
    }()
    
    // 替换控制器的view
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 导航标题
        title = "新浪微博授权"
        
        // 加载授权界面
        webView.loadRequest(NSURLRequest(URL: WBNetworkTool.shareNetworkTool.oauthUrl()))
        
        // 设置导航栏按钮
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "cancelOAuth")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "自动填充密码", style: UIBarButtonItemStyle.Done, target: self, action: "autoFillUsernameAndPassword")
        
    }
    
    /**
     取消授权操作，返回主页
     */
    func cancelOAuth() {
        navigationController?.popViewControllerAnimated(true)
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
     自动填充用户名和密码
     */
    func autoFillUsernameAndPassword() {
        //webView.stringByEvaluatingJavaScriptFromString("document.getElementById('userId').value = 'XXXX ';" + "document.getElementById('passwd').value = 'XXXX';")
    }
    
    // MARK: - UIWebViewDelegate
    /**
    开始加载
    */
    func webViewDidStartLoad(webView: UIWebView) {
    }
    
    /**
     加载完成
     */
    func webViewDidFinishLoad(webView: UIWebView) {
    }
    
    /**
     栏架webView的请求操作，跟踪重定向URL，是否要加载
     */
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        // 获取完整请求URL字符串
        let urlString = request.URL!.absoluteString
        
        // 判断前缀，如果不包含回调前缀则说明不是回调地址，正常加载请求
        if !urlString.hasPrefix(WBNetworkTool.shareNetworkTool.redirect_uri) {
            return true
        }
        
        // 点击了取消或授权后
        if let query = request.URL?.query {
            
            // 将请求参数转为 NSString
            let tempQuery = query as NSString
            
            // 点击授权后的固定前缀是 code=
            let codeString = "code="
            
            if tempQuery.hasPrefix(codeString) {
                
                // 参数前缀是 code= 则表示点击了授权，截取code
                let code = tempQuery.substringFromIndex(codeString.characters.count)
                
                // 根据 code 获取 access_token
                WBNetworkTool.shareNetworkTool.loadAccessToken(code, finished: { (result, error) -> () in
                    
                    if error != nil || result == nil {
                        self.netError("授权失败")
                    } else {
                        
                        
                        // 授权返回的数据
//                        ["access_token": 2.00FTUqDC00a5tJ3770b768f8JPUfeB, "remind_in": 157679999, "uid": 1889104851, "expires_in": 157679999]
                        
                        //保存用户信息 access_token
                        WBUserAccount.shareUserAccount.saveUserAccount(result!)
                        //加载用户信息
                        WBUserAccount.shareUserAccount.loadUserInfo({ (result, error) -> () in
                            if result  != nil{
                                UIApplication.sharedApplication().keyWindow!.switchRootViewController()
                            }
                        })
                        
                    }
                })
                
            } else {
                
                cancelOAuth()
            }
        }
        return false
    }
   
    
    /**
     网络数据加载出错时提示
     */
    private func netError(errorMessage: String) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(2 * NSEC_PER_SEC)), dispatch_get_main_queue()) { () -> Void in
            self.cancelOAuth()
        }
    }
    
    
}
