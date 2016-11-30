//
//  KDJPicPickerViewCell.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/17.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

class KDJPicPickerViewCell: UICollectionViewCell {
    // MARK:- 控件的属性
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var removePhotoBtn: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK:- 定义属性
    var image : UIImage? {
        didSet {
            if image != nil {
                imageView.image = image
                addPhotoBtn.userInteractionEnabled = false
                removePhotoBtn.hidden = false
            } else {
                imageView.image = nil
                addPhotoBtn.userInteractionEnabled = true
                removePhotoBtn.hidden = true
            }
        }
    }

    // MARK:- 事件监听
    @IBAction func addPhotoClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerAddPhotoNote, object: nil)
    }
    
    @IBAction func removePhotoClick() {
        NSNotificationCenter.defaultCenter().postNotificationName(PicPickerRemovePhotoNote, object: imageView.image)
    }

}
