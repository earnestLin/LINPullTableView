//
//  HomeCell.h
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/15.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCell : UITableViewCell

/**
 设置标题和子标题
 
 @param title 标题
 @param subTitle 子标题
 */
- (void)setupTitle:(NSString *)title subTitle:(NSString *)subTitle;

@end

NS_ASSUME_NONNULL_END
