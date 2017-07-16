//
//  YYTextAttachmentExampleVC.m
//  YYKitCopy
//
//  Created by 陈冰 on 2017/7/13.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYTextAttachmentExampleVC.h"
#import "YYKit.h"
#import "YYTextExampleHelper.h"
#import "YYImageExampleHelper.h"

@interface YYTextAttachmentExampleVC () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) YYLabel *label;
@end

@implementation YYTextAttachmentExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [YYTextExampleHelper addDebugOptionToViewController:self];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:16];
    
    {
        NSString *title = @"This is UIImage attachment:";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
        
        UIImage *image = [UIImage imageNamed:@"dribbble64_imageio"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    {
        NSString *title = @"This is UIView attachment: ";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
        
        UISwitch *switcher = [UISwitch new];
        [switcher sizeToFit];

        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:switcher contentMode:UIViewContentModeCenter attachmentSize:switcher.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];        
    }
    {
        NSString *title = @"This is Animatied Image attachment:";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title]];

        NSArray *names = @[@"001", @"002", @"019", @"056", @"085"];
        for (NSString *name in names) {
            NSString *path = [[NSBundle mainBundle] pathForScaledResource:name ofType:@"gif" inDirectory:@"EmoticonQQ.bundle"];
            NSData *data = [NSData dataWithContentsOfFile:path];
            
            YYImage *image = [YYImage imageWithData:data scale:2];
            image.preloadAllAnimatedImageFrames = YES;
            YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
            
            NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
            [text appendAttributedString:attachText];
        }
        
        YYImage *image = [YYImage imageNamed:@"wall-e.webp"];
        image.preloadAllAnimatedImageFrames = YES;
        YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
        imageView.autoPlayAnimatedImage = NO;
        [imageView startAnimating];
        [YYImageExampleHelper addPanControlToAnimatedImageView:imageView];
        [YYImageExampleHelper addTapControlToAnimatedImageView:imageView];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageView.size alignToFont:font alignment:YYTextVerticalAlignmentBottom];
        [text appendAttributedString:attachText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    
    text.font = font;
    
    _label = [YYLabel new];
    _label.userInteractionEnabled = YES;
    _label.numberOfLines = 0;
    _label.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _label.size = CGSizeMake(260, 260);
    _label.center = CGPointMake(self.view.width/2, self.view.height/2 - (kiOS7Later?0:32));
    _label.attributedText = text;
    [self addSeeMoreButton];
    [self.view addSubview:_label];
    
    _label.layer.borderWidth = CGFloatFromPixel(1);// 考虑屏幕缩放比例
    _label.layer.borderColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.000].CGColor;
    
    UIView *dot = [self newDotView];
    dot.center = CGPointMake(_label.width, _label.height);
    dot.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    [_label addSubview:dot];
    
    YYGestureRecognizer *gesture = [YYGestureRecognizer new];
    __weak typeof(_label) wlabel = _label;
    gesture.action = ^(YYGestureRecognizer * _Nonnull gesture, YYGestureRecognizerState state) {
        if (state != YYGestureRecognizerStateMoved) return ;
        
        CGFloat width = gesture.currentPoint.x;
        CGFloat height = gesture.currentPoint.y;
        wlabel.width = width < 30 ? 30 : width;
        wlabel.height = height < 30 ? 30 : height;
    };
    gesture.delegate = self;
    [_label addGestureRecognizer:gesture];
}

- (void)addSeeMoreButton {
    
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];

    YYTextBorder *border = [YYTextBorder new];
    border.cornerRadius = 3;
    [border setFillColor:[UIColor colorWithWhite:0.000 alpha:0.220]];
    [hi setBorder:border];
    
    __weak typeof(self) _self = self;
    hi.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        YYLabel *label = _self.label;
        [label sizeToFit];
    };
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...more"];
    [text setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000]];
    [text setTextHighlight:hi range:[text.string rangeOfString:@"more"]];
    text.font = _label.font;

    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    
    NSAttributedString *truncationToken = [NSAttributedString attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize:seeMore.size alignToFont:text.font alignment:YYTextVerticalAlignmentCenter];
    _label.truncationToken = truncationToken;
}

- (UIView *)newDotView {
    
    UIView *view = [UIView new];
    view.size = CGSizeMake(50, 50);
    
    UIView *dot = [UIView new];
    dot.size = CGSizeMake(10, 10);
    dot.backgroundColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:1.000];
    dot.clipsToBounds = YES;
    dot.layer.cornerRadius = dot.height / 2;
    dot.center = CGPointMake(view.width / 2, view.height / 2);
    [view addSubview:dot];
    
    return view;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {

    CGPoint p = [gestureRecognizer locationInView:_label];
    if (p.x < _label.width-20) return NO;
    if (p.y < _label.height-20) return NO;
    
    return YES;
}

@end
