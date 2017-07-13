//
//  YYImageDisplayExampleVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/11.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYImageDisplayExampleVC.h"
#import "YYKit.h"
#import "YYImageExampleHelper.h"

@interface YYImageDisplayExampleVC () <UIGestureRecognizerDelegate>
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
    label.size = CGSizeMake(self.view.width, 60);
    label.top = 20;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.text = @"Tap the image to pause/play\n Slide on the image to forward/rewind";
    [self.scrollView addSubview:label];
    self.scrollView.panGestureRecognizer.cancelsTouchesInView = YES;
    
    [self addImageWithName:@"niconiconi" andText:@"Animated GIF"];
    [self addImageWithName:@"wall-e" andText:@"Animated WebP"];
    [self addImageWithName:@"pia" andText:@"Animated PNG (APNG)"];
    
    [self addFrameImageWithText:@"Frame Animation"];
    
    [self addSpriteSheetImageWithText:@"Sprite Sheet Animation"];
}

// 普通图片 gif webp png 动画
- (void)addImageWithName:(NSString *)name andText:(NSString *)text {
    YYImage *image = [YYImage imageNamed:name];
    [self addImage:image size:CGSizeZero text:text];
}

// 多个图片嵌套实现动画
- (void)addFrameImageWithText:(NSString *)text {
    NSString *basePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"EmoticonWeibo.bundle/com.sina.default"];
    NSMutableArray *paths = [NSMutableArray array];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_aini@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_baibai@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_chanzui@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_chijing@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_dahaqi@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_guzhang@3x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_haha@2x.png"]];
    [paths addObject:[basePath stringByAppendingPathComponent:@"d_haixiu@3x.png"]];
    
    // 帧动画图片
    YYFrameImage *image = [[YYFrameImage alloc] initWithImagePaths:paths oneFrameDuration:0.1 loopCount:0];
    [self addImage:image size:CGSizeZero text:text];
}

// 雪碧图
- (void)addSpriteSheetImageWithText:(NSString *)text {
    
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"ResourceTwitter.bundle/fav02l-sheet@2x.png"];
    UIImage *sheet = [[UIImage alloc] initWithData:[NSData dataWithContentsOfFile:path] scale:2];
    
    NSMutableArray *contentRects = [NSMutableArray array];
    NSMutableArray *durations = [NSMutableArray array];
    
    // 8 * 12 sprites in a single sheet image 有8*12个碎片图
    CGSize size = CGSizeMake(sheet.size.width / 8, sheet.size.height / 12);
    for (NSInteger j = 0; j < 12; j++) {
        for (NSInteger i = 0; i < 8; i++) {
            CGRect rect;
            rect.size = size;
            rect.origin.x = sheet.size.width / 8 * i;
            rect.origin.y = sheet.size.height / 12 * j;
            [contentRects addObject:[NSValue valueWithCGRect:rect]];
            [durations addObject:@(1/60.0)]; // 每一个显示 1/60 秒
        }
    }
    // 雪碧图图片
    YYSpriteSheetImage *sprite = [[YYSpriteSheetImage alloc] initWithSpriteSheetImage:sheet contentRects:contentRects frameDurations:durations loopCount:0];
    [self addImage:sprite size:size text:text];
}

- (void)addImage:(UIImage *)image size:(CGSize)size text:(NSString *)text {
    
    // 动画图片容器
    YYAnimatedImageView *imageView = [[YYAnimatedImageView alloc] initWithImage:image];
    if (size.width > 0 && size.height > 0) imageView.size = size;
    imageView.centerX = self.view.width / 2;
    imageView.top = [(UIView *)[self.scrollView.subviews lastObject] bottom]+30;
    [self.scrollView addSubview:imageView];
    
    // 给图片添加2个手势，暂停／启动，前进／后退
    [YYImageExampleHelper addTapControlToAnimatedImageView:imageView];
    [YYImageExampleHelper addPanControlToAnimatedImageView:imageView];
    for (UIGestureRecognizer *g in imageView.gestureRecognizers) {
        g.delegate = self;
    }
    
    UILabel *imageLabel = [UILabel new];
    imageLabel.backgroundColor = [UIColor clearColor];
    imageLabel.frame = CGRectMake(0, 0, self.view.width, 20);
    imageLabel.top = imageView.bottom + 10;
    imageLabel.textAlignment = NSTextAlignmentCenter;
    imageLabel.text = text;
    [self.scrollView addSubview:imageLabel];
    
    self.scrollView.contentSize = CGSizeMake(self.view.width, imageLabel.bottom+20);
}

/* 允许多个手势识别器共同识别 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end
