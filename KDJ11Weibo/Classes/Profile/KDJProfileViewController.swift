//
//  KDJProfileViewController.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/12.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJProfileViewController: KDJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        visitorView.setupVistorViewInfo("visitordiscover_image_profile", title: "登录后，你的微博、相册、个人资料会显示在这里，展示给别人")
        
    }

}
