//
//  HomeViewController.m
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/9.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import "HomeViewController.h"
#import "LinPullViewController.h"
#import "LinPullMainViewController.h"

#import "HomeCell.h"

static NSString * const TableCellIdentifier = @"TableViewCell";

@interface HomeViewController ()

/** 数据源 */
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HomeViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)initUI
{
    self.title = @"首页";
    self.tableView.rowHeight = 100;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:TableCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[HomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableCellIdentifier];
    }
    
    NSDictionary *dict = self.dataSource[indexPath.row];
    [cell setupTitle:dict[@"title"] subTitle:dict[@"subTitle"]];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.dataSource[indexPath.row];
    
    // 建议大家使用应用到项目中时使用安全取值,我这里先不做处理
    NSString *className = dict[@"className"];
    
    if (className)
    {
        UIViewController *vc = [[NSClassFromString(className) alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Lazy Load

- (NSArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = @[
                        @{
                            @"title" : @"方案一",
                            @"subTitle" : @"淘宝物流推拉方案",
                            @"className" : @"LinPullViewController",
                            },
                        @{
                            @"title" : @"方案二",
                            @"subTitle" : @"高德地图推拉方案",
                            @"className" : @"LinPullMainViewController",
                            },
                        ];
    }
    return _dataSource;
}

@end
