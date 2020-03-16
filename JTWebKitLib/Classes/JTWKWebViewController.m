//
//  JTWKWebViewController.m
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/3/16.
//

#import "JTWKWebViewController.h"
#import "JTWebKit.h"

#define NavTitleLoading     @"加载中..."

@interface JTWKWebViewController ()

@end

@implementation JTWKWebViewController

#pragma mark – Public Methods

- (void)loadHtmlWtihURL:(NSString *)url {
    self.url = url;
}

#pragma mark – Override

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.wkWebView];

    self.wkWebView.userInteractionEnabled = YES;
    
    [self setNavView];
    [self loadRequest];
    
    [self addScriptMessageHandler];
}

- (void)dealloc {
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView removeObserver:self forKeyPath:@"title"];
    [self removecriptMessageHandler];
}

#pragma mark – Private Methods

// JS调用OC
- (void)qkWKWebViewUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

// OC调用JS
- (void)qkWKWebViewCallEvaluateJavaScriptWithMethodName:(NSString *)methodName jsonString:(NSString *)jsonString {
    NSString *inputValueJS;
    if (jsonString.length == 0 || !jsonString) {
        inputValueJS =  [NSString stringWithFormat:@"%@()",methodName];
    }else {
        inputValueJS = [NSString stringWithFormat:@"%@('%@')",methodName,jsonString];
    }
    
    // OC调用JS
    [self.wkWebView evaluateJavaScript:inputValueJS completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        DLog(@"value: %@ error: %@", response, error);
    }];
}

- (void)addScriptMessageHandler {
    [self.webConfig.userContentController addScriptMessageHandler:self.scriptMessageHandler name:@"qkMessageHandler"];
}

- (void)removecriptMessageHandler {
    [self.webConfig.userContentController removeScriptMessageHandlerForName:@"qkMessageHandler"];
}

- (void)setNavView {
    
    if (@available(iOS 11.0, *)) {
        self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

- (void)loadRequest {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.url]];
    [self.wkWebView loadRequest:request];
}

#pragma mark – 监听进度相关

// 进度
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.wkWebView) {
            [self.progressView setAlpha:1.0f];
            [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
            if(self.wkWebView.estimatedProgress >= 1.0f) {
                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    [self.progressView setAlpha:0.0f];
                } completion:^(BOOL finished) {
                    [self.progressView setProgress:0.0f animated:NO];
                }];
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.wkWebView) {
            DLog(@"%@",self.wkWebView.title)
            if ([self.title isEqualToString:NavTitleLoading]) {
                // [self p_setTopTitleDetail:@{Nav_Title:self.wkWebView.title}.mutableCopy];
                self.title = self.wkWebView.title;
            }
            
            if ((self.title.length == 0 || !self.title) &&  self.wkWebView.title.length > 0) {
                //[self p_setTopTitleDetail:@{Nav_Title:self.wkWebView.title}.mutableCopy];
                self.title = self.wkWebView.title;
            }
        } else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(void (^)(void))completionHandler {

    DLog(@"-------web界面中有弹出警告框时调用");
}

// 确认框
//JavaScript调用confirm方法后回调的方法 confirm是js中的确定框，需要在block中把用户选择的情况传递进去
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    
    DLog(@"-------web确认框");

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 关闭webView时调用的方法
- (void)webViewDidClose:(WKWebView *)webView {

    DLog(@"----关闭webView时调用的方法");
}

#pragma mark - WKNavigationDelegate

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    DLog(@"1-------在发送请求之前，决定是否跳转  -->%@",navigationAction.request);

    decisionHandler(WKNavigationActionPolicyAllow);
}

// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
    DLog(@"2-------页面开始加载时调用");
}

// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    /// 在收到服务器的响应头，根据response相关信息，决定是否跳转。decisionHandler必须调用，来决定是否跳转，参数WKNavigationActionPolicyCancel取消跳转，WKNavigationActionPolicyAllow允许跳转

    DLog(@"3-------在收到响应后，决定是否跳转");
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
    DLog(@"4-------当内容开始返回时调用");
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
   
    DLog(@"5-------页面加载完成之后调用");
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {

   
    DLog(@"6-------页面加载失败时调用");
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
    DLog(@"-------接收到服务器跳转请求之后调用");
}

// 数据加载发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
    DLog(@"----数据加载发生错误时调用");
}

#pragma mark - QKScriptMessageHandlerDelegate

- (void)qkUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    //    DLog(@"%@",message.body);
    //    DLog(@"%@",message.name);
    [self qkWKWebViewUserContentController:userContentController didReceiveScriptMessage:message];
}

#pragma mark - Lazy Property
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, JTWebNavigationBarHeight, JTWebScreenWidth, JTWebScreenHeight - JTWebNavigationBarHeight) configuration:self.webConfig];
        _wkWebView.backgroundColor = [UIColor redColor];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        _wkWebView.backgroundColor = [UIColor whiteColor];
        
        // 进度
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
        // title
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return _wkWebView;
}

- (WKWebViewConfiguration *)webConfig {
    if (!_webConfig) {
        _webConfig = [[WKWebViewConfiguration alloc] init];
        // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
        _webConfig.allowsInlineMediaPlayback = YES;
        //设置是否允许画中画技术 在特定设备上有效
        if (@available(iOS 9.0, *)) {
            _webConfig.allowsPictureInPictureMediaPlayback = YES;
        }
        WKUserContentController *userContentViewController = [[WKUserContentController alloc] init];
        _webConfig.userContentController = userContentViewController;
    }
    return _webConfig;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
           _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, JTWebNavigationBarHeight, JTWebScreenWidth, 1.0)];
           _progressView.progress = 0;
           //进度条 完成的颜色
           _progressView.progressTintColor = [UIColor redColor];
            //进度条 未完成的颜色
           _progressView.trackTintColor = [UIColor grayColor];
       }
       return _progressView;
}

- (QKScriptMessageHandler *)scriptMessageHandler {
    if (!_scriptMessageHandler) {
        _scriptMessageHandler = [[QKScriptMessageHandler alloc] init];
        _scriptMessageHandler.delegate = self;
    }
    return _scriptMessageHandler;
}

@end
