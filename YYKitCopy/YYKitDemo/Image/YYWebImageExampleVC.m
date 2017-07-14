//
//  YYWebImageExampleVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/13.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYWebImageExampleVC.h"
#import "YYKit.h"

#define kCellHeight ceil((kScreenWidth) * 3.0 / 4.0)

@interface YYWebImageExampleCell : UITableViewCell
@property (nonatomic, strong) YYAnimatedImageView *webImageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) CAShapeLayer *porgressLayer;
@property (nonatomic, strong) UILabel *label;
@end

@implementation YYWebImageExampleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.size =  CGSizeMake(kScreenWidth, kCellHeight);
    self.contentView.size = self.size;
    
    _webImageView = [YYAnimatedImageView new];
    _webImageView.size = self.size;
    _webImageView.clipsToBounds = YES;
    _webImageView.contentMode = UIViewContentModeScaleAspectFill;
    _webImageView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_webImageView];
    
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.center = CGPointMake(self.width/2, self.height/2);
    _indicator.hidden = YES;
    [self.contentView addSubview:_indicator]; //use progress bar instead..

    _label = [UILabel new];
    _label.size = self.size;
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"Load fail, tap to reload.";
    _label.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    _label.hidden = YES;
    _label.userInteractionEnabled = YES;
    [self.contentView addSubview:_label];
    
    CGFloat lineHieht = 4;
    _porgressLayer = [CAShapeLayer layer];
    _porgressLayer.size = CGSizeMake(_webImageView.width, lineHieht);
    _porgressLayer.lineWidth = lineHieht;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, _porgressLayer.height/2)];
    [path addLineToPoint:CGPointMake(_webImageView.width, _porgressLayer.height/2)];
    _porgressLayer.path = path.CGPath;
    _porgressLayer.strokeColor = [UIColor colorWithRed:0.000 green:0.640 blue:1.000 alpha:0.720].CGColor;
    _porgressLayer.lineCap = kCALineCapButt;
    _porgressLayer.strokeStart = 0;
    _porgressLayer.strokeEnd = 0;
    [_webImageView.layer addSublayer:_porgressLayer];
    
    __weak typeof(self) _self = self;
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [_self setImageURL:_self.webImageView.imageURL];
    }];
    [_label addGestureRecognizer:g];
    
    return self;
}

- (void)setImageURL:(NSURL *)url {
    _label.hidden = YES;
    _indicator.hidden = NO;
    [_indicator startAnimating];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _porgressLayer.hidden = YES;
    _porgressLayer.strokeEnd = 0;
    [CATransaction commit];
    
    __weak typeof(self) _self = self;
    [_webImageView setImageWithURL:url placeholder:nil options:YYWebImageOptionProgressiveBlur | YYWebImageOptionShowNetworkActivity | YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (expectedSize > 0 && receivedSize > 0) {
            CGFloat progress = (CGFloat)expectedSize/receivedSize;
            progress = progress < 0 ? 0 : progress > 1 ? 1 : progress;
            if (_self.porgressLayer.hidden) _self.porgressLayer.hidden = NO;
            _self.porgressLayer.strokeEnd = progress;
        }
    } transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (stage == YYWebImageStageFinished) {
            _self.porgressLayer.hidden = YES;
            [_self.indicator stopAnimating];
            _self.indicator.hidden = YES;
            if (!image) _self.label.hidden = YES;
        }
    }];
}

@end


@interface YYWebImageExampleVC ()
@property (nonatomic, strong) NSArray *imageLinks;
@end

@implementation YYWebImageExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"Reload" style:UIBarButtonItemStylePlain target:self action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = button;
    self.view.backgroundColor = [UIColor colorWithWhite:0.217 alpha:1.000];
    
    NSArray *links = @[
       /*
        You can add your image url here.
        */
       
       // progressive jpeg
       @"https://s-media-cache-ak0.pinimg.com/1200x/2e/0c/c5/2e0cc5d86e7b7cd42af225c29f21c37f.jpg",
       
       // animated gif: http://cinemagraphs.com/
       @"http://i.imgur.com/uoBwCLj.gif",
       @"http://i.imgur.com/8KHKhxI.gif",
       @"http://i.imgur.com/WXJaqof.gif",
       
       // animated gif: https://dribbble.com/markpear
       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1780193/dots18.gif",
       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1809343/dots17.1.gif",
       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1845612/dots22.gif",
       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1820014/big-hero-6.gif",
       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1819006/dots11.0.gif",
       @"https://d13yacurqjgara.cloudfront.net/users/345826/screenshots/1799885/dots21.gif",
       
       // animaged gif: https://dribbble.com/jonadinges
       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/2025999/batman-beyond-the-rain.gif",
       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1855350/r_nin.gif",
       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1963497/way-back-home.gif",
       @"https://d13yacurqjgara.cloudfront.net/users/288987/screenshots/1913272/depressed-slurp-cycle.gif",
       
       // jpg: https://dribbble.com/snootyfox
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2047158/beerhenge.jpg",
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/2016158/avalanche.jpg",
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1839353/pilsner.jpg",
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1833469/porter.jpg",
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1521183/farmers.jpg",
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1391053/tents.jpg",
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1399501/imperial_beer.jpg",
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1488711/fishin.jpg",
       @"https://d13yacurqjgara.cloudfront.net/users/26059/screenshots/1466318/getaway.jpg",
       
       // animated webp and apng: http://littlesvr.ca/apng/gif_apng_webp.html
       @"http://littlesvr.ca/apng/images/BladeRunner.png",
       @"http://littlesvr.ca/apng/images/Contact.webp",
       ];
    
    self.imageLinks = links;
    [self.tableView reloadData];
    [self scrollViewDidScroll:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (kiOS7Later) {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (kiOS7Later) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
        self.navigationController.navigationBar.tintColor = nil;
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _imageLinks.count * 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YYWebImageExampleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) cell = [[YYWebImageExampleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    [cell setImageURL:[NSURL URLWithString:_imageLinks[indexPath.row%_imageLinks.count]]];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    /// 实现了一个 在滑动的时候，可见的cell有缩小，产生视差效果
    CGFloat viewHeight = scrollView.height + scrollView.contentInset.top;
    for (YYWebImageExampleCell *cell in [self.tableView visibleCells]) {
        CGFloat y = cell.centerY - scrollView.contentOffset.y;
        CGFloat p = y - viewHeight / 2;
        CGFloat scale = cos(p / viewHeight * 0.8) * 0.95;
        if (kiOS8Later) {
            [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                cell.webImageView.transform = CGAffineTransformMakeScale(scale, scale);
            } completion:nil];
        } else {
            cell.webImageView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
}

/**
 刷新数据
 */
- (void)reload {
    [[YYImageCache sharedCache].memoryCache removeAllObjects];
    [[YYImageCache sharedCache].diskCache removeAllObjectsWithBlock:^{}];
    [self.tableView performSelector:@selector(reloadData) afterDelay:0.1];
}

@end
