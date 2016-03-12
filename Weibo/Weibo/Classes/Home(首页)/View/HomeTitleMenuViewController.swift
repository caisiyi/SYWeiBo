//
//  HomeTitleMenuViewController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/20.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

class HomeTitleMenuViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let ID = "cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(ID)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID)
        }
        if indexPath.row == 0 {
            cell!.textLabel?.text = "好友"
        } else if indexPath.row == 1 {
            cell!.textLabel?.text = "密友"
        } else if indexPath.row == 2 {
            cell!.textLabel?.text = "全部"
        }
        
        return cell!
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
