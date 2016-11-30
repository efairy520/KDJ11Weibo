//
//  KDJComposeTextView.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/16.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit
import SnapKit

class KDJComposeTextView: UITextView {
    // MARK:- 懒加载属性
    lazy var placeHolderLabel : UILabel = UILabel()
    
    // MARK:- 构造函数
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
}

// MARK:- 设置UI界面
extension KDJComposeTextView {
    private func setupUI() {
        // 1.添加子控件
        addSubview(placeHolderLabel)
        
        // 2.设置frame
        placeHolderLabel.snp_makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
        }
        
        // 3.设置placeholderLabel属性
        placeHolderLabel.textColor = UIColor.lightGrayColor()
        placeHolderLabel.font = font
        
        // 4.设置placeholderLabel文字
        placeHolderLabel.text = "分享新鲜事..."
        
        // 5.设置内容的内边距
        textContainerInset = UIEdgeInsets(top: 6, left: 7, bottom: 0, right: 7)
    }
}
