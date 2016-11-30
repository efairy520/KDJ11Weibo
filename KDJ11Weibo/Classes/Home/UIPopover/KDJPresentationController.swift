//
//  KDJPresentationController.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/14.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJPresentationController: UIPresentationController {
    // MARK:- 对外提供属性
    var presentedFrame : CGRect = CGRectZero
    
    // MARK:- 懒加载属性
    private lazy var coverView : UIView = UIView()
    
    // MARK:- 系统回调函数
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        
        // 1.设置弹出View的尺寸
        presentedView()?.frame = presentedFrame
        
        // 2.添加蒙版
        setupCoverView()
    }

}

// MARK:- 设置UI界面相关
extension KDJPresentationController {
    private func setupCoverView() {
        // 1.添加蒙版
        containerView?.insertSubview(coverView, atIndex: 0)
        
        // 2.设置蒙版的属性
        coverView.backgroundColor = UIColor(white: 0.8, alpha: 0.2)
        coverView.frame = containerView!.bounds
        
        // 3.添加手势
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(KDJPresentationController.coverViewClick))
        coverView.addGestureRecognizer(tapGes)
    }
}

// MARK:- 时间监听
extension KDJPresentationController {
    @objc private func coverViewClick () {
        presentedViewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
