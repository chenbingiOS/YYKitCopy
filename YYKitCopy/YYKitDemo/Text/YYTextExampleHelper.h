//
//  YYTextExampleHelper.h
//  YYKitCopy
//
//  Created by 陈冰 on 2017/7/11.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYTextExampleHelper : NSObject

+(void)addDebugOptionToViewController:(UIViewController *)vc;
+ (void)setDebug:(BOOL)debug;
+ (BOOL)isDebug;

@end
