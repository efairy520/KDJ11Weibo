//
//  KDJStatus.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/15.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJStatus: NSObject {
    // MARK:- 属性
    var created_at : String?               // 微博创建时间
    var source : String?                   // 微博来源
    var text : String?                     // 微博的正文
    var mid : Int = 0                      // 微博的ID
    var user : KDJUser?                    // 微博对应的用户
    var pic_urls : [[String : String]]?    // 微博的配图
    var retweeted_status : KDJStatus?         // 微博对应的转发的微博
    
    // MARK:- 自定义构造函数
    init(dict : [String : AnyObject]) {
        super.init()
        
        setValuesForKeysWithDictionary(dict)
        
        // 1.将用户字典转成用户模型对象
        if let userDict = dict["user"] as? [String : AnyObject] {
            user = KDJUser(dict: userDict)
        }
        
        // 2.将转发微博字典转成转发微博模型对象
        if let retweetedStatusDict = dict["retweeted_status"] as? [String : AnyObject] {
            retweeted_status = KDJStatus(dict: retweetedStatusDict)
        }
    }
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
    }

}
