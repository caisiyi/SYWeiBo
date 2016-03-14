//
//  SYPhotoBrowserImageView.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/14.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class SYPhotoBrowserImageView: UIImageView {

    // 重写父类transform属性，让最小缩放 不小于0.5
    override var transform: CGAffineTransform
        {
        didSet
        {
            if transform.a < 0.5 {
                transform.a = 0.5
                transform.d = 0.5
            }
        }
    }
    
}
