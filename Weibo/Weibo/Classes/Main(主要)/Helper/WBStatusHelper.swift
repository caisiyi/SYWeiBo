//
//  WBStatusHelper.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/12.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBStatusHelper {
    //缓存http链接的类型
    class func saveHttpLinkStyle(url:String){
       WBNetworkTool.shareNetworkTool.expandUrl(url) { (result, error) -> () in
        print(result)
        }
    }

}
