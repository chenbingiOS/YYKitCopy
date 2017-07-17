//
//  WBStatusCell.h
//  YYTest
//
//  Created by 陈冰 on 2017/3/23.
//  Copyright © 2017年 GLAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYKit.h"
#import "YYTableViewCell.h"
#import "WBModel.h"

@class WBStatusCell;
@class WBStatusLayout;

@interface WBStatusTitleView : UIView
// 属性
@property (nonatomic, strong) YYLabel *titleLabel; ///< 标题
@property (nonatomic, strong) UIButton *arrowButton;
// 附带自身属性
@property (nonatomic, weak) WBStatusCell *cell;
@end
@interface WBStatusProfileView : UIView
// 属性
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) UIImageView *avatarBadgeView; ///< 徽章
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
// 功能
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, assign) WBUserVerifyType verifyType;
// 附带自身属性
@property (nonatomic, weak) WBStatusCell *cell;
@end
@interface WBStatusCardView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *badgeImageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
// 附带自身属性
@property (nonatomic, weak) WBStatusCell *cell;
@end
@interface WBStatusToolBarView : UIView
@property (nonatomic, strong) UIImageView *repostImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

@property (nonatomic, strong) YYLabel *repostLabel;
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) YYLabel *likeLabel;

@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
// 功能
@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;
// 附带自身属性
@property (nonatomic, weak) WBStatusCell *cell;

- (void)setWithLayout:(WBStatusLayout *)layout;
// set both 'liked' and 'likeCount'
- (void)setLiked:(BOOL)liked withAnimation:(BOOL)animation;
@end

@interface WBStatusTagView : UIView
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) YYLabel *label;
@property (nonatomic, strong) UIButton *button;
// 附带自身属性
@property (nonatomic, weak) WBStatusCell *cell;
@end

@interface WBStatusView : UIView
// 属性
@property (nonatomic, strong) UIView *contentView; ///< 容器
@property (nonatomic, strong) WBStatusTitleView *titleView; ///< 标题栏
@property (nonatomic, strong) WBStatusProfileView *profileView;///< 用户资料
@property (nonatomic, strong) YYLabel *textLabel; ///< 文本
@property (nonatomic, strong) NSArray <UIView *>*picView; ///< 图片
@property (nonatomic, strong) UIView *retweetBackgroundView; ///< 转发容器
@property (nonatomic, strong) WBStatusCardView *cardView; ///< 卡片
@property (nonatomic, strong) WBStatusTagView *tagView; ///< 下方Tag
@property (nonatomic, strong) WBStatusToolBarView *toolbarView; ///< 工具栏

@property (nonatomic, strong) UIImageView *vipBackgroundView; ///< VIP 自定义背景
// 功能
@property (nonatomic, strong) UIButton *menuButton; ///< 菜单按钮
@property (nonatomic, strong) UIButton *followButton; ///< 关注按钮
// 附带自身属性
@property (nonatomic, weak) WBStatusCell *cell;
@property (nonatomic, strong) WBStatusLayout *layout;
@end

@interface WBStatusCell : YYTableViewCell
@property (nonatomic, strong) WBStatusView *statusView;
- (void)setLayout:(WBStatusLayout *)layout;
@end
