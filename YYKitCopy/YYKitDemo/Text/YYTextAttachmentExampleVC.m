//
//  YYTextAttachmentExampleVC.m
//  YYKitCopy
//
//  Created by 陈冰 on 2017/7/13.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYTextAttachmentExampleVC.h"
#import "YYKit.h"
#import "YYTextExampleHelper.h"


@interface YYTextAttachmentExampleVC ()
@property (nonatomic, strong) YYLabel *label;
@end
#pragma mark - Test
@implementation YYTextAttachmentExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [YYTextExampleHelper addDebugOptionToViewController:self];
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    UIFont *font = [UIFont systemFontOfSize:16];
    
    {
        NSString *title = @"This is UIImage attachment:";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
        
        UIImage *image = [UIImage imageNamed:@"dribbble64_imageio"];
        image = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:UIImageOrientationUp];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    {
        NSString *title = @"This is UIView attachment: ";
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:title]];
        
        UISwitch *switcher = [UISwitch new];
        [switcher sizeToFit];

        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:switcher contentMode:UIViewContentModeCenter attachmentSize:switcher.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [text appendAttributedString:attachText];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];        
    }
    
    text.font = font;
    
    _label = [YYLabel new];
    _label.userInteractionEnabled = YES;
    _label.numberOfLines = 0;
    _label.textVerticalAlignment = YYTextVerticalAlignmentTop;
    _label.size = CGSizeMake(260, 260);
    _label.center = CGPointMake(self.view.width/2, self.view.height/2 - (kiOS7Later?0:32));
    _label.attributedText = text;
    
    [self.view addSubview:_label];
}


@end
