//
//  KDJComposeTitleView.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/16.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit
import SnapKit

class KDJComposeTitleView: UIView {

    // MARK:- 懒加载属性
    private lazy var titleLabel : UILabel = UILabel()
    private lazy var screenNameLabel : UILabel = UILabel()
    
    // MARK:- 构造函数
    override init(frame : CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面
extension KDJComposeTitleView {
    private func setupUI() {
        // 1.将子控件添加到view中
        addSubview(titleLabel)
        addSubview(screenNameLabel)
        
        // 2.设置frame
        titleLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self)
        }
        screenNameLabel.snp_makeConstraints { (make) in
            make.centerX.equalTo(titleLabel.snp_centerX)
            make.top.equalTo(titleLabel.snp_bottom).offset(3)
        }
        
        // 3.设置控件的属性
        titleLabel.font = UIFont.systemFontOfSize(16)
        screenNameLabel.font = UIFont.systemFontOfSize(14)
        screenNameLabel.textColor = UIColor.lightGrayColor()
        
        // 4.设置文字内容
        titleLabel.text = "发微博"
        screenNameLabel.text = KDJUserAccountViewModel.shareInstance.account?.screen_name
    }
}
