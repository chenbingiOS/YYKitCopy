//
//  BCPopHelper.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/17.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "BCPopHelper.h"

static NSTimeInterval const kFadeInAnimationDuration = 0.7;
static NSTimeInterval const kTransformPart1AnimationDuration = 0.3;
static NSTimeInterval const kTransformPart2AnimationDuration = 0.4;
static CGFloat const kDefaultCloseButtonPadding = 17.0f;

/** 遮罩 */
@interface BCShadowView : UIView
@end

@implementation BCShadowView

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([BCPopHelper sharedInstance].shadeBackgroundType == ShadeBackgroundTypeSolid) {
        [[UIColor colorWithWhite:0 alpha:0.55] set];
        CGContextFillRect(context, self.bounds);
    } else {
        CGContextSaveGState(context);
        size_t gradLocationsNum = 2;
        CGFloat gradLocations[2] = {0.0f, 1.0f};
        CGFloat gradColors[8] = {0, 0, 0, 0.3, 0, 0, 0, 0.8};
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
        CGColorSpaceRelease(colorSpace), colorSpace = NULL;
        CGPoint gradCenter= CGPointMake(round(CGRectGetMidX(self.bounds)), round(CGRectGetMidY(self.bounds)));
        CGFloat gradRadius = MAX(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        CGContextDrawRadialGradient(context, gradient, gradCenter, 0, gradCenter, gradRadius, kCGGradientDrawsAfterEndLocation);
        CGGradientRelease(gradient), gradient = NULL;
        CGContextRestoreGState(context);
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if ([BCPopHelper sharedInstance].tapOutsideToDismiss) {
        [[BCPopHelper sharedInstance] hideAnimated:YES withCompletionBlock:nil];
    }
}

@end

/** 容器视图控制器  */
@interface BCContentVC : UIViewController
@property (weak, nonatomic) BCShadowView *shadowView;
@end

@implementation BCContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    BCShadowView *shadowView = [[BCShadowView alloc] initWithFrame:self.view.bounds];
    shadowView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    shadowView.opaque = NO;
    [self.view addSubview:shadowView];
    self.shadowView = shadowView;
}

@end

/** 容器视图 */
@interface BCContentVidw : UIView
@property (weak, nonatomic) CALayer *styleLayer;
@property (strong, nonatomic) UIColor *popBackgroundColor;
@end

@implementation BCContentVidw

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (!self) {
        CALayer *styleLayer = [[CALayer alloc] init];
        styleLayer.cornerRadius = 4;
        styleLayer.shadowColor= [[UIColor whiteColor] CGColor];
        styleLayer.shadowOffset = CGSizeMake(0, 0);
        styleLayer.shadowOpacity = 0.5;
        styleLayer.borderWidth = 1;
        styleLayer.borderColor = [[UIColor whiteColor] CGColor];
        styleLayer.frame = CGRectInset(self.bounds, 12, 12);
        [self.layer addSublayer:styleLayer];
        self.styleLayer = styleLayer;
        
    }
    return self;
}

- (void)setPopBackgroundColor:(UIColor *)popBackgroundColor {
    if(_popBackgroundColor != popBackgroundColor){
        _popBackgroundColor = popBackgroundColor;
        self.styleLayer.backgroundColor = [popBackgroundColor CGColor];
    }
}

@end

/** 关闭按钮 */
@interface BCCloseBtn : UIButton
@end

@implementation BCCloseBtn

- (instancetype)init {
    self = [super initWithFrame:(CGRect){0, 0, 32, 32}];
    if (self) {
        [self setBackgroundImage:[UIImage imageNamed:@"red_packge_close"] forState:UIControlStateNormal];
    }
    return self;
}

@end

@interface BCPopHelper ()
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) BCContentVC *contentVC; ///< 容器视图控制器
@property (nonatomic, strong) BCContentVidw *containerView;
@property (nonatomic, strong) BCCloseBtn *closeButton;
@end

@implementation BCPopHelper

+ (BCPopHelper *)sharedInstance {
    static BCPopHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [BCPopHelper new];
    });
    return helper;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.closeButtonType = ButtonPositionTypeLeft;
        self.tapOutsideToDismiss = YES;
    };
    return self;
}

