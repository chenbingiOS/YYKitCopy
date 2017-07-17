

//
//  BCVideoDownloadVC.m
//  YYKitCopy
//
//  Created by  chenbing on 2017/7/17.
//  Copyright © 2017年 DTise. All rights reserved.
//

#import "BCVideoDownloadVC.h"
#import "BCPopHelper.h"
#import "YYKit.h"

@interface BCVideoDownloadVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation BCVideoDownloadVC {
    NSMutableArray *_titles;
    NSMutableArray *_classNames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _titles = @[].mutableCopy;
    _classNames = @[].mutableCopy;
    
    [self addCell:@"输入下载地址" andClass:@"YYModelExampleVC"];
    
    [self.view addSubview:self.tableView];
    [self.tableView reloadData];
}

- (void)addCell:(NSString *)title andClass:(NSString *)className {
    [_titles addObject:title];
    [_classNames addObject:className];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YY"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"YY"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    cell.detailTextLabel.text = @"下载地址：";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
    _contentView.backgroundColor = [UIColor redColor];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:_contentView.bounds];
    imageV.image = [UIImage imageNamed:@"jei"];
    [_contentView addSubview:imageV];
    
    [BCPopHelper sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [BCPopHelper sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [BCPopHelper sharedInstance].popBackgroudColor = [UIColor grayColor];
    [[BCPopHelper sharedInstance] showWithPresentView:_contentView animated:YES];

    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - layz
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
@end
