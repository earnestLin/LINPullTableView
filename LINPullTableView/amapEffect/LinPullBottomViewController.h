//
//  LinPullBottomViewController.h
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/16.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import <UIKit/UIKit.h>

// tool
#import "JYPulleyViewController.h"

@class LinPullBottomViewController;

NS_ASSUME_NONNULL_BEGIN

@protocol LinPullBottomViewControllerDelegate <NSObject>

@optional

- (void)linPullBottomViewController:(LinPullBottomViewController *)vc
                  didChangeToClosed:(CGFloat)height;

- (void)linPullBottomViewController:(LinPullBottomViewController *)vc
          didChangeToPartiallyExpand:(CGFloat)height;

- (void)linPullBottomViewController:(LinPullBottomViewController *)vc
                  didChangeToExpand:(CGFloat)height;

@end

@interface LinPullBottomViewController : UIViewController <JYPulleyDrawerDataSource, JYPulleyDrawerDelegate>

/// 处理回调代理
@property (nullable, nonatomic, weak) id<LinPullBottomViewControllerDelegate> delegate;

/// 处理抽屉视图中 scrollView 的代理
@property (nullable, nonatomic, weak) id<JYPulleyDrawerScrollViewDelegate> drawerScrollDelegate;

@end

NS_ASSUME_NONNULL_END
