//
//  EmotionViewCell.swift
//  表情键盘
//
//  Created by Kavee DJ on 2016/11/18.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class EmotionViewCell: UICollectionViewCell {
    // MARK:- 懒加载属性
    private lazy var emotionBtn : UIButton = UIButton()
    
    // MARK:- 定义的属性
    var emotion : Emotion? {
        didSet {
            guard let emotion = emotion else {
                return
            }
            
            // 1.设置emotionbtn的内容
            emotionBtn.setImage(UIImage(contentsOfFile: emotion.pngPath ?? ""), forState: .Normal)
            emotionBtn.setTitle(emotion.emojiCode, forState: .Normal)
            
            // 2.设置删除按钮
            if emotion.isRemove {
                emotionBtn.setImage(UIImage(named: "compose_emotion_delete"), forState: .Normal)
            }
        }
    }
    
    // MARK:- 重写构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置UI界面内容
extension EmotionViewCell {
    private func setupUI() {
        // 1.添加子控件
        contentView.addSubview(emotionBtn)
        
        // 2.设置btn的frame
        emotionBtn.frame = contentView.bounds
        
        // 3.设置btn属性
        emotionBtn.userInteractionEnabled = false
        emotionBtn.titleLabel?.font = UIFont.systemFontOfSize(32)
    }
}