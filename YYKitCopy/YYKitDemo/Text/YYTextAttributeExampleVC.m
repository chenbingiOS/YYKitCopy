//
//  YYTextAttributeExampleVC.m
//  YYKitCopy
//
//  Created by 陈冰 on 2017/7/11.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYTextAttributeExampleVC.h"
#import "YYKit.h"

@interface YYTextAttributeExampleVC ()

@end

@implementation YYTextAttributeExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    __weak typeof(self) _self = self;
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    {
        // 阴影文字
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Shadow"];
        one.font = [UIFont boldSystemFontOfSize:30];
        one.color = [UIColor whiteColor];
        YYTextShadow *shadow = [YYTextShadow new];
        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.490];
        shadow.offset = CGSizeMake(0, 1);
        shadow.radius = 5;
        one.textShadow = shadow;
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    {
        // 内阴影文字
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Inner Shadow"];
        one.font = [UIFont boldSystemFontOfSize:30];
        one.color = [UIColor whiteColor];
        YYTextShadow *shadow = [YYTextShadow new];
        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.490];
        shadow.offset = CGSizeMake(0, 1);
        shadow.radius = 1;
        one.textInnerShadow = shadow;
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    {
        // 多个阴影文字
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Multiple Shadow"];
        one.font = [UIFont boldSystemFontOfSize:30];
        one.color = [UIColor colorWithRed:1.000 green:0.795 blue:0.014 alpha:1.000];
        
        YYTextShadow *shadow = [YYTextShadow new];
        shadow.color = [UIColor colorWithWhite:0.000 alpha:0.490];
        shadow.offset = CGSizeMake(0, 1);
        shadow.radius = 1;
        
        YYTextShadow *subShadow = [YYTextShadow new];
        subShadow.color = [UIColor colorWithWhite:1 alpha:0.99];
        subShadow.offset = CGSizeMake(0, 1);
        subShadow.radius = 1.5;
        
        subShadow.subShadow = subShadow;
        one.textShadow = shadow;
        
        YYTextShadow *innerShadow = [YYTextShadow new];
        innerShadow.color = [UIColor colorWithRed:0.851 green:0.311 blue:0.000 alpha:0.780];
        innerShadow.offset = CGSizeMake(0, 1);
        innerShadow.radius = 1;
        one.textInnerShadow = innerShadow;
        
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    {
        // 图片文字
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Background Image"];
        one.font = [UIFont boldSystemFontOfSize:30];
        one.color = [UIColor colorWithRed:1.000 green:0.795 blue:0.014 alpha:1.000];
        
        CGSize size = CGSizeMake(20, 20);
        UIImage *background = [UIImage imageWithSize:size drawBlock:^(CGContextRef  _Nonnull context) {
            UIColor *c0 = [UIColor colorWithRed:0.054 green:0.879 blue:0.000 alpha:1.000];
            UIColor *c1 = [UIColor colorWithRed:0.869 green:1.000 blue:0.030 alpha:1.000];
            [c0 setFill];
            CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
            [c1 setStroke];
            CGContextSetLineWidth(context, 2);
            for (NSInteger i = 0; i < size.width * 2; i += 4) {
                CGContextMoveToPoint(context, i, -2);
                CGContextAddLineToPoint(context, i - size.height, size.height + 2);
            }
            CGContextStrokePath(context);
        }];
        one.color = [UIColor colorWithPatternImage:background];
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
    }
    {
        // 边界
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Border"];
        one.font = [UIFont boldSystemFontOfSize:30];
        one.color = [UIColor colorWithRed:1.000 green:0.029 blue:0.651 alpha:1.000];
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeColor = [UIColor colorWithRed:1.000 green:0.029 blue:0.651 alpha:1.000];
        border.strokeWidth = 3;
        border.lineStyle = YYTextLineStylePatternDashDotDot;
        border.cornerRadius = 3;
        border.insets = UIEdgeInsetsMake(0, -4, 0, -4);
        one.textBackgroundBorder = border;
        
        [text appendAttributedString:[self padding]];
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
        [text appendAttributedString:[self padding]];
    }
    {
        // 给文字添加点击效果，下划线，高亮
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Link"];
        one.font = [UIFont boldSystemFontOfSize:30];
        one.underlineStyle = NSUnderlineStyleSingle;
#if 0
        /// 1. you can set a highlight with these code
        one.color = [UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000];
        
        YYTextBorder *border = [YYTextBorder new];
        border.cornerRadius = 3;
        border.insets = UIEdgeInsetsMake(0, -4, 0, -4);
        border.fillColor = [UIColor colorWithWhite:0.000 alpha:0.220];
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setBorder:border];
        highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
        };
        [one setTextHighlight:highlight range:one.rangeOfAll];
#else
        /// 2. or you can use the convenience method
        [one setTextHighlightRange:one.rangeOfAll
                             color:[UIColor colorWithRed:0.093 green:0.492 blue:1.000 alpha:1.000]
                   backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                         tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
        }];
#endif
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
        [text appendAttributedString:[self padding]];
    }
    {
        // 边框
        NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:@"Another Link"];
        one.font = [UIFont boldSystemFontOfSize:30];
        one.color = [UIColor redColor];
        
        YYTextBorder *border = [YYTextBorder new];
        border.cornerRadius = 50;
        border.insets = UIEdgeInsetsMake(0, -10, 0, -10);
        border.strokeWidth =0.5;
        border.strokeColor = one.color;
        border.lineStyle = YYTextLineStyleSingle;
        one.textBackgroundBorder = border;
        
        YYTextBorder *highlightBorder = [YYTextBorder new];
        highlightBorder.cornerRadius = 0;
        highlightBorder.strokeColor = one.color;
        highlightBorder.fillColor = one.color;
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor whiteColor]];
        [highlight setBackgroundBorder:highlightBorder];
        highlight.tapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            [_self showMessage:[NSString stringWithFormat:@"Tap: %@",[text.string substringWithRange:range]]];
        };
        [one setTextHighlight:highlight range:one.rangeOfAll];
        
        [text appendAttributedString:one];
        [text appendAttributedString:[self padding]];
        [text appendAttributedString:[self padding]];
    }
    
    YYLabel *label = [YYLabel new];
    label.attributedText = text;
    label.width = self.view.width;
    label.height = self.view.height - (kiOS7Later?64:44);
    label.top = (kiOS7Later?64:0);
    label.textAlignment = NSTextAlignmentCenter;
    label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    [self.view addSubview:label];
}

- (NSAttributedString *)padding {
    NSMutableAttributedString *pad = [[NSMutableAttributedString alloc] initWithString:@"\n\n"];
    pad.font = [UIFont systemFontOfSize:4];
    return pad;
}

- (void)showMessage:(NSString *)msg {
    CGFloat padding = 10;
    
    YYLabel *label = [YYLabel new];
    label.text = msg;
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor colorWithRed:0.033 green:0.685 blue:0.978 alpha:0.730];
    label.width = self.view.width;
    label.textContainerInset = UIEdgeInsetsMake(padding, padding, padding, padding);
    label.height = [msg heightForFont:label.font width:label.width]+2*padding;
    label.bottom = (kiOS7Later?64:0);
    [self.view addSubview:label];
    
    CGFloat heih = [msg heightForFont:label.font width:label.width];
    
    [UIView animateWithDuration:0.3 animations:^{
        label.top = (kiOS7Later?64:0);
    } completion:^(BOOL finished) {
        //http://blog.csdn.net/wsxzk123/article/details/44575277
        [UIView animateWithDuration:0.2 delay:2 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            label.bottom = (kiOS7Later?64:0);
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

@end
