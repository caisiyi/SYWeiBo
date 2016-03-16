//
//  HomeViewController.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/2/19.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit
/**
 cell重用标示符
 
 - NormalCell:  原创微博cell
 - ForwardCell: 转发微博cell
 */
enum WBStatusCellIdentifier: String {
    
    case NormalCell  = "NormalCell"
    case ForwardCell = "ForwardCell"
    
    // 根据微博模型返回重用标示符
    static func cellId(status: WBStatus) -> String {
        return (status.retweeted_status == nil) ? NormalCell.rawValue : ForwardCell.rawValue
    }
}
class HomeViewController: UIViewController,WBDropdownMenuDelegate {
    
    let titleButton = WBTitleButton()
    
    var preStatusCount:Int? = nil //上拉加载更多时微博数据的当前数量
    var status:[WBStatus]? {
        didSet{

        
            dispatch_async(dispatch_get_main_queue()) { () -> Void in

           
                
                    self.tableView.reloadData()
                    self.tableView.mj_header.endRefreshing()
                    //若为加载更多微博,则让表格滚动到加载的最新一行
                    if self.tableView.mj_footer.state == MJRefreshState.Refreshing {
                        self.tableView.mj_footer.endRefreshing()
                        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.preStatusCount ?? 0 , inSection: 0 ), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)//让table滚置新增cell
                    }
                    
                
            }
        
        }
    }
    
    lazy var tableView : UITableView = {
        
        var tableView = UITableView()
        
        tableView.frame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height )
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HomeStatusCell")
        // 注册可重用的cell
        tableView.registerClass(WBStatusNormalCell.self, forCellReuseIdentifier: WBStatusCellIdentifier.NormalCell.rawValue)
        tableView.registerClass(WBStatusForwardCell.self, forCellReuseIdentifier: WBStatusCellIdentifier.ForwardCell.rawValue)
        
        // 去掉分割线
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        return tableView
        
    }()
    deinit {
        // 移除所有通知
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    /**
     已经选中了某个图片时的通知方法
     */
    func didSelectedPhotoNotification(notifocation: NSNotification) {
        
        guard let index = notifocation.userInfo?[UICollectionViewCellDidSelectedPhotoIndexKey] as? Int else {
            return
        }
        
        guard let models = notifocation.userInfo?[UICollectionViewCellDidSelectedPhotoUrlsKey] as? [SYPhotoBrowserModel] else {
            return
        }
        // 要modal的控制器
        let controller = SYPhotoBrowserViewController(index: index, models: models)
        
        
        // 设置modal转场代理
        controller.transitioningDelegate = controller
        
        // 设置modal控制器的modal样式
        controller.modalPresentationStyle = UIModalPresentationStyle.Custom
        
        // 图片浏览器
        presentViewController(controller, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
       
        
        setupNav()
        
        tableView.delegate = self
        tableView.dataSource = self

        view.addSubview(tableView)
       
       
        //初始化加拉加载更多控件并设置，加载状态的事件放在闭包中
        let foot = MJRefreshBackNormalFooter { () -> Void in
            self.loadStatus()
        }
        foot.setTitle("上拉加载更多", forState: MJRefreshState.Idle)
        foot.setTitle("释放加载", forState: MJRefreshState.Pulling)
        foot.setTitle("加载中...", forState: MJRefreshState.Refreshing)
        tableView.mj_footer = foot
        tableView.mj_footer.endRefreshing()
        
        //初始化下拉刷新控件并设置，刷新状态的事件放在闭包中
        let head = MJRefreshNormalHeader { () -> Void in
            self.loadStatus()
        }
        head.setTitle("下拉更新", forState: MJRefreshState.Idle)
        head.setTitle("释放更新", forState: MJRefreshState.Pulling)
        head.setTitle("加载中...", forState: MJRefreshState.Refreshing)
        head.lastUpdatedTimeLabel?.hidden = true
        if !WBUserAccount.shareUserAccount.isAuth {
            tableView.emptyDataSetDelegate = self
            tableView.emptyDataSetSource = self
        }else{
        head.beginRefreshing()//视图一出现进入更新加载状态
        }
        tableView.mj_header = head
        
        
        let fpsLabel = YYFPSLabel()
        fpsLabel.sizeToFit()
        fpsLabel.frame.origin = CGPoint(x: 12, y: 80)
        view.addSubview(fpsLabel)

        
        // 注册查看大图的通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didSelectedPhotoNotification:", name: UICollectionViewCellDidSelectedPhotoNotification, object: nil)
        
    }
    func loadStatus(){
        
        var since_id:Int? = nil
        var max_id:Int? = nil
        
        //为上拉加载发起的请求
        if self.tableView.mj_footer.state == MJRefreshState.Refreshing {
            max_id = self.status?.last?.id
        }else{
            since_id = self.status?.first?.id
        }
   
        WBStatus.loadStatus(since_id: since_id,max_id: max_id, finished: { (list, error) -> () in
        
            if list != nil {
                
                if max_id != nil {//获取更多微博数据(上拉加载)
                    self.preStatusCount = self.status?.count
                    if list?.count != 0 {
                        self.status!.insertContentsOf(list!, at: self.status!.count)
                    }else{
                        self.tableView.mj_footer.endRefreshingWithNoMoreData()//显示没有更多微博,设置了则无法继续上拉加载功能
                       
                        //设置2.0秒后可以重新在请求加载
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,Int64(2.0 * Double(NSEC_PER_SEC)) ), dispatch_get_main_queue(), { () -> Void in
                                //需要重新设置状态为闲置状态，才可以再次上拉
                            self.tableView.mj_footer.state = MJRefreshState.Idle
                        })
                    }
                    
                }else{//获取微博数据(下拉刷新)
                    
                let count = list?.count ?? 0
                (self.navigationController as! WBNavigationController).showNewStatusCount(count)
                    
                if  list?.count != 0 {
                    if self.status != nil {//获取更多微博数据（下拉刷新）
                        self.status!.insertContentsOf(list!, at: 0)
                        //此时应当清空tabBar上的未读数量
                        self.tabBarItem.badgeValue = nil
                        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                    }else{//第一次获取微博数据
                        self.status = list
                    }
                }else{
                    self.tableView.mj_header.endRefreshing()
                }
                    
                }
                
            }else{//获取数据失败
                self.tableView.mj_footer.endRefreshing()
                self.tableView.mj_header.endRefreshing()
            }
        })
        
    }
    
    func setupNav(){
        
        /* 设置导航栏上面的内容 */
        navigationItem.leftBarButtonItem = UIBarButtonItem(target: self, action: "friendSearch", image: "navigationbar_friendsearch", highImage: "navigationbar_friendsearch_highlighted")
        navigationItem.rightBarButtonItem = UIBarButtonItem(target: self, action: "pop", image: "navigationbar_icon_radar", highImage: "navigationbar_icon_radar_highlighted")
     
        // 设置图片和文字
        titleButton.setTitle(WBUserAccount.shareUserAccount.name ??  "首页", forState: UIControlState.Normal)
        // 监听标题点击
        titleButton.addTarget(self, action: "titleClick", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
    }
    func titleClick(){
        
              
        // 创建下拉菜单
        let menu = WBDropdownMenu.menu
        menu.delegate = self
        // 设置内
        let vc = HomeTitleMenuViewController()
        vc.view.frame.size.height = 150
        vc.view.frame.size.width = 150
        menu.contentController = vc
        
        // 显示
        menu.showFrom(titleButton)
    }
    func dropdownMenuDidDismiss(menu: UIView) {
        titleButton.selected = false
        print("menuDismiss")
    }
    func dropdownMenuDidShow(menu: UIView) {
        titleButton.selected = true
        print("menuShow")
    }
    func friendSearch(){
        print("friendSearch")
    }
    func pop(){
        print("pop")
    }
    func login(){
        presentViewController(WBNavigationController(rootViewController: WBOAuthViewController()), animated: true, completion: nil)
    }
    override func viewDidAppear(animated: Bool) {
        //添加未登录时候自动跳到授权登录
        if !WBUserAccount.shareUserAccount.isAuth {
            login()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController :UITableViewDataSource,UITableViewDelegate{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    /**
     选中某行cell
     */
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // 取消选中效果
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // 获取当前cell的微博模型
        let status = self.status![indexPath.row]
     
        return status.rowHeight!
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.status?.count ?? 0
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 获取微博模型
        let status = self.status?[indexPath.row]
        
        // 创建可重用的cell
        let cell = tableView.dequeueReusableCellWithIdentifier(WBStatusCellIdentifier.cellId(status!), forIndexPath: indexPath) as! WBStatusCell
        
        cell.delegate = self
        
        // 设置cell数据
        cell.status = status
        
        
        
        return cell
    }
}
extension HomeViewController:WBStatusCellDelegate{
    func ClickMoreBtn(cell: WBStatusCell) {
        let vc = SYAlertViewController(items: ["收藏","帮上头条","取消关注","屏蔽","举报"])
        vc.addItemsAction { (sender) -> () in
          
        }
        vc.addcancelAction { (sender) -> () in
         
        }
        presentViewController(vc, animated: true, completion: nil)
    }
}
extension HomeViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "avatar_default_big")!
    }
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        return
            NSAttributedString(string: "登录", attributes: [NSFontAttributeName:UIFont.systemFontOfSize(17)])
    }

    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        navigationController?.pushViewController(WBOAuthViewController(), animated: true)
    }
  
}