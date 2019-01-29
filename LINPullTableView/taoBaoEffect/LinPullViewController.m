//
//  LinPullViewController.m
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/11.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import "LinPullViewController.h"

// view
#import "LinPullTableView.h"
#import "LinBackGroundView.h"

//设置滚动到底部固定tableView显示大小
static CGFloat tableViewBottom = 100;

@interface LinPullViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate>

/** tableView */
@property (nonatomic, strong) LinPullTableView *tableView;
/** topView有需要自己封装处理成地图等功能性view */
@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) LinBackGroundView *bgView;

@end

@implementation LinPullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

#pragma mark - privateMethod
- (void)setUpUI
{
    [self topView];
    [self bgView];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    //这里navi默认为64，实际自己修改
    self.tableView.contentInset = UIEdgeInsetsMake((self.view.frame.size.height - 64 - tableViewBottom), 0, 0, 0);
    //设置进入界面的地图显示大小
    self.tableView.contentOffset = CGPointMake(0, -400);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.y);
    //    通过滚动设置背景alap值
    CGFloat bgAlap = 0;
    //    假定设置了初始偏移卫300  往上滚动300背景设置为1 计算公式为 (这里没有做屏幕适配根据需求可自行设置)
    bgAlap = (scrollView.contentOffset.y + 400) / 300;
    if (bgAlap > 1) {
        bgAlap = 1;
    } else if (bgAlap < 0 ) {
        bgAlap = 0;
    }
    self.bgView.alpha = bgAlap;
    NSLog(@"%f",bgAlap);
}

#pragma mark - tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    
    cell.textLabel.text = [NSString stringWithFormat:@"==%ld==",(long)indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

#pragma mark - GET
- (LinPullTableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[LinPullTableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

// 顶部视图
- (UIView *)topView
{
    if (!_topView)
    {
        _topView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _topView.image = [UIImage imageNamed:@"topviewBg"];
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (LinBackGroundView *)bgView
{
    if (!_bgView)
    {
        _bgView = [[LinBackGroundView alloc] initWithFrame:self.view.bounds];
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.alpha = 0;
        [self.view addSubview:_bgView];
    }
    return _bgView;
}

@end
