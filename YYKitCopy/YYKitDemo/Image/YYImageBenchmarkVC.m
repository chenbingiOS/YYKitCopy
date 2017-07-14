//
//  YYImageBenchmarkVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/14.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYImageBenchmarkVC.h"
#import "YYKit.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "YYBPGCoder.h"

@interface YYImageBenchmarkVC ()
@end

@implementation YYImageBenchmarkVC {
    UIActivityIndicatorView *_indicatior;
    UIView *_hud; ///< 指示器
    NSMutableArray *_titles;
    NSMutableArray *_blocks;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Benchmark (See Logs in Xcode)";
    
    _titles = [NSMutableArray array];
    _blocks = [NSMutableArray array];

    [self addCell:@"ImageIO Image Decode" andSelector:@selector(runImageDecodeBenchmark)];
    [self addCell:@"ImageIO Image Encode" andSelector:@selector(runImageEncodeBenchmark)];
    [self addCell:@"WebP Encode and Decode (Slow)" andSelector:@selector(runWebPBenchmark)];
    [self addCell:@"BPG Decode" andSelector:@selector(runBPGBenchmark)];
    [self addCell:@"Animated Image Decode" andSelector:@selector(runAnimatedImageBenchmark)];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    [_hud removeFromSuperview];
}

- (void)initHUD {
    _hud = [UIView new];
    _hud.size = CGSizeMake(130, 80);
    _hud.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7];
    _hud.clipsToBounds = YES;
    _hud.layer.cornerRadius = 5;
    
    _indicatior = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicatior.size = CGSizeMake(50, 50);
    _indicatior.centerX = _hud.width/2;
    _indicatior.centerY = _hud.height/2-9;
    [_hud addSubview:_indicatior];
    
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.size = CGSizeMake(_hud.width, 20);
    label.text = @"See logs in Xcode";
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = [UIColor whiteColor];
    label.centerX = _hud.width/2;
    label.bottom = _hud.height - 8;
    [_hud addSubview:label];
}

- (void)startHUD {
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    _hud.center = CGPointMake(window.width/2, window.height/2);
    [_indicatior startAnimating];
    [window addSubview:_hud];
    self.navigationController.view.userInteractionEnabled = NO;
}

- (void)stopHUD {
    [_indicatior stopAnimating];
    [_hud removeFromSuperview];
    self.navigationController.view.userInteractionEnabled = YES;
}

- (void)addCell:(NSString *)title andSelector:(SEL)sel {
    __weak typeof(self) _self = self;
    void (^block)(void) = ^(){
        if (![_self respondsToSelector:sel]) return ;
        
        [_self startHUD];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [_self performSelector:sel];
#pragma clang diagnostic pop
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self stopHUD];
            });
        });
    };
    [_titles addObject:title];
    [_blocks addObject:block];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    cell.textLabel.text = _titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ((void (^)(void))_blocks[indexPath.row])();
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Benchmark

- (NSArray *)imageNames {
    return @[ @"dribbble", @"lena" ];
}

- (NSArray *)imageSizes {
    return @[  @64, @128, @256, @512 ];
}

- (NSArray *)imageSources {
    return @[ @"imageio", @"photoshop", @"imageoptim", @"pngcrush", @"tinypng", @"twitter", @"weibo", @"facebook" ];
}

- (NSArray *)imageTypes {
    return @[(id)kUTTypeJPEG, (id)kUTTypeJPEG2000, (id)kUTTypeTIFF, (id)kUTTypeGIF, (id)kUTTypePNG, (id)kUTTypeBMP ];
}

- (NSString *)imageTypeGetExt:(id)type {
    static NSDictionary *map;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        map = @{(id)kUTTypeJPEG : @"jpg",
                (id)kUTTypeJPEG2000 : @"jp2",
                (id)kUTTypeTIFF : @"tif",
                (id)kUTTypeGIF : @"gif",
                (id)kUTTypePNG : @"png",
                (id)kUTTypeBMP : @"bmp"};
    });
    return type ? map[type] : nil;
}

- (void)runImageDecodeBenchmark {
    printf("==========================================\n");
    printf("ImageIO Decode Benchmark\n");
    printf("name    size type quality length decode_time\n");
    
    for (NSString *imageName in [self imageNames]) {
        for (NSNumber *imageSize in [self imageSizes]) {
            for (NSString *imageSource in [self imageSources]) {
                for (NSString *imageType in @[@"png", @"jpg"]) {
                    // 自动释放池
                    @autoreleasepool {
                        NSString *fileName = [NSString stringWithFormat:@"%@%@_%@", imageName, imageSize, imageSource];
                        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:imageType];
                        NSData *data = filePath ? [NSData dataWithContentsOfFile:filePath] : nil;
                        if (!data) continue;
                        NSUInteger count = 100;
                        YYBenchmark(^{
                            for (NSUInteger i = 0; i < count; i++) {
                                CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFTypeRef)data, NULL);
                                CGImageRef image = CGImageSourceCreateImageAtIndex(source, 0, (CFDictionaryRef)@{(id)kCGImageSourceShouldCache : @(NO)});
                                CGImageRef decoded = YYCGImageCreateDecodedCopy(image, YES);
                                CFRelease(decoded);
                                CFRelease(image);
                                CFRelease(source);
                            }
                        }, ^(double ms) {
                            printf("%8s %3d %3s %10s %6d %2.3f\n", imageName.UTF8String, imageSize.intValue, imageType.UTF8String, imageSource.UTF8String, (int)data.length, ms / count);
                        });
                        
#if ENABLE_OUTPUT
                        if ([UIDevice currentDevice].isSimulator) {
                            NSString *outFilePath = [NSString stringWithFormat:@"%@%@.%@", IMAGE_OUTPUT_DIR, fileName, imageType];
                            [data writeToFile:outFilePath atomically:YES];
                        }
#endif
                        
                    }
                }
            }
        }
    }
}

@end
