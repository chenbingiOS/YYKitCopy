//
//  WBStatusLayout.m
//  YYTest
//
//  Created by 陈冰 on 2017/3/23.
//  Copyright © 2017年 GLAC. All rights reserved.
//

#import "WBStatusLayout.h"
#import "WBStatusHelper.h"

/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 https://www.zybang.com/question/bd3d73c504008384be0ec0d1daa33bec.html
 */
@implementation WBTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34; // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    return self;
}
- (void)modifyLines:(NSArray<YYTextLine *> *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    // CGFloat ascent = font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row * lineHeight;
        line.position = position;
    }
}
- (id)copyWithZone:(NSZone *)zone {
    WBTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}
- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
//    CGFloat ascent = _font.ascender;
//    CGFloat deascent = _font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}
@end


/**
 微博的文本中，某些嵌入的图片需要从网上下载，这里简单做个封装
 */
@interface WBTextImageViewAttachment : YYTextAttachment
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, assign) CGSize size;
@end

@implementation WBTextImageViewAttachment {
    UIImageView *_imageView;
}

- (void)setContent:(id)content {
    _imageView = content;
}
- (id)content {
    /// UIImageView 只能在主线程上访问
    if (pthread_main_np() == 0) return nil;
    
    if (_imageView) return _imageView;
    
    /// 第一次获取时候（应该是在文本渲染完成，需要添加附件视图时候），初始化图片视图，并且下载图片
    /// 这里改成 YYAnimatedImageView 就能支持 GIF/APNG/WebP 动画
    _imageView = [UIImageView new];
    _imageView.size = _size;
    [_imageView setImageURL:_imageURL];
    return _imageView;
}


@end


@implementation WBStatusLayout
- (instancetype)initWithStatus:(WBStatus *)status style:(WBLayoutStyle)style {
    if (!status || !status.user) return nil;
    
    self = [super init];
    _status = status;
    _style = style;
    [self layout];
    return self;
}

- (void)layout {
    [self _layout];
}

- (void)updateDate {
    [self _layoutSource];
}

- (void)_layout {
    _marginTop = kWBCellTopMargin;
    _titleHeight = 0;
    _profileHeight = 0;
    _textHeight = 0;
    _retweetHeight = 0;
    _retweetTextHeight = 0;
    _retweetPicHeight = 0;
    _retweetCardHeight = 0;
    _picHeight = 0;
    _cardHeight = 0;
    _toolbarHeight = kWBCellToolbarHeight;
    _marginBottom = kWBCellToolbarBottomMargin;
    
    // 文本排版，计算布局
    [self _layoutTitle];
    [self _layoutProfile];
    [self _layoutRetweet];
    
    if (_retweetHeight == 0) {
        [self _layoutPics];
        if (_picHeight == 0) {
            [self _layoutCard];
        }
    }
    [self _layoutText];
    [self _layoutTag];
    [self _layoutToolbar];
    
    // 计算总高度
    _height = 0;
    _height += _marginTop;
    _height += _titleHeight;
    _height += _profileHeight;
    _height += _textHeight;
    if (_retweetHeight > 0) {
        _height += _retweetHeight;
    } else if (_picHeight > 0) {
        _height += _picHeight;
    } else if (_cardHeight > 0) {
        _height += _cardHeight;
    }
    
    if (_tagHeight > 0) {
        _height += _tagHeight;
    } else {
        if (_picHeight > 0 || _cardHeight > 0) {
            _height += kWBCellPadding;
        }
    }
    
    _height += _toolbarHeight;
    _height += _marginBottom;
}

- (void)_layoutPics {}
- (void)_layoutCard {}
- (void)_layoutText {}
- (void)_layoutTag {}
- (void)_layoutToolbar {}

