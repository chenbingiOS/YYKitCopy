//
//  BCVideoHomeVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/17.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "BCVideoHomeVC.h"

@interface BCVideoHomeVC ()

@end

@implementation BCVideoHomeVC
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addItemTitle:@"视频下载" andClass:@"BCVideoDownloadVC"];
    [self addItemTitle:@"视频播放" andClass:@"BCVideoPlayVC"];
}

- (void)addItemTitle:(NSString *)title andClass:(NSString *)className {
    
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = [class new];
        ctrl.title = title;
        UINavigationController *naC = [[UINavigationController alloc] initWithRootViewController:ctrl];
        [self addChildViewController:naC];
    }
}

@end
