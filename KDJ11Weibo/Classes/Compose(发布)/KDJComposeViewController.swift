//
//  KDJComposeViewController.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/16.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit
import SVProgressHUD

class KDJComposeViewController: UIViewController {
    // MARK:- 控件属性
    @IBOutlet weak var textView: KDJComposeTextView!
    @IBOutlet weak var picPickerView: KDJPicPickerCollectionView!
    
    // MARK:- 懒加载属性
    private lazy var titleView : KDJComposeTitleView = KDJComposeTitleView()
    private lazy var images : [UIImage] = [UIImage]()
    private lazy var emotionVc : EmotionController = EmotionController {[weak self] (emotion) -> () in
        self?.textView.insertEmotion(emotion)
        self?.textViewDidChange(self!.textView)
    }
    
    // MARK:- 约束的属性
    @IBOutlet weak var toolBarBottomCons: NSLayoutConstraint!
    @IBOutlet weak var picPickerViewHCons: NSLayoutConstraint!

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // 设置导航栏
        setupNavigationBar()
        
        // 监听通知
        setupNotifications()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        textView.becomeFirstResponder()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}

// MARK:- 设置UI界面
extension KDJComposeViewController {
    private func setupNavigationBar() {
        // 1.设置左右的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(KDJComposeViewController.closeItemClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "发送", style: .Plain, target: self, action: #selector(KDJComposeViewController.sendItemClick))
        navigationItem.rightBarButtonItem?.enabled = false
        
        // 2.设置标题
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        navigationItem.titleView = titleView
    }
    
    private func setupNotifications() {
        // 监听键盘的弹出
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KDJComposeViewController.keyboardWillChangeFrame(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // 监听添加照片的按钮的点击
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KDJComposeViewController.addPhotoClick), name: PicPickerAddPhotoNote, object: nil)
        
        // 监听删除照片的按钮的点击
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(KDJComposeViewController.removePhotoClick(_:)), name: PicPickerRemovePhotoNote, object: nil)
    }
}

// MARK:- 事件监听函数
extension KDJComposeViewController {
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func sendItemClick() {
        // 0.键盘退出
        textView.resignFirstResponder()
        
        // 1.获取发送微博的微博正文
        let statusText = textView.getEmoticonString()
        
        // 2.定义回调的闭包
        let finishedCallBack = { (isSuccess : Bool) -> () in
            if !isSuccess {
                SVProgressHUD.showErrorWithStatus("发送微博失败")
                return
            }
            SVProgressHUD.showSuccessWithStatus("发送微博成功")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        // 3.获取用户选中的图片
        if let image = images.first {
            KDJNetworkTools.shareInstance.sendStatus(statusText, image: image, isSuccess: finishedCallBack)
        } else {
            KDJNetworkTools.shareInstance.sendStatus(statusText, isSuccess: finishedCallBack)
        }
    }
    
    @objc private func keyboardWillChangeFrame(note : NSNotification) {
        // 1.获取动画执行的时间
        let duration = note.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSTimeInterval
        
        // 2.获取键盘最终Y值
        let endFrame = (note.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let y = endFrame.origin.y
        
        // 3.计算工具栏距离底部的间距
        let margin = UIScreen.mainScreen().bounds.height - y
        
        // 4.执行动画
        toolBarBottomCons.constant = margin
        UIView.animateWithDuration(duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func picPickerBtnClick() {
        // 退出键盘
        textView.resignFirstResponder()
        
        // 执行动画
        picPickerViewHCons.constant = UIScreen.mainScreen().bounds.height * 0.65
        UIView.animateWithDuration(0.5) { 
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func emotionBtnClick() {
        // 1.退出键盘
        textView.resignFirstResponder()
        
        // 2.切换键盘
        textView.inputView = textView.inputView != nil ? nil : emotionVc.view
        
        // 3.弹出键盘
        textView.becomeFirstResponder()
    }
}

// MARK:- 添加照片和删除照片的事件
extension KDJComposeViewController {
    @objc private func addPhotoClick() {
        // 1.判断数据源是否可用
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            return
        }
        
        // 2.创建照片选择控制器
        let ipc = UIImagePickerController()
        
        // 3.设置照片源
        ipc.sourceType = .PhotoLibrary
        
        // 4.设置代理
        ipc.delegate = self
        
        // 弹出选择照片额控制器
        presentViewController(ipc, animated: true, completion: nil)
    }
    
    @objc private func removePhotoClick(note : NSNotification) {
        // 1.获取image对象
        guard let image = note.object as? UIImage else {
            return
        }
        
        // 2.获取image对象所在下标值
        guard let index = images.indexOf(image) else {
            return
        }
        
        // 3.将图片从数组中删除
        images.removeAtIndex(index)
        
        // 4.重写赋值collectionView新的数组
        picPickerView.images = images
    }
}

// MARK:- UIImagePickerController的代理方法
extension KDJComposeViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // 1.获取选中的照片
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        // 2.将选中的照片添加到数组中
        images.append(image)
        
        // 3.将数组赋值给collectionView, 让collectionView自己去展示数据
        picPickerView.images = images
        
        // 4.退出选中照片控制器
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK:- UITextView的代理方法
extension KDJComposeViewController : UITextViewDelegate {
    func textViewDidChange(textView: UITextView) {
        self.textView.placeHolderLabel.hidden = textView.hasText()
        navigationItem.rightBarButtonItem?.enabled = textView.hasText()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        textView.resignFirstResponder()
    }
}
