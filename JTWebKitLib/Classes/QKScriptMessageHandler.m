//
//  QKScriptMessageHandler.m
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/3/16.
//

#import "QKScriptMessageHandler.h"

@implementation QKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (self.delegate && [self.delegate respondsToSelector:@selector(qkUserContentController:didReceiveScriptMessage:)]) {
        [self.delegate qkUserContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end
