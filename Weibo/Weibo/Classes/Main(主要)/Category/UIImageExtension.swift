//
//  UIImageExtension.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/14.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit
extension UIImage {
    func roundedCornerImageWithCornerRadius(var cornerRadius:CGFloat) -> UIImage{
        let w = self.size.width
        let h = self.size.height
        let scale = UIScreen.mainScreen().scale
        if cornerRadius < 0 {
            cornerRadius = 0
        }else if cornerRadius > min(w, h){
            cornerRadius = min(w,h) / 2
        }
        var image = UIImage()
        let imageFrame = CGRectMake(0, 0, w, h)
        UIGraphicsBeginImageContextWithOptions(self.size, false, scale)
        UIBezierPath(roundedRect: imageFrame, cornerRadius: cornerRadius).addClip()
        self.drawInRect(imageFrame)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
