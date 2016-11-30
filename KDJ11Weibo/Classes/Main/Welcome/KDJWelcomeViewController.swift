//
//  KDJWelcomeViewController.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/15.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit
import SDWebImage

class KDJWelcomeViewController: UIViewController {
    
    // MARK:- 拖线的属性
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var iconViewBottomCons: NSLayoutConstraint!

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 0.设置头像
        let profileURLString = KDJUserAccountViewModel.shareInstance.account?.avatar_large
        // ?? : 如果??前面的可选类型有值,那么将前面的可选类型进行解包并且赋值
        // 如果??前面的可选类型为nil,那么直接使用??后面的值
        let url = NSURL(string: profileURLString ?? "")
        iconView.sd_setImageWithURL(url, placeholderImage: UIImage(named: "avatar_default_big"))
        
        // 1.改变约束的值
        iconViewBottomCons.constant = UIScreen.mainScreen().bounds.height - 200
        
        // 2.执行动画
        // Damping : 阻力系数,阻力系数越大,弹动的效果越不明显 0~1
        // initialSpringVelocity : 初始化速度
        UIView.animateWithDuration(1.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5.0, options: [], animations: { 
            self.view.layoutIfNeeded()
            }) { (_) in
                UIApplication.sharedApplication().keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        }
    }
}
