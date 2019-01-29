//
//  JYPulleyViewController.h
//  JYPulleyController
//
//  Created by JunpuChen on 2018/7/30.
//  Copyright © 2018年 earnestLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYPulleyViewController;

NS_ASSUME_NONNULL_BEGIN

/// 伸缩状态
typedef NS_OPTIONS(NSUInteger, JYPulleyStatus) {
    JYPulleyStatusNone = 1 << 0,            // 不在可视范围
    JYPulleyStatusClosed = 1 << 1,          // 收起
    JYPulleyStatusPartiallyExpand = 1 << 2, // 部分展开
    JYPulleyStatusExpand = 1 << 3,          // 全部展开
};

/// 主内容视图数据源协议
@protocol JYPulleyContentDataSource <NSObject>

/// 主内容试图
- (UIView *)view;

@end

/// 抽屉视图数据源协议
@protocol JYPulleyDrawerDataSource <NSObject>

/// 抽屉视图
- (UIView *)view;

@optional

/// 关闭状态的高度
- (CGFloat)closedHeightInPulleyViewController:(JYPulleyViewController *)pulleyViewController;

/// 部分展开状态的高度
- (CGFloat)partiallyExpandHeightInPulleyViewController:
    (JYPulleyViewController *)pulleyViewController;

/// 全部展开状态的高度
- (CGFloat)expandHeightInPulleyViewController:(JYPulleyViewController *)pulleyViewController;

@end

/// 抽屉视图代理
@protocol JYPulleyDrawerDelegate <NSObject>

@optional

/**
 当抽屉视图状态改变时回调

 @param pulleyViewController pulleyViewController
 @param status 改变后的状态，该状态是唯一的，不存在位移
 */
- (void)pulleyViewController:(JYPulleyViewController *)pulleyViewController
             didChangeStatus:(JYPulleyStatus)status;

/**
 实时回调抽屉视图的滚动进度

 @param pulleyViewController pulleyViewController
 @param progress 滚动进度：0 - 1
 */
- (void)pulleyViewController:(JYPulleyViewController *)pulleyViewController
      drawerDraggingProgress:(CGFloat)progress;

@end

/**
 处理抽屉视图中 scrollView 的协议
    * 当抽屉视图即：drawerDataSource.view 中存在 scrollView 时，需要将 scrollView 中 offset 的改变实
      时传入该方法
    * 默认 JYPulleyViewController 会遵守该协议，并控制抽屉视图中的 scrollView 的可滚动状态
    * 以保证 抽屉视图的拉伸 和 抽屉视图中的 scrollView 保持联动
 */
@protocol JYPulleyDrawerScrollViewDelegate <NSObject>

/// 抽屉视图中的 scrollView 的 offset 改变时
- (void)drawerScrollViewDidScroll:(UIScrollView *)scrollView;

@end

/**
 提供一种类似 iOS10 以上系统地图相类似的控件，底部拥有一个可上拉的抽屉视图
 */
@interface JYPulleyViewController : UIViewController <JYPulleyDrawerScrollViewDelegate>

/// 主内容视图数据源
@property (nonatomic, strong) id<JYPulleyContentDataSource> contentDataSource;

/// 抽屉视图数据源
@property (nonatomic, strong) id<JYPulleyDrawerDataSource> drawerDataSource;

/// 抽屉视图代理
@property (nullable, nonatomic, strong) id<JYPulleyDrawerDelegate> drawerDelegate;

/// 当前状态，注意：当前状态是唯一的，不存在位移
@property (nonatomic, assign, readonly) JYPulleyStatus currentStatus;

/// 支持的状态，可以同时传入多种状态，默认：全部支持
@property (nonatomic, assign) JYPulleyStatus supportedStatus;

/**
 抽屉视图关闭状态高度
 当 drawerDataSource 没有实现 closedHeightInPulleyViewController 时使用该值
 默认：68
 */
@property (nonatomic, assign) CGFloat drawerClosedHeight;

/**
 抽屉视图部分展开状态高度
 当 drawerDataSource 没有实现 partiallyExpandHeightInPulleyViewController 时使用该值
 默认：264
 */
@property (nonatomic, assign) CGFloat drawerPartiallyExpandHeight;

/**
 抽屉视图部分展开状态高度
 当 drawerDataSource 没有实现 expandHeightInPulleyViewController 时使用该值
 默认：占满整个屏幕
 */
@property (nonatomic, assign) CGFloat drawerExpandHeight;

/// 抽屉视图展开状态定部内边距，默认：20
@property (nonatomic, assign) CGFloat drawerExpandTopInset;

/**
 背景遮罩，默认为一个普通的 UIView，背景色为 blackColor，可设置为自己的 view
 注意：dimmingView 的大小将会盖满整个控件
 JYPulleyViewController 会自动给自定义的 dimmingView 添加手势以实现点击遮罩隐藏浮层
 */
@property (nonatomic, strong) UIView *dimmingView;

/// 背景遮罩点击手势
@property (nonatomic, strong, readonly) UITapGestureRecognizer *dimmingViewTapGestureRecognizer;

/// 背景遮罩显示时的不透明度，默认：0.5
@property (nonatomic, assign) CGFloat dimmingOpacity;

/**
 带有 主内容视图数据源 和 抽屉视图数据源 的初始化

 @param contentDataSource 主内容视图数据源
 @param drawerDataSource 抽屉视图数据源
 @return JYPulleyViewController
 */
- (instancetype)initWithContentDataSource:(id<JYPulleyContentDataSource>)contentDataSource
                         drawerDataSource:(id<JYPulleyDrawerDataSource>)drawerDataSource;

/**
 更新当前状态

 @param status 需要更新的状态
 @param animated 是否需要动画

 @warning 传入的 status 状态必须唯一，不可以位移
 */
- (void)updateStatus:(JYPulleyStatus)status animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