- (void)_layoutTitle {
    _titleHeight = 0;
    _titleTextLayout = nil;
    
    WBStatusTitle *title = _status.title;
    if (title.text.length == 0) return;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title.text];
    if (title.iconURL) {
        NSAttributedString *icon = [self _attachmentWithFontSize:kWBCellTitlebarFontSize imageURL:title.iconURL shrink:NO];
        if (icon) {
            [text insertAttributedString:icon atIndex:0];
        }
    }
    text.color = kWBCellToolbarTitleColor;
    text.font = [UIFont systemFontOfSize:kWBCellTitlebarFontSize];
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenHeight - 100, kWBCellTitleHeight)];
    _titleTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    _titleHeight = kWBCellTitleHeight;
}

- (void)_layoutProfile {
    [self _layoutName];
    [self _layoutSource];
    _profileHeight = kWBCellProfileHeight;
}
// 名字
- (void)_layoutName {
    WBUser *user = _status.user;
    NSString *nameStr = nil;
    if (user.remark.length > 0) {
        nameStr = user.remark;
    } else if (user.screenName.length > 0) {
        nameStr = user.screenName;
    } else {
        nameStr = user.name;
    }
    
    if (nameStr.length == 0) {
        _nameTextLayou = nil;
        return;
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    
    // 蓝V
    if (user.userVerifyType == WBUserVerifyTypeOrganization) {
        UIImage *blueImage = [WBStatusHelper imageNamed:@"avatar_enterprise_vip"];
        NSAttributedString *blueText = [self _attachmentWithFontSize:kWBCellNameFontSize image:blueImage shrink:NO];
        [nameText appendString:@" "];
        [nameText appendAttributedString:blueText];
    }
    
    // VIP
    if (user.mbrank > 0) {
        UIImage *yellowVImage = [WBStatusHelper imageNamed:[NSString stringWithFormat:@"common_icon_membership_level%d", user.mbrank]];
        if (!yellowVImage) {
            yellowVImage = [WBStatusHelper imageNamed:@"common_icon_membership"];
        }
        NSAttributedString *vipText = [self _attachmentWithFontSize:kWBCellNameFontSize image:yellowVImage shrink:NO];
        [nameText appendString:@" "];
        [nameText appendAttributedString:vipText];
    }
    
    nameText.font = [UIFont systemFontOfSize:kWBCellNameFontSize];
    nameText.color = user.mbrank > 0 ? kWBCellNameOrangeColor : kWBCellNameNormalColor;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayou = [YYTextLayout layoutWithContainer:container text:nameText];
}
// 时间和来源
- (void)_layoutSource {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *createTime = [WBStatusHelper stringWithTimeLineDate:_status.createdAt];
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText appendString:@"  "];
        timeText.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        timeText.color = kWBCellTimeNormalColor;
        [sourceText appendAttributedString:timeText];
    }
    
    // 来自XXX
    if (_status.source.length) {
        // <a href="sinaweibo://customweibosource" rel="nofollow">iPhone 5siPhone 5s</a>
        static NSRegularExpression *hrefRegex, *textRegex;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            hrefRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=href=\").+(?=\" )" options:kNilOptions error:NULL];
            /*
             类 NSRegularExpression 正则表达式
             http://www.jianshu.com/p/a784c12c498c
             
             regularExpressionWithPattern:options:error:NULL
             error:(NSError **)error 对象的指针用 NULL
             http://blog.csdn.net/crayondeng/article/details/18954999
             */
            textRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=>).+(?=<)" options:kNilOptions error:NULL];
        });
        NSTextCheckingResult *hrefResult, *textResult;
        hrefResult = [hrefRegex firstMatchInString:_status.source options:kNilOptions range:NSMakeRange(0, _status.source.length)];
        textResult = [textRegex firstMatchInString:_status.source options:kNilOptions range:NSMakeRange(0, _status.source.length)];
        NSString *href = nil, *text = nil;
        if (hrefResult && textResult &&
            hrefResult.range.location != NSNotFound &&
            textResult.range.location != NSNotFound ) {
            href = [_status.source substringWithRange:hrefResult.range];
            text = [_status.source substringWithRange:textResult.range];
        }
        if (href.length && text.length) {
            NSMutableAttributedString *from = [NSMutableAttributedString new];
            [from appendString:[NSString stringWithFormat:@"来自 %@",text]];
            from.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
            from.color = kWBCellTimeNormalColor;
            if (_status.sourceAllowClick > 0) {
                NSRange range = NSMakeRange(3, text.length);
                [from setColor:kWBCellTextHighlightColor range:range];
                YYTextBackedString *backed = [YYTextBackedString stringWithString:href];
                [from setTextBackedString:backed range:range];
                
                YYTextBorder *border = [YYTextBorder new];
                border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
                border.fillColor = kWBCellTextHighlightBackgroundColor;
                border.cornerRadius = 3;
                YYTextHighlight *highlight = [YYTextHighlight new];
                if (href) highlight.userInfo = @{kWBLinkHrefName : href};
                [highlight setBackgroundBorder:border];
                [from setTextHighlight:highlight range:range];
            }
            
            [sourceText appendAttributedString:from];
        }
    }
    
    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}
