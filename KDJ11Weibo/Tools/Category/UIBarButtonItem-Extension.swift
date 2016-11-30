//
//  UIBarButtonItem-Extension.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/13.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    convenience init(imageName : String) {
        let btn = UIButton()
        btn.setImage(UIImage(named: imageName), forState: .Normal)
        btn.setImage(UIImage(named: imageName + "_highlighted"), forState: .Highlighted)
        btn.sizeToFit()
        
        self.init(customView : btn)
    }
}
