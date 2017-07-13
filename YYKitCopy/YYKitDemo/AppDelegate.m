//
//  AppDelegate.m
//  YYTest
//
//  Created by 陈冰 on 2017/3/19.
//  Copyright © 2017年 GLAC. All rights reserved.
//

#import "AppDelegate.h"

@interface YYExampleNavBar : UINavigationBar

@end
@implementation YYExampleNavBar {
    CGSize _previousSize;
}

//http://www.jianshu.com/p/bdd644b797c3
- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:size];
    if ([UIApplication sharedApplication].statusBarHidden) {
        size.height = 64;
    }
    return size;
}

//http://blog.csdn.net/bsplover/article/details/7977944
- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGSizeEqualToSize(self.bounds.size, _previousSize)) {
        _previousSize = self.bounds.size;
        [self.layer removeAllAnimations];
        [self.layer.sublayers makeObjectsPerformSelector:@selector(removeAllAnimations)];
    }
}

@end

@interface YYExampleNavController : UINavigationController

@end

@implementation YYExampleNavController
//http://www.jianshu.com/p/73be6d0e152f
- (BOOL)shouldAutorotate {
    return YES;
}
// 支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}
// 首选的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // 1.自定义一个栈视图控制器
    YYExampleNavController *exaNC = [[YYExampleNavController alloc] initWithNavigationBarClass:[YYExampleNavBar class] toolbarClass:[UIToolbar class]];
    if ([exaNC respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        exaNC.automaticallyAdjustsScrollViewInsets = NO;
    }
    // 2.根控制器压栈
    YYRootViewController *rootVC = [YYRootViewController new];
    [exaNC pushViewController:rootVC animated:NO];
    
    self.rootViewController = exaNC;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = self.rootViewController;
    self.window.backgroundColor = [UIColor grayColor];
    [self.window makeKeyWindow];

    
//    NSArray *localeIdentifiers = [NSLocale availableLocaleIdentifiers];
//    NSLog(@"%@", localeIdentifiers);
//    
//    NSLog(@"%@", NSLocale.currentLocale.localeIdentifier);
//    
//    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    NSString *str = [locale displayNameForKey:NSLocaleIdentifier value:@"en_AD"];
//    NSLog(@"%@", str);
    
    return YES;
}



@end