// 转发
- (void)_layoutRetweet {
    _retweetHeight = 0;
    [self _layoutRetweetedText];
    [self _layoutRetweetPics];
    if (_retweetPicHeight == 0) {
        [self _layoutRetweetCard];
    }
    _retweetHeight = _retweetTextHeight;
    if (_retweetPicHeight > 0) {
        _retweetHeight += _retweetPicHeight;
        _retweetHeight += kWBCellPadding;
    } else if (_retweetCardHeight > 0) {
        _retweetHeight += _retweetCardHeight;
        _retweetHeight += kWBCellPadding;
    }
}
// 转发的内容
- (void)_layoutRetweetedText {
    _retweetHeight = 0;
    _retweetTextLayout = nil;
    NSMutableAttributedString *text = [self _textWithStatus:_status.retweetedStatus isRetweet:YES fontSize:kWBCellTextFontRetweetSize textColor:kWBCellTextSubTitleColor];
    if (text.length == 0) return;

    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontRetweetSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _retweetTextLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_retweetTextLayout)  return;
    
    _retweetTextHeight = [modifier heightForLineCount:_retweetTextLayout.lines.count];
}
// 转发的图片
- (void)_layoutRetweetPics {
//    [self]
}

- (void)_layoutPicsWithStatus:(WBStatus *)status isRetweet:(BOOL)isRetweet {
    if (isRetweet) {
        _retweetPicSize = CGSizeZero;
        _retweetHeight = 0;
    } else {
        _picSize = CGSizeZero;
        _picHeight = 0;
    }
    if (status.pics.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_2 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    
}

// 转发的卡片
- (void)_layoutRetweetCard {}

- (NSMutableAttributedString *)_textWithStatus:(WBStatus *)status isRetweet:(BOOL)isRetweet fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor {
    if (!status) return nil;
    
    NSMutableString *string = status.text.mutableCopy;
    if (string.length == 0) return nil;
    
    if (isRetweet) {
        NSString *name = status.user.name;
        if (name.length == 0) {
            name = status.user.screenName;
        }
        if (name) {
            NSString *insert = [NSString stringWithFormat:@"@%@:", name];
            [string insertString:insert atIndex:0];
        }
    }
    
    // 字体
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    // 高亮状态背景
    YYTextBorder *highlightBorder = [YYTextBorder new];
    highlightBorder.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
    highlightBorder.cornerRadius = 3;
    highlightBorder.fillColor = kWBCellTextHighlightBackgroundColor;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
    text.font = font;
    text.color = textColor;
    
    // 根据 urtStruct 中每个 URL.shortURL 来匹配文本，将其替换为图标+好友描述
    for (WBURL *wburl in status.urlStruct) {
        if (wburl.shortURL.length == 0) continue;
        if (wburl.urlTitle.length == 0) continue;
        
        NSString *urlTitle = wburl.urlTitle;
        if (urlTitle.length > 27) {
            urlTitle = [[urlTitle substringToIndex:27] stringByAppendingString:YYTextTruncationToken];
        }
        
        NSRange searchRange = NSMakeRange(0, text.string.length);
        do {
            NSRange range = [text.string rangeOfString:wburl.shortURL options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;
            
            if (range.location + range.length == text.length) {
                if (status.pageInfo.pageID && wburl.pageID &&
                    [wburl.pageID isEqualToString:status.pageInfo.pageID]) {
                    if ((!isRetweet && !status.retweetedStatus) ||
                         isRetweet) {
                        if (status.pics.count == 0) {
                            [text replaceCharactersInRange:range withString:@""];
                            break; // cut the tail, show with card
                        }
                    }
                }
            }
            
            if ([text attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                // 替换的内容
                NSMutableAttributedString *replace = [[NSMutableAttributedString alloc] initWithString:urlTitle];
                if (wburl.urlTypePic.length) {
                    // 链接头部有个图片附件（要从网络上获取）
                    NSURL *picURL = [WBStatusHelper defaultURLForImageURL:wburl.urlTypePic];
                    UIImage *image = [[YYImageCache sharedCache] getImageForKey:picURL.absoluteString];
                    NSAttributedString *pic = (image && !wburl.pics.count) ? [self _attachmentWithFontSize:fontSize image:image shrink:YES] : [self _attachmentWithFontSize:fontSize imageURL:wburl.urlTypePic shrink:YES];
                    [replace insertAttributedString:pic atIndex:0];
                }
                replace.font = font;
                replace.color = kWBCellTextHighlightColor;
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkURLName : wburl};
                [replace setTextHighlight:highlight range:NSMakeRange(0, replace.length)];
                
                // 添加被替换的原始字符串，用户复制
                YYTextBackedString *backed = [YYTextBackedString stringWithString:[text.string substringWithRange:range]];
                [replace setTextBackedString:backed range:NSMakeRange(0, replace.length)];
                
                // 替换
                [text replaceCharactersInRange:range withAttributedString:replace];
                
                searchRange.location = searchRange.location + (replace.length ? replace.length : 1);
                if (searchRange.location + 1 >= text.length) break;
                searchRange.length = text.length - searchRange.location;
            } else {
                searchRange.location = searchRange.location + (searchRange.length ? searchRange.length : 1);
                if (searchRange.location + 1 >= text.length) break;
                searchRange.length = text.length - searchRange.location;
            }
        } while (1);
    }
    
    // 根据 topicStruct 中每个 Topic.topicTitle 来匹配文本，标记为话题
    for (WBTopic *topic in status.topicStruct) {
        if (topic.topicTitle.length == 0) continue;
        NSString *topicTitle = [NSString stringWithFormat:@"#%@#", topic.topicTitle];
        NSRange searchRange = NSMakeRange(0, text.string.length);
        do {
            NSRange range = [text.string rangeOfString:topicTitle options:kNilOptions range:searchRange];
            if (range.location == NSNotFound) break;
            
            if ([text attribute:YYTextHighlightAttributeName atIndex:range.location] == nil) {
                [text setColor:kWBCellTextHighlightColor range:range];
                
                // 高亮状态
                YYTextHighlight *highlight = [YYTextHighlight new];
                [highlight setBackgroundBorder:highlightBorder];
                // 数据信息，用于稍后用户点击
                highlight.userInfo = @{kWBLinkTopicName : topic};
                [text setTextHighlight:highlight range:range];
            }
            
            searchRange.location = searchRange.location + (searchRange.length ? searchRange.length : 1);
            if (searchRange.location + 1 >= text.length) break;
            searchRange.length = text.length - searchRange.location;
        } while (1);
    }
    
    // 匹配 @用户名
    NSArray *atResults = [[WBStatusHelper regexAt] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    for (NSTextCheckingResult *at in atResults) {
        if (at.range.location == NSNotFound && at.range.length <= 1) continue;
        if ([text attribute:YYTextHighlightAttributeName atIndex:at.range.location] == nil) {
            [text setColor:kWBCellTextHighlightColor range:at.range];
            
            // 高亮状态
            YYTextHighlight *highlight = [YYTextHighlight new];
            [highlight setBackgroundBorder:highlightBorder];
            // 数据信息，用于稍后用户点击
            highlight.userInfo = @{kWBLinkAtName : [text.string substringWithRange:NSMakeRange(at.range.location + 1, at.range.length - 1)]};
            [text setTextHighlight:highlight range:at.range];
        }
    }
    
    // 匹配[表情]
    NSArray <NSTextCheckingResult *> *emoticonResults = [[WBStatusHelper regexEmoticon] matchesInString:text.string options:kNilOptions range:text.rangeOfAll];
    NSUInteger emoClipLength = 0;
    for (NSTextCheckingResult *emo in emoticonResults) {
        if (emo.range.location == NSNotFound && emo.range.length <= 1) continue;
        
        NSRange range = emo.range;
        range.location -= emoClipLength;
        if ([text attribute:YYTextHighlightAttributeName atIndex:range.location]) continue;
        if ([text attribute:YYTextAttachmentAttributeName atIndex:range.location]) continue;
        NSString *emoString = [text.string substringWithRange:range];
        NSString *imagePath = [WBStatusHelper emoticonDic][emoString];
        UIImage *image = [WBStatusHelper imageWithPath:imagePath];
        if (!image) continue;
        
        NSAttributedString *emoText = [NSAttributedString attachmentStringWithEmojiImage:image fontSize:fontSize];
        [text replaceCharactersInRange:range withAttributedString:emoText];
        emoClipLength += range.length - 1;
    }
    
    return text;
}

/**
 attachment 附件
 附件的字体，图片，是否需要缩小
 */
- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize imageURL:(NSString *)imageURL shrink:(BOOL)shrink {
    /*
     微博 URL 嵌入的图片，比临近的字体要小一圈。。
     这里模拟一下 Heiti SC 字体，然后把图片缩小一下。
     */
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14*fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent-(bounding.size.height + bounding.origin.y), 0, descent+bounding.origin.y, 0);
    CGSize size = CGSizeMake(fontSize, fontSize);
    
    if (shrink) {
        // 缩小
        CGFloat scale = 1/10.0;
        contentInsets.top += fontSize*scale;
        contentInsets.bottom += fontSize*scale;
        contentInsets.left += fontSize*scale;
        contentInsets.right += fontSize*scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        size = CGSizeMake(fontSize-fontSize*scale*2, fontSize-fontSize*scale*2);
        size = CGSizePixelRound(size);
    }
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    WBTextImageViewAttachment *attachment = [WBTextImageViewAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.size = size;
    attachment.imageURL = [WBStatusHelper defaultURLForImageURL:imageURL];
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}

- (NSAttributedString *)_attachmentWithFontSize:(CGFloat)fontSize image:(UIImage *)image shrink:(BOOL)shrink {
    // Heiti SC 字体。。
    CGFloat ascent = fontSize * 0.86;
    CGFloat descent = fontSize * 0.14;
    CGRect bounding = CGRectMake(0, -0.14*fontSize, fontSize, fontSize);
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(ascent-(bounding.size.height + bounding.origin.y), 0, descent+bounding.origin.y, 0);
    
    YYTextRunDelegate *delegate = [YYTextRunDelegate new];
    delegate.ascent = ascent;
    delegate.descent = descent;
    delegate.width = bounding.size.width;
    
    YYTextAttachment *attachment = [YYTextAttachment new];
    attachment.contentMode = UIViewContentModeScaleAspectFit;
    attachment.contentInsets = contentInsets;
    attachment.content = image;
    
    if (shrink) {
        // 缩小
        CGFloat scale = 1/10.0;
        contentInsets.top += fontSize * scale;
        contentInsets.bottom += fontSize * scale;
        contentInsets.left += fontSize * scale;
        contentInsets.right += fontSize * scale;
        contentInsets = UIEdgeInsetPixelFloor(contentInsets);
        attachment.contentInsets = contentInsets;
    }
    
    NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:YYTextAttachmentToken];
    [atr setTextAttachment:attachment range:NSMakeRange(0, atr.length)];
    CTRunDelegateRef ctDelegate = delegate.CTRunDelegate;
    [atr setRunDelegate:ctDelegate range:NSMakeRange(0, atr.length)];
    if (ctDelegate) CFRelease(ctDelegate);
    
    return atr;
}
@end