- (void)setCloseButtonType:(ButtonPositionType)closeButtonType {
    
    _closeButtonType = closeButtonType;
    if (closeButtonType == ButtonPositionTypeNone) {
        [self.closeButton setHidden:YES];
    } else {
        [self.closeButton setHidden:NO];
        
        CGRect closeFrame = self.closeButton.frame;
        if(closeButtonType == ButtonPositionTypeRight){
            closeFrame.origin.x = round(CGRectGetWidth(self.containerView.frame) - kDefaultCloseButtonPadding - CGRectGetWidth(closeFrame)/2);
        } else {
            closeFrame.origin.x = 0;
        }
        self.closeButton.frame = closeFrame;
    }
}

- (void)showWithPresentView:(UIView *)presentView animated:(BOOL)animated {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BCContentVC *contentVC = [BCContentVC new];
    self.window.rootViewController = contentVC;
    self.contentVC = contentVC;
    
    CGFloat padding = 17;
    CGRect containerViewRect = CGRectInset(presentView.bounds, -padding, -padding);
    containerViewRect.origin.x = containerViewRect.origin.y = 0;
    containerViewRect.origin.x = round(CGRectGetMidX(self.window.bounds) - CGRectGetMidX(containerViewRect));
    containerViewRect.origin.y = round(CGRectGetMidY(self.window.bounds) - CGRectGetMidY(containerViewRect));
    
    BCContentVidw *containerView = [[BCContentVidw alloc] initWithFrame:containerViewRect];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|
    UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    containerView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
//    presentView.frame = (CGRect){padding, padding, presentView.bounds.size};
    [containerView addSubview:presentView];

    [contentVC.view addSubview:containerView];
    self.containerView = containerView;
    
    BCCloseBtn *closeButton = [[BCCloseBtn alloc] init];
    
    if(self.closeButtonType == ButtonPositionTypeRight){
        CGRect closeFrame = closeButton.frame;
        closeFrame.origin.x = CGRectGetWidth(containerView.bounds)-CGRectGetWidth(closeFrame);
        closeButton.frame = closeFrame;
    }
    
    [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:closeButton];
    self.closeButton = closeButton;
    [self setCloseButtonType:self.closeButtonType];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.window makeKeyAndVisible];
        if(animated){
            contentVC.shadowView.alpha = 0;
            [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
                contentVC.shadowView.alpha = 1;
            }];
            containerView.alpha = 0;
            containerView.layer.shouldRasterize = YES;
            containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
            [UIView animateWithDuration:kTransformPart1AnimationDuration animations:^{
                containerView.alpha = 1;
                containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:.2 animations:^{
                    containerView.alpha = 1;
                    containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:kTransformPart2AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                        containerView.alpha = 1;
                        containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                    } completion:^(BOOL finished2) {
                        containerView.layer.shouldRasterize = NO;
                    }];
                    
                }];
            }];
        }
    });
    
}

- (void)close {
    [self hideAnimated:YES withCompletionBlock:nil];
    
}

- (void)closeWithBlcok:(void(^)())complete {
    [self hideAnimated:YES withCompletionBlock:complete];
}

- (void)hideAnimated:(BOOL)animated withCompletionBlock:(void(^)())completion {
    if(!animated){
        [self cleanup];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kFadeInAnimationDuration animations:^{
            self.contentVC.shadowView.alpha = 0;
        }];
        
        self.containerView.layer.shouldRasterize = YES;
        [UIView animateWithDuration:kTransformPart2AnimationDuration animations:^{
            self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
        } completion:^(BOOL finished){
            [UIView animateWithDuration:kTransformPart1AnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.containerView.alpha = 0;
                self.containerView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.0, 0.0);
            } completion:^(BOOL finished2){
                [self cleanup];
                if(completion){
                    completion();
                }
            }];
        }];
    });
    
}

- (void)cleanup{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.containerView removeFromSuperview];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyWindow];
    [self.window removeFromSuperview];
    self.window = nil;
}

- (void)dealloc{
    [self cleanup];
}

@end




