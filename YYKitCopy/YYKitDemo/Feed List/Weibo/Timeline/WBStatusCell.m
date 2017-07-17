//
//  WBStatusCell.m
//  YYTest
//
//  Created by 陈冰 on 2017/3/23.
//  Copyright © 2017年 GLAC. All rights reserved.
//

#import "WBStatusCell.h"
#import "WBStatusLayout.h"
#import "WBStatusHelper.h"

@implementation WBStatusTitleView

@end

@implementation WBStatusProfileView

@end
@implementation WBStatusCardView

@end
@implementation WBStatusToolBarView
- (void)setWithLayout:(WBStatusLayout *)layout {}
- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation
{}
@end
@implementation WBStatusTagView

@end

@implementation WBStatusView
{
    BOOL _touchRetweetView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = kScreenWidth;
        frame.size.height = 1;
    }
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        // ExclusiveTouch的作用是：可以达到同一界面上多个控件接受事件时的排他性,从而避免一些问题。
        // 当UIView的exclusiveTouch属性设置为YES时，UIView可以独占当前窗口的touch事件。在手指离开屏幕之前，其他视图都无法触发touch事件。
        self.exclusiveTouch = YES;
     
        _contentView = [UIView new];
        _contentView.width = kScreenWidth;
        _contentView.height = 1;
        _contentView.backgroundColor = [UIColor whiteColor];
        
        static UIImage *topLineBG, *bottomLineBG;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            topLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef  _Nonnull context) {
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 0.8, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
                CGContextAddRect(context, CGRectMake(-2, 3, 4, 4));
                CGContextFillPath(context);
            }];
            bottomLineBG = [UIImage imageWithSize:CGSizeMake(1, 3) drawBlock:^(CGContextRef  _Nonnull context) {
                CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
                CGContextSetShadowWithColor(context, CGSizeMake(0, 0.4), 2, [UIColor colorWithWhite:0 alpha:0.08].CGColor);
                CGContextAddRect(context, CGRectMake(-2, -2, 4, 2));
                CGContextFillPath(context);
            }];
        });
        
        UIImageView *topLine = [[UIImageView alloc] initWithImage:topLineBG];
        topLine.width = _contentView.width;
        topLine.bottom = 0;
        topLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [_contentView addSubview:topLine];
        UIImageView *bottomLine = [[UIImageView alloc] initWithImage:bottomLineBG];
        bottomLine.width = _contentView.width;
        bottomLine.top = _contentView.height;
        bottomLine.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        [_contentView addSubview:bottomLine];
        [self addSubview:_contentView];
        
        _titleView = [WBStatusTitleView new];
        _titleView.hidden = YES;
        [_contentView addSubview:_titleView];
        
        _profileView = [WBStatusProfileView new];
        [_contentView addSubview:_profileView];
        
        _vipBackgroundView = [UIImageView new];
        _vipBackgroundView.size = CGSizeMake(kScreenWidth, 14.0);
        _vipBackgroundView.top = -2;
        _vipBackgroundView.contentMode = UIViewContentModeRight;
        [_contentView addSubview:_vipBackgroundView];
        
        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.size = CGSizeMake(30, 30);
//        _menuButton setImage:<#(nullable UIImage *)#> forState:<#(UIControlState)#>
        _menuButton.centerX = self.width - 20;
        _menuButton.centerY = 18;
        [_menuButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            
        }];
        [_contentView addSubview:_menuButton];
        
        _retweetBackgroundView = [UIView new];
//        _retweetBackgroundView.backgroundColor =
        _retweetBackgroundView.width = kScreenWidth;
        [_contentView addSubview:_retweetBackgroundView];
        
        _textLabel = [YYLabel new];
        
    }
    return self;
}

- (void)setLayout:(WBStatusLayout *)layout
{
    _layout = layout;
    
    _contentView.top = layout.marginTop;
    _contentView.height = layout.height - layout.marginTop - layout.marginBottom;
    
    CGFloat top = 0;
    if (layout.titleHeight > 0) {
        _titleView.hidden = NO;
        _titleView.height = layout.titleHeight;
        _titleView.titleLabel.textLayout = layout.titleTextLayout;
        top = layout.titleHeight;
    } else {
        _titleView.hidden = YES;
    }
    
    /// 圆角头像
    [_profileView.avatarView setImageWithURL:layout.status.user.avatarLarge /* profileImageURL */ placeholder:nil options:kNilOptions manager:[WBStatusHelper avatarImageManager] progress:nil transform:nil completion:nil];
    _profileView.nameLabel.textLayout = layout.nameTextLayou;
    _profileView.sourceLabel.textLayout = layout.sourceTextLayout;
    _profileView.verifyType = layout.status.user.userVerifyType;
}

@end

@implementation WBStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _statusView = [WBStatusView new];
        _statusView.cell = self;
        _statusView.titleView.cell = self;
        _statusView.profileView.cell = self;
        _statusView.cardView.cell = self;
        _statusView.toolbarView.cell = self;
        _statusView.tagView.cell = self;
        [self.contentView addSubview:_statusView];
    }
    return self;
}

- (void)setLayout:(WBStatusLayout *)layout
{
    NSLog(@"cell Height %@", @(layout.height));
    
    self.height = layout.height;
    self.contentView.height = layout.height;
    _statusView.layout = layout;
}

@end
