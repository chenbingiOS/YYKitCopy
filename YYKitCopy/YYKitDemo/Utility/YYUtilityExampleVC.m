//
//  YYUtilityExampleVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/17.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "YYUtilityExampleVC.h"

@interface YYUtilityExampleVC ()
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;
@end

@implementation YYUtilityExampleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    
    [self addCell:@"Keychain" andClass:@"YYKeychainExampleVC"];

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
