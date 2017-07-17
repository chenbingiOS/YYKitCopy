//
//  BCPopHelper.h
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/17.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 关闭按钮的位置 */
typedef NS_ENUM(NSInteger, ButtonPositionType) {
    ButtonPositionTypeNone = 0, ///< 无
    ButtonPositionTypeLeft = 1 << 0, ///< 左上角
    ButtonPositionTypeRight = 2 << 0 ///< 右上角
};

/** 蒙板的背景色 */
typedef NS_ENUM(NSInteger, ShadeBackgroundType) {
    ShadeBackgroundTypeGradient = 0, ///< 渐变色
    ShadeBackgroundTypeSolid = 1 << 0 ///< 固定色
};

typedef void(^completeBlock)(void);

@interface BCPopHelper : NSObject

@property (assign, nonatomic) BOOL tapOutsideToDismiss; ///<点击蒙板是否弹出视图消失
@property (assign, nonatomic) ButtonPositionType closeButtonType;///<关闭按钮的类型
@property (assign, nonatomic) ShadeBackgroundType shadeBackgroundType;///<蒙板的背景色

/**
 *  创建一个实例
 *
 *  @return BCPopHelper 对象
 */
+ (BCPopHelper *)sharedInstance;
/**
 *  弹出要展示的View
 *
 *  @param presentView 显示 View 的容器
 *  @param animated    是否动画
 */
- (void)showWithPresentView:(UIView *)presentView animated:(BOOL)animated;
/**
 *  关闭弹出视图
 *
 *  @param complete 完成回调
 */
- (void)closeWithBlcok:(void(^)())complete;

/**
 隐藏弹出空间

 @param animated 是否动画
 @param completion 完成回调
 */
- (void)hideAnimated:(BOOL)animated withCompletionBlock:(void(^)())completion;
@end
