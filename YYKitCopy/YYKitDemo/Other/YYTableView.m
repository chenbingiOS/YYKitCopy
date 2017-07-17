//
//  YYTableView.m
//  YYKitExample
//
//  Created by ibireme on 15/9/7.
//  Copyright (c) 2015 ibireme. All rights reserved.
//

#import "YYTableView.h"

@implementation YYTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // iOS 系统会在 UITableView 中添加一个手势，导致所有作用在 TableView 上的触摸事件都有大概 0.3 秒的延迟
    // Remove touch delay (since iOS 8)
    UIView *wrapView = self.subviews.firstObject;
    // UITableViewWrapperView
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            // UIScrollViewDelayedTouchesBeganGestureRecognizer
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) {
                gesture.enabled = NO;
                break;
            }
        }
    }
    
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
