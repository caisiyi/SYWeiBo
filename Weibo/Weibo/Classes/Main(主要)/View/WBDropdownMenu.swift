//
//  WBDropdownMenu.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/20.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit
@objc
public protocol WBDropdownMenuDelegate{
    optional func dropdownMenuDidDismiss(menu:UIView)
    optional func dropdownMenuDidShow(menu:UIView)
}
class WBDropdownMenu: UIView {
    
    var delegate:WBDropdownMenuDelegate!
    
    // 内容视图
    lazy var content: UIView = UIView()
        
    // 显示具体内容的容器
    lazy var containerView : UIImageView =  {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "popover_background")!.resizableImageWithCapInsets(UIEdgeInsets(top: 10, left: 0, bottom:10, right: 0), resizingMode: UIImageResizingMode.Stretch)//拉伸图片
        imageView.userInteractionEnabled = true// 开启交互
        return imageView
    }()
    //内容控制器
    var contentController:UIViewController? {
        didSet{
            self.content = contentController!.view
            
            // 调整内容的位置
            content.frame.origin.x = 10
            content.frame.origin.y = 15
            
            // 设置灰色的高度
            self.containerView.frame.size.height = CGRectGetMaxY(content.frame) + 11
            // 设置灰色的宽度
            self.containerView.frame.size.width = CGRectGetMaxX(content.frame) + 10
            
            // 添加内容到灰色图片中
            self.containerView.addSubview(content)
            
        }
    }
    
    class var menu : WBDropdownMenu {
        struct Menu {
            static let menu : WBDropdownMenu = WBDropdownMenu()
        }
        return Menu.menu
    }
    
    init() {
        
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        
        self.addSubview(containerView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // 显示
    func showFrom(from:UIView){
        // 1.获得最上面的窗口
        let window = UIApplication.sharedApplication().keyWindow!
        // 2.添加自己到窗口上
        window.addSubview(self)
        
        // 3.设置尺寸
        self.frame = window.bounds
        
        // 4.调整灰色图片的位置
        // 默认情况下，frame是以父控件左上角为坐标原点
        // 转换坐标系
        let newFrame = from.convertRect(from.bounds, toView: window)
        self.containerView.center.x = CGRectGetMidX(newFrame)
        self.containerView.frame.origin.y = CGRectGetMaxY(newFrame)
        
        self.delegate.dropdownMenuDidShow!(self)
    }
    // 销毁
    func dismiss(){
        self.removeFromSuperview()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.dismiss()
        self.delegate.dropdownMenuDidDismiss!(self)
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
