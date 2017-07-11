//
//  YYModelExampleVC.m
//  YYTest
//
//  Created by 陈冰 on 2017/7/10.
//  Copyright © 2017年 GLAC. All rights reserved.
//

#import "YYModelExampleVC.h"
#import "YYKit.h"


///////////////////////////////////////////////////////////////

#pragma mark Simple Object Example
@interface YYBook : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) uint64_t pages;
@property (nonatomic, strong) NSDate *publishDate; ///< 发布时间
@end

@implementation YYBook
@end

static void SimpleObjectExample() {
    YYBook *book = [YYBook modelWithJSON:@" \
    {                                       \
        \"name\" : \"Harra Potter\",        \
        \"pages\": 512,                     \
        \"publishDate\": \"2010-12-23\"     \
    }"];
    NSString *bookJSON = [book modelToJSONString];
    NSLog(@"Book: %@", bookJSON);
}

///////////////////////////////////////////////////////////////

#pragma mark Nest Object Example
@interface YYUser : NSObject
@property (nonatomic, assign) uint64_t uid;
@property (nonatomic, copy) NSString *name;
@end
@implementation YYUser
@end

@interface YYRepo : NSObject
@property (nonatomic, assign) uint64_t rid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, strong) YYUser *owner;
@end
@implementation YYRepo
@end

static void NestObjectExample() {
    YYRepo *rope = [YYRepo modelWithJSON:@"         \
    {                                               \
        \"rid\" : 123456789,                        \
        \"name\" : \"YYKit\",                       \
        \"createTime\" : \"2011-06-09T06:24:26Z\",  \
        \"owner\": {                                \
            \"uid\": 22223,                         \
            \"name\":\"chenbing\"                   \
        }                                           \
    }"];
    NSString *repoJSON = [rope modelToJSONString];
    NSLog(@"Repo:%@", repoJSON);
}

///////////////////////////////////////////////////////////////

#pragma mark Container Object Example
@interface YYPhoto : NSObject
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *desc;
@end
@implementation YYPhoto
@end

@interface YYAlbum : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray *photos; ///< NSArray<Photo>
@property (nonatomic, strong) NSDictionary *likedUsers; ///< Key:name(NSString) Value:uesr(YYUser)
@property (nonatomic, strong) NSSet *likeUserIds; ///< Set<NSNumber>
@end

@implementation YYAlbum
//泛型类模型容器属性
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"photo": [YYPhoto class],
             @"likedUsers": [YYUser class],
             @"likedUserIds": [NSNumber class]};
}
@end

static void ContainerObjectExample() {
    YYAlbum *album = [YYAlbum modelWithJSON:@"                  \
    {                                                           \
        \"name\" : \"Happy Birthday\",                          \
        \"photos\" ; [                                          \
                {                                               \
                      \"url\" : \"http://example.com/1.png\",   \
                      \"desc\": \"Happy~\"                      \
                },                                              \
                {                                               \
                      \"url\" : \"http://example.com/2.png\",   \
                      \"desc\": \"Yeah!\"                       \
                }                                               \
            ],                                                  \
        \"likedUsers\" : {                                      \
            \"Jony\" : {                                        \
                \"uid\" : 10001,                                \
                \"name\": \"Jony\"                              \
            },                                                  \
            \"Anna\" : {                                        \
                \"uid\" : 10002,                                \
                \"name\": \"Anna\"                              \
            }                                                   \
        },                                                       \
        \"likedUserIds\" : [                                    \
                          10001,                                \
                          10002                                 \
                          ]                                     \
    }"];
    NSString *albumJSON = [album modelToJSONString];
    NSLog(@"Album: %@", albumJSON);
}

///////////////////////////////////////////////////////////////
#pragma mark Custom Mapper Example
@interface YYMessage : NSObject
@property (nonatomic, assign) uint64_t messageId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *time;
@end

@implementation YYMessage
//模型的自定义属性映射器
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"messageId" : @"i",
             @"content" : @"c",
             @"time" : @"t"};
}
- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic {
    uint64_t timestamp = [dic unsignedLongValueForKey:@"t" default:0];
    self.time = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.0];
    return YES;
}
- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic {
    dic[@"t"] = @([self.time timeIntervalSince1970]*1000).description;
    return YES;
}
@end

static void CustomMapperExample() {
    YYMessage *message = [YYMessage modelWithJSON:@"    \
    {                                                   \
        \"i\" : \"20000000\",                           \
        \"c\" : \"Content\",                            \
        \"t\" : \"1437237598023\"                       \
    }"];
    NSString *messageJSON = [message modelToJSONString];
    NSLog(@"YYMessage: %@", messageJSON);
}

///////////////////////////////////////////////////////////////

@interface YYModelExampleVC ()

@end

@implementation YYModelExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [UILabel new];
    label.size = CGSizeMake(kScreenWidth, 30);
    label.centerY = self.view.height/2-(kiOS7Later?0:32);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"See code in YYModelExample.m";
    [self.view addSubview:label];
 
    [self runExample];
}

- (void)runExample {
    SimpleObjectExample();
    NestObjectExample();
    ContainerObjectExample();
    CustomMapperExample();
}

@end
