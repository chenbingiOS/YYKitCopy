//
//  YYTextEmoticonExampleVC.m
//  YYKitCopy
//
//  Created by 陈冰 on 2017/7/16.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYTextEmoticonExampleVC.h"
#import "YYKit.h"

@interface YYTextEmoticonExampleVC () <YYTextViewDelegate>
@property (nonatomic, assign) YYTextView *textView;
@end

@implementation YYTextEmoticonExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }

    NSMutableDictionary *mapper = [NSMutableDictionary new];
    mapper[@":smile:"] = [self iamgeWithName:@"002"];
    mapper[@":cool:"] = [self iamgeWithName:@"013"];
    mapper[@":biggrin:"] = [self iamgeWithName:@"047"];
    mapper[@":arrow:"] = [self iamgeWithName:@"007"];
    mapper[@":confused:"] = [self iamgeWithName:@"041"];
    mapper[@":cry:"] = [self iamgeWithName:@"010"];
    mapper[@":wink:"] = [self iamgeWithName:@"085"];
    
    YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
    parser.emoticonMapper = mapper;
    
    YYTextLinePositionSimpleModifier *mod = [YYTextLinePositionSimpleModifier new];
    mod.fixedLineHeight = 22;
    
    YYTextView *textView = [YYTextView new];
    textView.text = @"Hahahah:smile:, it\'s emoticons::cool::arrow::cry::wink:\n\nYou can input \":\" + \"smile\" + \":\" to display smile emoticon, or you can copy and paste these emoticons.\n\nSee \'YYTextEmoticonExample.m\' for example.";
    textView.font = [UIFont systemFontOfSize:17];
    textView.textParser = parser;
    textView.size = self.view.size;
    textView.linePositionModifier = mod;
    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    textView.delegate = self;
    if (kiOS7Later) {
        textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    } else {
        textView.height -= 64;
    }
    textView.contentInset = UIEdgeInsetsMake((kiOS7Later?64:0), 10, 10, 10);
    textView.scrollIndicatorInsets = textView.contentInset;
    [self.view addSubview:textView];
    self.textView = textView;
    
    [textView becomeFirstResponder];
}

- (UIImage *)iamgeWithName:(NSString *)name {
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"EmoticonQQ" ofType:@"bundle"]];
    NSString *path = [bundle pathForScaledResource:name ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    YYImage *image = [YYImage imageWithData:data scale:2];
    image.preloadAllAnimatedImageFrames = YES;
    return image;
}

#pragma mark - Action
- (void)edit:(UINavigationItem *)item {
    if (_textView.isFirstResponder) {
        [_textView resignFirstResponder];
    } else {
        [_textView becomeFirstResponder];
    }
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidBeginEditing:(YYTextView *)textView {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(edit:)];
    self.navigationItem.rightBarButtonItem = buttonItem;
}
- (void)textViewDidEndEditing:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem = nil;
}

@end
