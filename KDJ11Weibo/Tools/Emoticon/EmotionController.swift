//
//  EmotionController.swift
//  表情键盘
//
//  Created by Kavee DJ on 2016/11/18.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit

private let EmotionCell = "EmotionCell"

class EmotionController: UIViewController {
    
    // MARK:- 定义属性
    var emotionCallBack : (emotion : Emotion) -> ()
    
    // MARK:- 懒加载属性
    private lazy var collectionView : UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EmotionCollectionViewLayout())
    private lazy var toolBar : UIToolbar = UIToolbar()
    private lazy var manager = EmoticonManager()
    
    // MARK:- 自定义构造函数
    init (emotionCallBack : (emotion : Emotion) -> ()) {
        self.emotionCallBack = emotionCallBack
        super.init(nibName :nil, bundle : nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
}

// MARK:- 设置UI界面内容
extension EmotionController {
    private func setupUI() {
        // 1.添加子控件
        view.addSubview(collectionView)
        view.addSubview(toolBar)
        collectionView.backgroundColor = UIColor.purpleColor()
        toolBar.backgroundColor = UIColor.darkGrayColor()
        
        // 2.设置子控件的frame
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        let views = ["tBar" : toolBar, "cView" : collectionView]
        var cons = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[tBar]-0-|", options: [], metrics: nil, views: views)
        cons += NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[cView]-0-[tBar]-0-|", options: [.AlignAllLeft, .AlignAllRight], metrics: nil, views: views)
        view.addConstraints(cons)
        
        // 3.准备collectionView
        prepareForCollectionView()
        
        // 4.准备toolBar
        prepareForToolBar()
        
    }
    
    private func prepareForCollectionView() {
        collectionView.registerClass(EmotionViewCell.self, forCellWithReuseIdentifier: EmotionCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func prepareForToolBar() {
        // 1.定义toolBar中titles
        let titles = ["最近", "默认", "emoji", "浪小花"]
        
        // 2.遍历标题，创建item
        var index = 0
        var tempItems = [UIBarButtonItem]()
        for title in titles {
            let item = UIBarButtonItem(title: title, style: .Plain, target: self, action: #selector(EmotionController.itemClick(_:)))
            item.tag = index
            index += 1
            
            tempItems.append(item)
            tempItems.append(UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil))
        }
        
        // 3.设置toolBar的items数组
        tempItems.removeLast()
        toolBar.items = tempItems
        toolBar.tintColor = UIColor.orangeColor()
    }
    
    @objc private func itemClick(item : UIBarButtonItem) {
        // 1.获取点击的item的tag
        let tag = item.tag
        
        // 2.根据tag获取到当前组
        let indexPath = NSIndexPath(forItem: 0, inSection: tag)
        
        // 3.滚动到对应的位置
        collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: .Left, animated: true)
    }
}

extension EmotionController : UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return manager.packages.count
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let package = manager.packages[section]
        return package.emotions.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // 1.创建cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(EmotionCell, forIndexPath: indexPath) as! EmotionViewCell
        
        // 2.给cell设置数据
        let package = manager.packages[indexPath.section]
        let emotion = package.emotions[indexPath.item]
        cell.emotion = emotion
        
        return cell
    }
    
    /// 代理方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // 1.取出点击的表情
        let package = manager.packages[indexPath.section]
        let emotion = package.emotions[indexPath.item]
        
        // 2.将点击的表情插入到最近分组中
        insertRecentlyEmoticon(emotion)
        
        // 3.将表情回调给外界控制器
        emotionCallBack(emotion: emotion)
    }
    
    private func insertRecentlyEmoticon(emotion : Emotion) {
        // 1.如果是空白表情或者删除按钮，不需要插入
        if emotion.isRemove || emotion.isEmpty {
            return
        }
        
        // 2.删除一个表情
        if manager.packages.first!.emotions.contains(emotion) { // 原来有该表情
            let index = (manager.packages.first?.emotions.indexOf(emotion))!
            manager.packages.first?.emotions.removeAtIndex(index)
        } else { // 原来没有这个表情
            manager.packages.first?.emotions.removeAtIndex(19)
        }
        
        // 3.将emoticon插入最近分组中
        manager.packages.first?.emotions.insert(emotion, atIndex: 0)
    }
}

class EmotionCollectionViewLayout : UICollectionViewFlowLayout {
    override func prepareLayout() {
        super.prepareLayout()
        
        // 1.计算itemWH
        let itemWH = UIScreen.mainScreen().bounds.width / 7
        
        // 2.设置layout的属性
        itemSize = CGSize(width: itemWH, height: itemWH)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        scrollDirection = .Horizontal
        
        // 3.设置collectionView的属性
        collectionView?.pagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.showsVerticalScrollIndicator = false
        let insetMargin = (collectionView!.bounds.height - 3 * itemWH) / 2
        collectionView?.contentInset = UIEdgeInsets(top: insetMargin, left: 0, bottom: insetMargin, right: 0)
    }
}
