//
//  LinPullMainViewController.m
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/16.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import "LinPullMainViewController.h"

#import "LinPullTopViewController.h"
#import "LinPullBottomViewController.h"

// tool
#import "JYPulleyViewController.h"

@interface LinPullMainViewController ()<LinPullBottomViewControllerDelegate>

@property (nonatomic, strong) JYPulleyViewController *pulleyViewController;
@property (nonatomic, strong) LinPullTopViewController *topController;
@property (nonatomic, strong) LinPullBottomViewController *bottomController;

@end

@implementation LinPullMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - setupUI
- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"amap";
    
    self.topController = [[LinPullTopViewController alloc] init];
    self.bottomController = [[LinPullBottomViewController alloc] init];
    self.bottomController.delegate = self;
    
    self.pulleyViewController =
    [[JYPulleyViewController alloc] initWithContentDataSource:self.topController
                                             drawerDataSource:self.bottomController];
    self.pulleyViewController.view.frame = self.view.bounds;
    self.pulleyViewController.supportedStatus = JYPulleyStatusClosed | JYPulleyStatusExpand | JYPulleyStatusPartiallyExpand;
    self.pulleyViewController.drawerExpandTopInset = 0;
    self.pulleyViewController.dimmingView.backgroundColor = [UIColor whiteColor];
    self.pulleyViewController.dimmingOpacity = 1;
    self.pulleyViewController.drawerDelegate = self.bottomController;
    
    self.bottomController.drawerScrollDelegate = self.pulleyViewController;
    
    [self.pulleyViewController addChildViewController:self.topController];
    [self.pulleyViewController addChildViewController:self.bottomController];
    [self addChildViewController:self.pulleyViewController];
    
    [self.view addSubview:self.pulleyViewController.view];
    [self.pulleyViewController updateStatus:JYPulleyStatusPartiallyExpand animated:NO];
}

#pragma mark - JYEBMonitorEbikeDetailContentVCDelegate

- (void)linPullBottomViewController:(LinPullBottomViewController *)vc
                  didChangeToExpand:(CGFloat)height
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)linPullBottomViewController:(LinPullBottomViewController *)vc
         didChangeToPartiallyExpand:(CGFloat)height
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)linPullBottomViewController:(LinPullBottomViewController *)vc
         didChangeToClosed:(CGFloat)height
{
    self.navigationController.navigationBarHidden = YES;
}

@end
