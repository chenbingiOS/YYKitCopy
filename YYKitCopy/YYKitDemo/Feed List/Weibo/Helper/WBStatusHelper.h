//
//  WBStatusHelper.h
//  YYTest
//
//  Created by 陈冰 on 2017/3/29.
//  Copyright © 2017年 GLAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WBStatusHelper : NSObject
/** 将微博API提供的图片URL转换成可用的实际URL */
+ (NSURL *)defaultURLForImageURL:(id)imageURL;

/** 从微博 bundle 里获取图片 (有缓存) */
+ (UIImage *)imageNamed:(NSString *)name;

/* 将 Date 格式化成微博的友好显示 */
+ (NSString *)stringWithTimeLineDate:(NSDate *)date;

/* At正则 例如 @王思聪 */
+ (NSRegularExpression *)regexAt;

/* 表情正则 */
+ (NSRegularExpression *)regexEmoticon;

/* 表情知道 key:[偷笑] value:ImagePath */
+ (NSDictionary *)emoticonDic;

/* 从path创建图片 (有缓存) */
+ (UIImage *)imageWithPath:(NSString *)path;

@end
