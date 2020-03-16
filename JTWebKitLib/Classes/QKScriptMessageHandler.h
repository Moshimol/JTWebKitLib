//
//  QKScriptMessageHandler.h
//  FBSnapshotTestCase
//
//  Created by lushitong on 2020/3/16.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol QKScriptMessageHandlerDelegate <NSObject>

- (void)qkUserContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end


@interface QKScriptMessageHandler : NSObject <WKScriptMessageHandler>

@property (nonatomic, weak) id<QKScriptMessageHandlerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
