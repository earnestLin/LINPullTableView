//
//  LinPullTopViewController.m
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/16.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import "LinPullTopViewController.h"

#import <Masonry.h>

@interface LinPullTopViewController ()

@property (nonatomic, strong) UIButton *leftBackButton;

@end

@implementation LinPullTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - setupUI

- (void)setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgView.image = [UIImage imageNamed:@"topviewBg"];
    [self.view addSubview:imgView];
    
    self.leftBackButton = [[UIButton alloc] init];
    self.leftBackButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.leftBackButton setImage:[UIImage imageNamed:@"icon_return"]
                     forState:UIControlStateNormal];
    
    [self.view addSubview:self.leftBackButton];
    [self.leftBackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(20);
        make.height.width.mas_equalTo(60);
    }];
    
    [self.leftBackButton addTarget:self
                        action:@selector(leftBackButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - event response

- (void) leftBackButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
