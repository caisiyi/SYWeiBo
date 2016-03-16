//
//  WBCenterItemButton.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/16.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBCenterItemButton: UIButton {

    /**
     重新布局子控件
     */
    override func layoutSubviews() {
        adjustsImageWhenHighlighted = false
        super.layoutSubviews()
        
        imageView?.frame = CGRect(x: (bounds.width - 71) * 0.5, y: 10, width: 71, height: 71)
        titleLabel?.frame = CGRect(x: 0, y: 90, width: bounds.width, height: 30)
        
        if self.highlighted {
            imageView?.frame = CGRect(x: (bounds.width - 71) * 0.5 - 5, y: 10 - 5, width: 81, height: 81)
        }
    }

}
