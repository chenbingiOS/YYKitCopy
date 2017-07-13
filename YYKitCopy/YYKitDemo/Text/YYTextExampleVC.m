//
//  YYTextExampleVC.m
//  YYKitCopy
//
//  Created by 陈冰 on 2017/7/11.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYTextExampleVC.h"

@interface YYTextExampleVC ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation YYTextExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addCell:@"Text Attributes 1" andClass:@"YYTextAttributeExampleVC"];
    [self addCell:@"Text Attributes 2" andClass:@"YYTextTagExampleVC"];
    [self addCell:@"Text Attachments" andClass:@"YYTextAttachmentExampleVC"];
    [self addCell:@"Feed List Demo" andClass:@"YYFeedListDemoExample"];
    [self addCell:@"Text Edit" andClass:@"YYTextEditExample"];
    [self addCell:@"Text Parser (Markdown)" andClass:@"YYTextMarkdownExample"];
    [self addCell:@"Text Parser (Emoticon)" andClass:@"YYTextEmoticonExample"];
    [self addCell:@"Text Binding" andClass:@"YYTextBindingExample"];
    [self addCell:@"Copy and Paste" andClass:@"YYTextCopyPasteExample"];
    [self addCell:@"Undo and Redo" andClass:@"YYTextUndoRedoExample"];
    [self addCell:@"Ruby Annotation" andClass:@"YYTextRubyExample"];
    [self addCell:@"Async Display" andClass:@"YYTextAsyncExample"];
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title andClass:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = [class new];
        ctrl.title = self.titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
