//
//  MessageViewController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/19.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "写私信", style: UIBarButtonItemStyle.Plain, target: self, action: "composeMsg")
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        // 这个item不能点击(目前放在viewWillAppear就能显示disable下的主题)
        navigationItem.rightBarButtonItem?.enabled = false
        
    }
    func composeMsg(){
        print("composeMsg")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
