//
//  WBColor.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/19.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBColor: UIColor {
    override init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) {
        super.init(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }

    required convenience init(colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
        fatalError("init(colorLiteralRed:green:blue:alpha:) has not been implemented")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
}
