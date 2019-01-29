//
//  HomeCell.m
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/15.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import "HomeCell.h"

#import <Masonry.h>

@interface HomeCell ()

// 标题
@property (nonatomic, strong) UILabel *titleLab;
// 子标题
@property (nonatomic, strong) UILabel *subTitleLab;

@end

@implementation HomeCell

#pragma mark - public Method
/**
 设置标题和子标题
 
 @param title 标题
 @param subTitle 子标题
 */
- (void)setupTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self.titleLab.text = title;
    self.subTitleLab.text = subTitle;
}

#pragma mark - life cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self initUI];
    }
    return self;
}

#pragma mark - setUpUI
- (void)initUI
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self titleLab];
    
    [self subTitleLab];
}

#pragma mark - Lazy Load
- (UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab = [[UILabel alloc] init];
        _titleLab.font = [UIFont boldSystemFontOfSize:20.0];
        _titleLab.textColor = [UIColor colorWithRed:0/255.0 green:150/255.0 blue:255/255.0 alpha:1.0];
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.offset(25);
        }];
    }
    return _titleLab;
}

- (UILabel *)subTitleLab
{
    if (!_subTitleLab)
    {
        _subTitleLab = [[UILabel alloc] init];
        _subTitleLab.font = [UIFont systemFontOfSize:16.0];
        _subTitleLab.textColor = [UIColor darkGrayColor];
        _subTitleLab.numberOfLines = 0;
        [self.contentView addSubview:_subTitleLab];
        [_subTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.offset(0);
            make.top.equalTo(self.titleLab.mas_bottom).offset(8);
        }];
    }
    return _subTitleLab;
}

@end
