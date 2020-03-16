//
//  JTWKWebViewController.h
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/3/16.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "QKScriptMessageHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface JTWKWebViewController : UIViewController <WKUIDelegate, WKNavigationDelegate,QKScriptMessageHandlerDelegate>

// wkwebview
@property (nonatomic, strong) WKWebView *wkWebView;
// WKWebViewConfiguration
@property (nonatomic, strong) WKWebViewConfiguration *webConfig;
//进度条加载
@property (nonatomic, strong) UIProgressView *progressView;
// URL
@property (nonatomic, strong) NSString *url;
// QKScriptMessageHandler
@property (nonatomic, strong) QKScriptMessageHandler *scriptMessageHandler;

// 添加导航栏
- (void)setNavView;

// 加载Html
- (void)loadHtmlWtihURL:(NSString *)url;

// 加载webView
- (void)loadRequest;

// 添加 MessageHandler 协议
- (void)addScriptMessageHandler;

// 删除 MessageHandler 协议在delloc的时候
- (void)removecriptMessageHandler;

// JS 调用 OC的回调方法
- (void)qkWKWebViewUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

// OC 调用 JS 方法
- (void)qkWKWebViewCallEvaluateJavaScriptWithMethodName:(NSString *)methodName jsonString:(NSString *)jsonString;


- (void)dealloc;


@end

NS_ASSUME_NONNULL_END
