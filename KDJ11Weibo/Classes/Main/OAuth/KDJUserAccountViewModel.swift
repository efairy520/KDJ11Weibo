//
//  KDJUserAccountViewModel.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/15.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJUserAccountViewModel {
    
    // MARK:- 将类设计成单例
    static let shareInstance : KDJUserAccountViewModel = KDJUserAccountViewModel()
    
    // MARK:- 定义属性
    var account : KDJUserAccount?
    
    // MARK:- 计算属性
    var accountPath : String {
        let accountPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first!
        return (accountPath as NSString).stringByAppendingPathComponent("account.plist")
    }
    
    var isLogin : Bool {
        if account == nil {
            return false
        }
        
        guard let expiresDate = account?.expires_date else {
            return false
        }
        
        return expiresDate.compare(NSDate()) == NSComparisonResult.OrderedDescending
    }
    
    // MARK:- 重写init()函数
    init () {
        // 1.从沙盒中读取归档的信息
        account = NSKeyedUnarchiver.unarchiveObjectWithFile(accountPath) as? KDJUserAccount
    }

}
