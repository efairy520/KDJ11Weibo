//
//  KDJMessageViewController.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/12.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJMessageViewController: KDJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        visitorView.setupVistorViewInfo("visitordiscover_image_message", title: "登录后，别人评论你的微博，给你发消息，都会在这里收到通知")
    }
}
