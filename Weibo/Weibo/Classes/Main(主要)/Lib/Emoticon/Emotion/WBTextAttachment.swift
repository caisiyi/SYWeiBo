//
//  WBTextAttachment.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/13.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class WBTextAttachment: NSTextAttachment {
    
    // MARK: - 属性
    /// 保存表情图片对应的名称
    var name: String?
    
    /**
     根据emoticon创建属性文本
     */
    class func imageText(emoticon: WBEmoticon, font: UIFont) -> NSAttributedString{
        // 创建附件
        let attachment = WBTextAttachment()
        attachment.name = emoticon.chs
        attachment.image = UIImage(contentsOfFile: emoticon.pngPath!)
        
        // font的高度
        let h = font.lineHeight
        attachment.bounds = CGRect(x: 0, y: -4, width: h, height: h)
        
        // 创建属性文本
        let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
        imageText.addAttribute(NSFontAttributeName, value: font, range: NSRange(location: 0, length: 1))
        
        return imageText
    }
    
}
