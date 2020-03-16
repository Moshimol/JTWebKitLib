//
//  JTWebMacro.h
//  Pods
//
//  Created by lushitong on 2020/3/16.
//

#ifndef JTWebMacro_h
#define JTWebMacro_h


// 宏的相关定义文件

// 屏幕宽高的定义
#define JTWebScreenWidth     ([UIScreen mainScreen].bounds.size.width)
#define JTWebScreenHeight    ([UIScreen mainScreen].bounds.size.height)

#define JTWEBIPHONE_X \
({BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(isPhoneX);})

#define JTWebNavigationBarHeight (JTWEBIPHONE_X ? 88.0 : 64.0)

// 打印相关
#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


#endif /* JTWebMacro_h */
