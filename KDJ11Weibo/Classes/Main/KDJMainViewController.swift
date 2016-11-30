//
//  KDJMainViewController.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/12.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJMainViewController: UITabBarController {
    
    // MARK:- 懒加载属性
    private lazy var composeBtn : UIButton = UIButton(imageName: "tabbar_compose_icon_add", bgImageName: "tabbar_compose_button")
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupComposeBtn()
    }
}

// MARK:- 设置UI界面
extension KDJMainViewController {
    /// 设置发布按钮
    private func setupComposeBtn() {
        // 1.将composeBtn添加到tabbar中
        tabBar.addSubview(composeBtn)
        
        // 2.设置位置
        composeBtn.center = CGPointMake(tabBar.center.x, tabBar.bounds.size.height * 0.5)
        
        // 3.监听发布按钮的点击
        composeBtn.addTarget(self, action: #selector(KDJMainViewController.composeBtnClick), forControlEvents: .TouchUpInside)
    }
}

// MARK:- 事件监听
extension KDJMainViewController {
    @objc private func composeBtnClick() {
        // 1.创建发布控制器
        let composeVc = KDJComposeViewController()
        
        // 2.包装导航控制器
        let composeNav = UINavigationController(rootViewController: composeVc)
        
        // 3.弹出控制器
        presentViewController(composeNav, animated: true, completion: nil)
    }
}
