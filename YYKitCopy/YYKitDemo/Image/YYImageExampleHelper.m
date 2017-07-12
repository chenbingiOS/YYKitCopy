//
//  YYImageExampleHelper.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/12.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYImageExampleHelper.h"
#import "YYKit.h"

@implementation YYImageExampleHelper

+ (void)addTapControlToAnimatedImageView:(YYAnimatedImageView *)view {
    if (!view) return;
    
    view.userInteractionEnabled = YES;
    __weak typeof(view) _view = view;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        if ([_view isAnimating]) [_view stopAnimating];
        else [_view startAnimating];
        
        // add a "bounce" animation 添加一个反弹动画
        UIViewAnimationOptions op = UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionBeginFromCurrentState;
        [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
            _view.layer.transformScale = 0.97;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                _view.layer.transformScale = 1.008;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 delay:0 options:op animations:^{
                    _view.layer.transformScale = 1;
                } completion:nil];
            }];
        }];
    }];
    [view addGestureRecognizer:tap];
}

+ (void)addPanControlToAnimatedImageView:(YYAnimatedImageView *)view {
    if (!view) return;
    
    view.userInteractionEnabled = YES;
    __weak typeof(view) _view = view;
    __block BOOL previousIsPlaying;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        UIImage <YYAnimatedImage> *image = (id)_view.image;
        if (![image conformsToProtocol:@protocol(YYAnimatedImage)]) return ;
        
        UIPanGestureRecognizer *gesture = sender;
        CGPoint p = [gesture locationInView:gesture.view];
        CGFloat progress = p.x / gesture.view.width;
        
        if (gesture.state == UIGestureRecognizerStateBegan) {
            previousIsPlaying = [_view isAnimating];
            [_view stopAnimating];
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        } else if (gesture.state == UIGestureRecognizerStateEnded ||
                   gesture.state == UIGestureRecognizerStateCancelled) {
            if (previousIsPlaying) [_view startAnimating];
        } else {
            _view.currentAnimatedImageIndex = image.animatedImageFrameCount * progress;
        }
    }];
    [view addGestureRecognizer:pan];
}
@end
