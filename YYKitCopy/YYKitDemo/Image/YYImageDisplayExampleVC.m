//
//  YYImageDisplayExampleVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/11.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYImageDisplayExampleVC.h"
#import "YYKit.h"

@interface YYImageDisplayExampleVC ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation YYImageDisplayExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.863 alpha:1.0];
    
    self.scrollView = [UIScrollView new];
    self.scrollView.frame = self.view.bounds;
    if (kSystemVersion < 7) {
        self.scrollView.height -= 44;
    }
    [self.view addSubview:self.scrollView];
    
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.top = 20;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"Tap the image to pause/play\n Slide on the image to forward/rewind";
    [self.scrollView addSubview:label];
    
    self.scrollView.panGestureRecognizer.cancelsTouchesInView = YES;
    
    
    
}

- (void)addImageWithName:(NSString *)name andText:(NSString *)text {
    YYImage *image = [YYImage imageNamed:name];
    [self addImage:image size:CGSizeZero text:text];
}

- (void)addFrameImageWithText:(NSString *)text {
    NSString *basePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"EmoticonWeibo.bundle/com.sina.default"];
    
}

- (void)addImage:(UIImage *)image size:(CGSize)size text:(NSString *)text {
    
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    if (size.width > 0 && size.height > 0) imageView.size = size;
    imageView.centerX = self.view.width / 2;
    imageView.top = [(UIView *)[self.scrollView.subviews lastObject] bottom]+30;
    [self.scrollView addSubview:imageView];
    
    UILabel *imageLabel = [UILabel new];
    imageLabel.backgroundColor = [UIColor clearColor];
    imageLabel.frame = CGRectMake(0, 0, self.view.width, 20);
    imageLabel.top = imageView.bottom + 10;
    imageLabel.textAlignment = NSTextAlignmentCenter;
    imageLabel.text = text;
    [self.scrollView addSubview:imageLabel];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, imageLabel.bottom+20);
}



@end
