//
//  DiscoverViewController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/19.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // 创建搜索框对象
        let searchBar = WBSearchBar()
        searchBar.frame.size.height = 30
        searchBar.frame.size.width = 300
        
        navigationItem.titleView = searchBar
        
        
        
     
        
        // Do any additional setup after loading the view.
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
