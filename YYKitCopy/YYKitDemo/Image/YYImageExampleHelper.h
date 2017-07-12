//
//  YYImageExampleHelper.h
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/12.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YYAnimatedImageView;
@interface YYImageExampleHelper : NSObject

/*
 Tap to play/pause
 点击一下播放/暂停
 */
+ (void)addTapControlToAnimatedImageView:(YYAnimatedImageView *)view;
/*
 Slide to forward/rewind
 动画前进/后退
 */
+ (void)addPanControlToAnimatedImageView:(YYAnimatedImageView *)view;

@end
