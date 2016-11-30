//
//  KDJOAuthViewController.swift
//  KDJ11Weibo
//
//  Created by Kavee DJ on 2016/11/14.
//  Copyright © 2016年 Kavee DJ. All rights reserved.
//

import UIKit
import SVProgressHUD

class KDJOAuthViewController: UIViewController {
    // MARK:- 控件的属性
    @IBOutlet weak var webView: UIWebView!
    
    // MARK:- 系统回调函数
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self
        
        // 1.设置导航栏的内容
        setupNavigationBar()
        
        // 2.加载网页
        loadPage()
    }
}

// MARK:- 设置UI界面相关
extension KDJOAuthViewController {
    private func setupNavigationBar() {
        // 1.设置左侧的item
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "关闭", style: .Plain, target: self, action: #selector(KDJOAuthViewController.closeItemClick))
        
        // 2.设置右侧的item
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "填充", style: .Plain, target: self, action: #selector(KDJOAuthViewController.fillItemClick))
        
        // 3.设置标题
        title = "登录页面"
    }
    
    private func loadPage() {
        // 1.获取登录页面的URLString
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(app_key)&redirect_uri=\(redirect_uri)"
        
        // 2.创建对应NSURL
        guard let url = NSURL(string: urlString) else {
            return
        }
        
        // 3.创建NSURLRequest对象
        let request = NSURLRequest(URL: url)
        
        // 4.加载request对象
        webView.loadRequest(request)
    }
}

// MARK:- 事件监听函数
extension KDJOAuthViewController {
    @objc private func closeItemClick() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func fillItemClick() {
        // 1.书写js代码 : javascript / java --> 雷锋和雷峰塔
        let jsCode = "document.getElementById('userId').value='ef520q';document.getElementById('passwd').value='ym8';"
        
        // 2.执行js代码
        webView.stringByEvaluatingJavaScriptFromString(jsCode)
    }
}

// MARK:- webView的delegate方法
extension KDJOAuthViewController : UIWebViewDelegate {
    // webView开始加载网页
    func webViewDidStartLoad(webView: UIWebView) {
        SVProgressHUD.show()
    }
    
    // webView网页加载完成
    func webViewDidFinishLoad(webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    // webView加载网页失败
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        SVProgressHUD.dismiss()
    }
    
    // 当准备加载某一个页面时,会执行该方法
    // 返回值: true -> 继续加载该页面 false -> 不会加载该页面
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        // 1.获取加载网页的NSURL
        guard let url = request.URL else {
            return true
        }
        
        // 2.获取url中的字符串
        let urlString = url.absoluteString
        
        // 3.判断该字符串中是否包含code
        guard urlString.containsString("code=") else {
            return true
        }
        
        // 4.将code接取出来
        let code = urlString.componentsSeparatedByString("code=").last!
        
        // 5.请求accessToken
        loadAccessToken(code)
        
        return false
    }
}

// MARK:- 请求数据
extension KDJOAuthViewController {
    private func loadAccessToken(code : String) {
        KDJNetworkTools.shareInstance.loadAccessToken(code) { (result, error) -> () in
            // 1.错误校验
            if error != nil {
                print(error)
                return
            }
            
            // 2.拿到结果
            guard let accountDict = result else {
                print("没有获取授权后的数据")
                return
            }
            
            // 3.将字典转成模型对象
            let account = KDJUserAccount(dict: accountDict)
            
            // 4.请求用户信息
            self.loadUserInfo(account)
        }
    }
    
    /// 请求用户信息
    private func loadUserInfo(account : KDJUserAccount) {
        // 1.获取AccessToken
        guard let accessToken = account.access_token else {
            return
        }
        
        // 2.获取uid
        guard let uid = account.uid else {
            return
        }
        
        // 3.发送网络请求
        KDJNetworkTools.shareInstance.loadUserInfo(accessToken, uid: uid) { (result, error) -> () in
            // 1.错误校验
            if error != nil {
                print(error)
                return
            }
            
            // 2.拿到用户信息的结果
            guard let userInfoDict = result else {
                return
            }
            
            // 3.从字典中取出昵称和用户头像地址
            account.screen_name = userInfoDict["screen_name"] as? String
            account.avatar_large = userInfoDict["avatar_large"] as? String
            
            // 4.将account对象保存
            NSKeyedArchiver.archiveRootObject(account, toFile: KDJUserAccountViewModel.shareInstance.accountPath)
            
            // 5.将account对象设置到单例对象中
            KDJUserAccountViewModel.shareInstance.account = account
            
            // 6.退出当前控制器
            self.dismissViewControllerAnimated(false, completion: { 
                UIApplication.sharedApplication().keyWindow?.rootViewController = KDJWelcomeViewController()
            })
        }
    }
}
