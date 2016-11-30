//
//  KDJBaseViewController.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/13.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJBaseViewController: UITableViewController {
    
    // MARK:- 懒加载属性
    lazy var visitorView : KDJVistorView = KDJVistorView.visitorView()
    
    // MARK:- 定义变量
    var isLogin : Bool = KDJUserAccountViewModel.shareInstance.isLogin
    
    // MARK:- 系统回调函数
    override func loadView() {
        // 判断要加载哪一个View
        isLogin ? super.loadView() : setupVisitorView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
    }
}

// MARK:- 设置UI界面
extension KDJBaseViewController {
    /// 设置访客视图
    private func setupVisitorView() {
        view = visitorView
        
        // 监听访客视图中的注册和登录按钮的点击
        visitorView.registerBtn.addTarget(self, action: #selector(KDJBaseViewController.registerBtnClick), forControlEvents: .TouchUpInside)
        visitorView.loginBtn.addTarget(self, action: #selector(KDJBaseViewController.loginBtnClick), forControlEvents: .TouchUpInside)
    }
    
    /// 设置导航栏左右的Item
    private func setupNavigationItems() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "注册", style: .Plain, target: self, action: #selector(KDJBaseViewController.registerBtnClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "登录", style: .Plain, target: self, action: #selector(KDJBaseViewController.loginBtnClick))
    }
}

// MARK:- 事件监听
extension KDJBaseViewController {
    @objc private func registerBtnClick() {
        print("registerBtnClick")
    }
    
    @objc private func loginBtnClick() {
        // 1.床家具呢授权控制器
        let oauthVc = KDJOAuthViewController()
        
        // 2.包装导航栏控制器
        let oauthNav = UINavigationController(rootViewController: oauthVc)
        
        // 3.弹出控制器
        presentViewController(oauthNav, animated: true, completion: nil)
    }
}
