//
//  KDJTitleButton.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/13.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJTitleButton: UIButton {

    // MARK:- 重写init函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setImage(UIImage(named: "navigationbar_arrow_down"), forState: .Normal)
        setImage(UIImage(named: "navigationbar_arrow_up"), forState: .Selected)
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        sizeToFit()
    }
    
    // swift中规定:重写控件的init(frame方法)或者init()方法,必须重写init?(coder aDecoder: NSCoder)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel!.frame.origin.x = 0;
        imageView!.frame.origin.x = titleLabel!.frame.size.width + 5
    }

}
