//
//  WBStatusManager.swift
//  Weibo
//
//  Created by 蔡斯仪 on 16/3/16.
//  Copyright © 2016年 caisiyi. All rights reserved.
//

import UIKit

typealias WBStatusManagerFinishedBack = (result: [WBStatus]?) -> ()

public class WBStatusManager {
  
    //数据库文件路径
    var paths:String  {
        get{
            //获取根目录
            let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as NSArray
            //获取Document目录
            let document = paths.objectAtIndex(0)
            //拼接上数据库文件名
            let path = document.stringByAppendingPathComponent("WeiboStatus.sqlite")
            return path
        }
        
    }
    private func searchTable(){
        //文件管理
        let fileManager = NSFileManager.defaultManager()
        //判断文件名是否存在,若数据库文件不存在,则创建
        if(!fileManager.fileExistsAtPath(self.paths)){
            //创建空文件
            fileManager.createFileAtPath(self.paths, contents: nil, attributes: nil)
            //根据文件路径拿到数据库,进行操作
            let db = FMDatabase(path: self.paths)
            //打开数据库
            if(db.open()){
                //注:存放字典型数据通常用binary
                //创建表的sql语句
                let sql = "create table 'Status'('id' integer primary key autoincrement not null,'statusId' integer,'data'  binary)"
                //执行sql语句
                let success =  db.executeUpdate(sql, withParameterDictionary: nil) as Bool
                if(!success){
                    //print("创建表失败")
                }else{
                    //print("创建表成功")
                }
                db.close()
            }else{
                //print("数据库打开失败")
            }
        }
        
        
    }
    static let shareManager = WBStatusManager()
    
    func loadStatus(since_id since_id: Int? = nil, max_id: Int? = nil ,finished: WBStatusManagerFinishedBack) {
        
        if since_id != nil && max_id != nil {
            finished(result:  nil)
            return
        }
        if since_id == nil && max_id == nil {
            if let status = getStatus(){
                print("初始加载-有缓存")
                finished(result: status)
            }else{
                WBStatus.loadStatus(since_id: nil, max_id: nil, finished: { (list, error) -> () in
                    if list != nil {
                        print("初始加载-无缓存")
                        self.saveData(list!)
                        finished(result: list)
                    }
                })
            }
        }
        if since_id != nil {
            print("请求最新")
            WBStatus.loadStatus(since_id: since_id, max_id: nil, finished: { (list, error) -> () in
                if list != nil {
                    self.saveData(list!)
                    finished(result: list)
                        
                }
            })
        }
        if max_id != nil {
            print("请求更多")
            if let status = serachStatus(max_id!){
                print("请求更多-有缓存")
                finished(result: status)
            }else{
                WBStatus.loadStatus(since_id: nil, max_id: max_id, finished: { (list, error) -> () in
                    if list != nil {
                        print("请求更多-无缓存")
                        self.saveData(list!)
                        finished(result: list)
                        
                    }
                })
            }
        }
        
     
      
    }
    private func serachStatus(max_id:Int) -> [WBStatus]?{
        
        searchTable()//搜索数据库中是否存在所需要的表,若不存在则创建
        
        let db = FMDatabase(path: self.paths as String)
        //创建一个模型数据数组
        var status:[WBStatus] = []
        if(db.open()){
            //搜索表数据的sql语句
            let sql = "Select data From Status where  statusId <\(max_id)  Order By statusId DESC Limit 20"
            let rs = db.executeQuery(sql, withArgumentsInArray: nil)
            
            while(rs.next()){
                //获取每条表数据对应字段数据
                //let id = rs.intForColumn("statusId")
                let data = rs.dataForColumn("data")
                if data != nil {
              
                    let jsondata = data.mj_JSONObject()
                    status.append(WBStatus(dict: jsondata as! [String : AnyObject]))
                  
                }
                
            }
            
            db.close()
            
        }
        return status.count != 0 ? status : nil
    }
    
    private func getStatus() -> [WBStatus]?{
        
        searchTable()//搜索数据库中是否存在所需要的表,若不存在则创建
        
        let db = FMDatabase(path: self.paths as String)
        //创建一个模型数据数组
        var status:[WBStatus] = []
        if(db.open()){
            //搜索表数据的sql语句
            let sql = "Select data From Status Order By statusId DESC Limit 20"
            let rs = db.executeQuery(sql, withArgumentsInArray: nil)
            
            while(rs.next()){
                //获取每条表数据对应字段数据
                //let id = rs.intForColumn("statusId")
                let data = rs.dataForColumn("data")
                if data != nil {
                        let jsondata = data.mj_JSONObject()
                        status.append(WBStatus(dict: jsondata as! [String : AnyObject]))
                }
                
            }
            
            db.close()
            
        }
        return status.count != 0 ? status : nil
    }
    
    private func saveData(status:[WBStatus]?){
        
        searchTable()//搜索数据库中是否存在所需要的表,若不存在则创建
        if let status = status {
        let db = FMDatabase(path: self.paths)
        if(db.open()){
            //插入数据到表中的sql语句
            let sql = "insert into Status (statusId,data) values (?,?)"
            do {
                //编辑Weather对象模型数组weather,拿到每一个要保持的weather
                try status.forEach({ (statu) -> () in
                    WBStatus.mj_setupIgnoredPropertyNames({ () -> [AnyObject]! in
                        return ["created_time","attributedText","forwardAttributedText","largePictureURLs","pictureURLs"]
                    })
                    let jsonData = statu.mj_keyValues().mj_JSONData()
                    //执行插入语句,将对应的模型字段变成数组values传入
                    try  db.executeUpdate(sql, values: [statu.id,jsonData])
                })
            }catch{
                print("存储数据失败")
            }
            //关闭数据库
            db.close()
            
        }else{
            print("数据库打开失败")
        }
        }
    }
}
