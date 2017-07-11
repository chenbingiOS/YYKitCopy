//
//  YYImageDisplayExampleVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/11.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYImageDisplayExampleVC.h"

@interface YYImageDisplayExampleVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation YYImageDisplayExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.863 alpha:1.0];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.frame = self.view.bounds;
    
    [self.view addSubview:self.scrollView];
}



@end
