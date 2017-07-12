//
//  YYTextTagExampleVC.m
//  YYKitCopy
//
//  Created by 陈冰 on 2017/7/12.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYTextTagExampleVC.h"
#import "YYKit.h"

@interface YYTextTagExampleVC ()

@end

@implementation YYTextTagExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSArray *tags = @[
        @"◉red",
        @"◉orange",
        @"◉yellow",
        @"◉green",
        @"◉blue",
        @"◉purple",
        @"◉gray"
    ];
    NSArray *tagStrokeColors = @[
        UIColorHex(fa3f39),
        UIColorHex(f48f25),
        UIColorHex(f1c02c),
        UIColorHex(54bc2e),
        UIColorHex(29a9ee),
        UIColorHex(c171d8),
        UIColorHex(818e91)
    ];
    NSArray *tagFillColors = @[
        UIColorHex(fb6560),
        UIColorHex(f6a550),
        UIColorHex(f3cc56),
        UIColorHex(76c957),
        UIColorHex(53baf1),
        UIColorHex(cd8ddf),
        UIColorHex(a4a4a7)
    ];
    
    UIFont *font = [UIFont systemFontOfSize:16];
    for (NSInteger i = 0; i < tags.count; i++) {
        
    }
}

@end
