//
//  KDJVistorView.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/13.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJVistorView: UIView {
    // MARK:- 提供快速通过xib创建的类方法
    class func visitorView() -> KDJVistorView {
        return NSBundle.mainBundle().loadNibNamed("KDJVistorView", owner: nil, options: nil).first as! KDJVistorView
    }
    
    // MARK:- 控件的属性
    @IBOutlet weak var rotationView: UIImageView!
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    // MARK:- 自定义函数
    func setupVistorViewInfo(iconName : String, title : String) {
        iconView.image = UIImage(named: iconName)
        tipLabel.text = title
        rotationView.hidden = true
    }
    
    func addRotationAnim() {
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        
        // 2.设置动画的属性
        rotationAnim.fromValue = 0;
        rotationAnim.toValue = M_PI * 2
        rotationAnim.repeatCount = MAXFLOAT
        rotationAnim.duration = 5
        rotationAnim.removedOnCompletion = false
        
        // 3.将动画添加到layer中
        rotationView.layer.addAnimation(rotationAnim, forKey: nil)
    }

}
