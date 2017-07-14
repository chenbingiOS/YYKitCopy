//
//  YYImageBenchmarkVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/14.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYImageBenchmarkVC.h"

@interface YYImageBenchmarkVC ()
@end

@implementation YYImageBenchmarkVC {
    UIActivityViewController *_indicatior;
    UIView *_hud; ///< 指示器
    NSMutableArray *_titles;
    NSMutableArray *_blocks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _titles = [NSMutableArray array];
    _blocks = [NSMutableArray array];
    
    self.title = @"Benchmark (See Logs in Xcode)";
    
}

@end
