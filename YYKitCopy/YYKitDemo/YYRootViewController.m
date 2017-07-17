//
//  YYRootViewController.m
//  YYTest
//
//  Created by 陈冰 on 2017/7/10.
//  Copyright © 2017年 GLAC. All rights reserved.
//

#import "YYRootViewController.h"

@interface YYRootViewController ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation YYRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YYKit Example";
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addCell:@"Model" andClass:@"YYModelExampleVC"];
    [self addCell:@"Image" andClass:@"YYImageExampleVC"];
    [self addCell:@"Text" andClass:@"YYTextExampleVC"];
    [self addCell:@"Utility" andClass:@"YYUtilityExampleVC"];
    [self addCell:@"Feed List Demo" andClass:@"YYFeedListExampleVC"];
    
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
