//
//  LinPullBottomViewController.m
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/16.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import "LinPullBottomViewController.h"

#import <Masonry.h>

static CGFloat const kBottomControllerClosedHeight = 100.0f;

static inline CGFloat kBottomControllerPartiallyExpandHeight() {
    return [UIScreen mainScreen].bounds.size.height - 336.0f;
}

@interface LinPullBottomViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation LinPullBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setupUI

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView reloadData];
}

#pragma mark - JYPulleyDrawerDataSource

- (CGFloat)closedHeightInPulleyViewController:(JYPulleyViewController *)pulleyViewController
{
    return kBottomControllerClosedHeight;
}

- (CGFloat)partiallyExpandHeightInPulleyViewController:(JYPulleyViewController *)pulleyViewController
{
    return kBottomControllerPartiallyExpandHeight();
}

#pragma mark - JYPulleyDrawerDelegate

- (void)pulleyViewController:(JYPulleyViewController *)pulleyViewController didChangeStatus:(JYPulleyStatus)status
{
    if (status == JYPulleyStatusClosed)
    {
        self.tableView.scrollEnabled = NO;
        self.tableView.contentInset =
        UIEdgeInsetsMake(0, 0, kBottomControllerClosedHeight, 0);
        
        if ([self.delegate
             respondsToSelector:@selector(linPullBottomViewController:didChangeToClosed:)]) {
            [self.delegate linPullBottomViewController:self
                                     didChangeToClosed:kBottomControllerClosedHeight];
        }
        
    }

    
    if (status == JYPulleyStatusPartiallyExpand)
    {
        self.tableView.scrollEnabled = NO;
        self.tableView.contentInset =
        UIEdgeInsetsMake(0, 0, kBottomControllerPartiallyExpandHeight(), 0);
        if ([self.delegate respondsToSelector:@selector(linPullBottomViewController:didChangeToPartiallyExpand:)])
        {
            [self.delegate linPullBottomViewController:self didChangeToPartiallyExpand:kBottomControllerPartiallyExpandHeight()];
        }
    }
    
    if (status == JYPulleyStatusExpand)
    {
        self.tableView.scrollEnabled = YES;
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if ([self.delegate respondsToSelector:@selector(linPullBottomViewController:didChangeToPartiallyExpand:)])
        {
            [self.delegate linPullBottomViewController:self didChangeToExpand:0];
        }
    }
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

- (UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
