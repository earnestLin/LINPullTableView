//
//  JYPulleyViewController.m
//  JYPulleyController
//
//  Created by JunpuChen on 2018/7/30.
//  Copyright © 2018年 earnestLin. All rights reserved.
//

#import "JYPulleyViewController.h"

#import "JYPulleyScrollView.h"

@interface JYPulleyViewController () <UIScrollViewDelegate,
                                      UIGestureRecognizerDelegate,
                                      JYPulleyScrollViewDelegate>

/// 主内容视图容器
@property (nonatomic, strong) UIView *contentContainerView;
/// 抽屉内容视图容器
@property (nonatomic, strong) UIView *drawerContainerView;
/// 用于承载 drawerContainerView 和手势传递的 scrollView
@property (nonatomic, strong) JYPulleyScrollView *scrollView;

/// scrollView 滑动手势
@property (nonatomic, strong) UIPanGestureRecognizer *scrollViewPanGestureRecognizer;
/// 背景遮罩点击手势
@property (nonatomic, strong, readwrite) UITapGestureRecognizer *dimmingViewTapGestureRecognizer;

/// 记录最后一次滑动位置
@property (nonatomic, assign) CGPoint lastContentOffSet;
/// 抽屉视图是否可以滚动
@property (nonatomic, assign) BOOL drawerShouldScroll;
/// 当前状态
@property (nonatomic, assign, readwrite) JYPulleyStatus currentStatus;

@end

@implementation JYPulleyViewController

#pragma mark - life cycle

- (instancetype)initWithContentDataSource:(id<JYPulleyContentDataSource>)contentDataSource drawerDataSource:(id<JYPulleyDrawerDataSource>)drawerDataSource {
    if (self = [self initWithNibName:nil bundle:nil]) {
        NSParameterAssert(contentDataSource);
        NSParameterAssert(drawerDataSource);
        _contentDataSource = contentDataSource;
        _drawerDataSource = drawerDataSource;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _drawerClosedHeight = 68.0f;
        _drawerPartiallyExpandHeight = 264.0f;
        _drawerExpandTopInset = 20.0f;
        _dimmingView = [UIView new];
        _dimmingView.backgroundColor = [UIColor blackColor];
        _dimmingOpacity = 0.5f;
        _currentStatus = JYPulleyStatusClosed;
        _supportedStatus = JYPulleyStatusNone
                         | JYPulleyStatusClosed
                         | JYPulleyStatusPartiallyExpand
                         | JYPulleyStatusExpand;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView != self.scrollView) {
        return;
    }

    [self updateDrawerDraggingProgress:scrollView];
    [self updateDimmingViewAlpha:scrollView];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (scrollView != self.scrollView) {
        return;
    }

    JYPulleyStatus newStatus = [self newStatusFromCurrentStatus:self.currentStatus
                                              lastContentOffSet:self.lastContentOffSet
                                                     scrollView:self.scrollView
                                                supportedStatus:self.supportedStatus];
    [self updateStatus:newStatus animated:YES];

}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    if (scrollView != self.scrollView) {
        return;
    }

    self.lastContentOffSet = CGPointMake(targetContentOffset->x, targetContentOffset->y);
    *targetContentOffset = scrollView.contentOffset;

}

#pragma mark - JYPulleyScrollViewDelegate

- (BOOL)shouldTouchPulleyScrollView:(JYPulleyScrollView *)scrollView point:(CGPoint)point {
    CGPoint convertPoint = [self.drawerContainerView convertPoint:point fromView:scrollView];
    return !CGRectContainsPoint(self.drawerContainerView.bounds, convertPoint);
}

- (UIView *)viewToReceiveTouch:(JYPulleyScrollView *)scrollView point:(CGPoint)point {
    if (self.currentStatus == JYPulleyStatusExpand && self.dimmingView) {
        return self.dimmingView;
    }
    return self.contentContainerView;
}

#pragma mark - JYPulleyDrawerScrollViewDelegate

- (void)drawerScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y <= 0) {
        self.drawerShouldScroll = YES;
        scrollView.scrollEnabled = NO;
    } else {
        self.drawerShouldScroll = NO;
        scrollView.scrollEnabled = YES;
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
    shouldRecognizeSimultaneouslyWithGestureRecognizer:
        (UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - public method

/**
 根据伸缩状态处理悬停动作

 @param status 伸缩状态
 */
- (void)updateStatus:(JYPulleyStatus)status animated:(BOOL)animated {

    if (!(self.supportedStatus & status)) {
        return;
    }

    CGFloat stopToMoveTo;
    CGFloat minimumHeight = [self drawerClosedHeight];

    if (status == JYPulleyStatusClosed) {

        stopToMoveTo = minimumHeight;

    } else if (status == JYPulleyStatusPartiallyExpand) {

        stopToMoveTo = [self drawerPartiallyExpandHeight];

    } else if (status == JYPulleyStatusExpand) {

        if ([self drawerExpandHeight] > 0) {
            stopToMoveTo = [self drawerExpandHeight];
        } else {
            stopToMoveTo = self.scrollView.frame.size.height;
        }

    } else {

        stopToMoveTo = 0.0f;
    }

    self.currentStatus = status;

    if (animated) {

        [UIView animateWithDuration:0.3
                              delay:0.0
             usingSpringWithDamping:0.75
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{

                            [self.scrollView
                                setContentOffset:CGPointMake(0, stopToMoveTo - minimumHeight)
                                        animated:NO];

                            if (self.dimmingView) {
                                self.dimmingView.frame =
                                    [self dimmingViewFrameForDrawerPosition:stopToMoveTo];
                            }

                         } completion:nil];

    } else {

        [self.scrollView setContentOffset:CGPointMake(0, stopToMoveTo - minimumHeight)
                                 animated:NO];

        if (self.dimmingView) {
            self.dimmingView.frame = [self dimmingViewFrameForDrawerPosition:stopToMoveTo];
        }
    }

}

#pragma mark - event response

- (void)didRecognizedScrollViewPanGestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer {

    if (!self.drawerShouldScroll) {
        return;
    }

    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {

        CGPoint old = [gestureRecognizer translationInView:self.scrollView];

        if (old.y < 0) {
            return;
        }

        CGPoint offSet =
            CGPointMake(0, self.scrollView.frame.size.height - old.y - [self drawerClosedHeight]);
        self.lastContentOffSet = offSet;
        self.scrollView.contentOffset = offSet;

    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {

        self.drawerShouldScroll = NO;

        JYPulleyStatus newStatus = [self newStatusFromCurrentStatus:self.currentStatus
                                                  lastContentOffSet:self.lastContentOffSet
                                                         scrollView:self.scrollView
                                                    supportedStatus:self.supportedStatus];
        [self updateStatus:newStatus animated:YES];

    }

}

- (void)didRecognizedDimmingViewTapGestureRecognizer:(UITapGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self updateStatus:JYPulleyStatusClosed animated:YES];
    }
}

#pragma mark - private method

- (void)updateDrawerDraggingProgress:(UIScrollView *)scrollView {

    CGFloat drawerClosedHeight = [self drawerClosedHeight];

    if ([self.drawerDelegate
            respondsToSelector:@selector(pulleyViewController:drawerDraggingProgress:)]) {

        CGFloat safeAreaTopInset;

        if (@available(iOS 11.0, *)) {
            safeAreaTopInset = self.view.safeAreaInsets.top;
        } else {
            safeAreaTopInset = self.topLayoutGuide.length;
        }

        CGFloat spaceToDrag =
            self.scrollView.bounds.size.height - safeAreaTopInset - drawerClosedHeight;

        CGFloat dragProgress = fabs(scrollView.contentOffset.y) / spaceToDrag;
        if (dragProgress - 1 > FLT_EPSILON) { //in case greater than 1
            dragProgress = 1.0f;
        }
        // 保留两位小数
        NSString *progress = [NSString stringWithFormat:@"%.2f", dragProgress];
        [self.drawerDelegate pulleyViewController:self drawerDraggingProgress:progress.floatValue];
    }
}

- (void)updateDimmingViewAlpha:(UIScrollView *)scrollView {

    CGFloat safeAreaBottomInset;
    CGFloat drawerClosedHeight = [self drawerClosedHeight];

    if (@available(iOS 11.0, *)) {
        safeAreaBottomInset = self.view.safeAreaInsets.bottom;
    } else {
        safeAreaBottomInset = self.bottomLayoutGuide.length;
    }

    // 背景遮罩颜色变化
    if ((scrollView.contentOffset.y - safeAreaBottomInset) >
        ([self drawerPartiallyExpandHeight] - drawerClosedHeight)) {
        CGFloat progress;
        CGFloat fullRevealHeight = self.scrollView.bounds.size.height;

        if (fullRevealHeight == [self drawerPartiallyExpandHeight]) {
            progress = 1.0;
        } else {
            progress = (scrollView.contentOffset.y -
                        ([self drawerPartiallyExpandHeight] - drawerClosedHeight)) /
                       (fullRevealHeight - [self drawerPartiallyExpandHeight]);
        }

        self.dimmingView.alpha = progress * self.dimmingOpacity;
        self.dimmingView.userInteractionEnabled = YES;

    } else {
        if (self.dimmingView.alpha >= 0.01) {
            self.dimmingView.alpha = 0.0;
            self.dimmingView.userInteractionEnabled = NO;
        }
    }

    self.dimmingView.frame =
        [self dimmingViewFrameForDrawerPosition:scrollView.contentOffset.y + drawerClosedHeight];

}

- (CGRect)dimmingViewFrameForDrawerPosition:(CGFloat)position {
    CGRect dimmingViewFrame = self.dimmingView.frame;
    dimmingViewFrame.origin.y = 0 - position;
    return dimmingViewFrame;
}

- (JYPulleyStatus)newStatusFromCurrentStatus:(JYPulleyStatus)currentStatus
                           lastContentOffSet:(CGPoint)lastContentOffSet
                                  scrollView:(UIScrollView *)scrollView
                             supportedStatus:(JYPulleyStatus)supportedStatus {

    NSMutableArray<NSNumber *> *drawerStops = [NSMutableArray array];
    CGFloat currentDrawerStatusStop = 0.0f;

    if (supportedStatus & JYPulleyStatusClosed) {

        CGFloat collapsedHeight = [self drawerClosedHeight];
        [drawerStops addObject:@(collapsedHeight)];

        if (currentStatus == JYPulleyStatusClosed) {
            currentDrawerStatusStop = collapsedHeight;
        }

    }

    if (supportedStatus & JYPulleyStatusPartiallyExpand) {

        CGFloat partialHeight = [self drawerPartiallyExpandHeight];
        [drawerStops addObject:@(partialHeight)];

        if (currentStatus == JYPulleyStatusPartiallyExpand) {
            currentDrawerStatusStop = partialHeight;
        }

    }

    if (supportedStatus & JYPulleyStatusExpand) {

        CGFloat openHeight = scrollView.bounds.size.height;
        [drawerStops addObject:@(openHeight)];

        if (currentStatus == JYPulleyStatusExpand) {
            currentDrawerStatusStop = openHeight;
        }
    }

    // 取最小值
    CGFloat lowestStop = [[drawerStops valueForKeyPath:@"@min.floatValue"] floatValue];
    CGFloat distanceFromBottomOfView = lowestStop + lastContentOffSet.y;
    CGFloat currentClosestStop = lowestStop;

    JYPulleyStatus cloestValidDrawerStatus = currentStatus;

    for (NSNumber *currentStop in drawerStops) {

        if (fabs(currentStop.floatValue - distanceFromBottomOfView) <
            fabs(currentClosestStop - distanceFromBottomOfView)) {
            currentClosestStop = currentStop.integerValue;
        }

    }

    if (fabs(currentClosestStop - (scrollView.frame.size.height)) <= FLT_EPSILON &&
        supportedStatus & JYPulleyStatusExpand) {

        cloestValidDrawerStatus = JYPulleyStatusExpand;

    } else if (fabs(currentClosestStop - [self drawerClosedHeight]) <= FLT_EPSILON &&
               supportedStatus & JYPulleyStatusClosed) {

        cloestValidDrawerStatus = JYPulleyStatusClosed;

    } else if (supportedStatus & JYPulleyStatusPartiallyExpand){

        cloestValidDrawerStatus = JYPulleyStatusPartiallyExpand;

    }

    return cloestValidDrawerStatus;

}

#pragma mark - set up UI

- (void)setupUI {

    self.view.backgroundColor = [UIColor whiteColor];
    self.lastContentOffSet = CGPointZero;

    [self.scrollView addSubview:self.drawerContainerView];
    [self.view addSubview:self.contentContainerView];
    [self.view addSubview:self.scrollView];

    [self setupDimmingView];

}

- (void)setupDimmingView {
    self.dimmingView.alpha = 0.0;
    [self addTapGestureRecognizerToDimmingViewIfNeeded];
    [self.view insertSubview:self.dimmingView aboveSubview:self.contentContainerView];
}

// 用户可能创建了自己的 dimmingView，则 tap 手势也要重新添加上去
- (void)addTapGestureRecognizerToDimmingViewIfNeeded {

    if (!self.dimmingView) {
        return;
    }

    if (self.dimmingViewTapGestureRecognizer.view == self.dimmingView) {
        return;
    }

    if (!self.dimmingViewTapGestureRecognizer) {
        self.dimmingViewTapGestureRecognizer =
            [[UITapGestureRecognizer alloc]
                initWithTarget:self
                        action:@selector(didRecognizedDimmingViewTapGestureRecognizer:)];
    }

    [self.dimmingView addGestureRecognizer:self.dimmingViewTapGestureRecognizer];
    // UIImageView 默认 userInteractionEnabled 为NO，为了兼容 UIImageView，这里必须主动设置为 YES
//    self.dimmingView.userInteractionEnabled = YES;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    [self.contentContainerView addSubview:self.contentDataSource.view];
    [self.contentContainerView sendSubviewToBack:self.contentDataSource.view];

    [self.drawerContainerView addSubview:self.drawerDataSource.view];
    [self.drawerContainerView sendSubviewToBack:self.drawerDataSource.view];

    self.contentContainerView.frame = self.view.bounds;

    CGFloat safeAreaTopInset;
    CGFloat safeAreaBottomInset;

    if (@available(iOS 11.0, *)) {
        safeAreaTopInset = self.view.safeAreaInsets.top;
        safeAreaBottomInset = self.view.safeAreaInsets.bottom;
    } else {
        safeAreaTopInset = self.topLayoutGuide.length;
        safeAreaBottomInset = self.bottomLayoutGuide.length;
    }

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0);
    }

    CGFloat minimumHeight = [self drawerClosedHeight];

    if (self.supportedStatus & JYPulleyStatusExpand) {

        self.scrollView.frame =
            CGRectMake(0,
                       self.drawerExpandTopInset + safeAreaTopInset,
                       self.view.bounds.size.width,
                       self.view.bounds.size.height - self.drawerExpandTopInset - safeAreaTopInset);

    } else {
        CGFloat adjustedTopInset = self.supportedStatus & JYPulleyStatusPartiallyExpand
                                       ? [self drawerPartiallyExpandHeight]
                                       : [self drawerClosedHeight];

        self.scrollView.frame = CGRectMake(0, self.view.bounds.size.height - adjustedTopInset,
                                           self.view.bounds.size.width, adjustedTopInset);
    }

    self.drawerContainerView.frame =
        CGRectMake(0, self.scrollView.bounds.size.height - minimumHeight,
                   self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);

    self.scrollView.contentSize =
        CGSizeMake(self.scrollView.bounds.size.width,
                   (self.scrollView.bounds.size.height - minimumHeight) +
                       self.scrollView.bounds.size.height - safeAreaBottomInset);

    self.dimmingView.frame =
        CGRectMake(0.0, 0.0, self.view.bounds.size.width,
                   self.view.bounds.size.height + self.scrollView.contentSize.height);

    [self updateStatus:self.currentStatus animated:NO];

}

#pragma mark - setter

- (void)setCurrentStatus:(JYPulleyStatus)currentStatus {
    _currentStatus = currentStatus;

    // 通知外部状态变化
    if ([self.drawerDelegate respondsToSelector:@selector(pulleyViewController:didChangeStatus:)]) {
        [self.drawerDelegate pulleyViewController:self didChangeStatus:currentStatus];
    }
}

- (void)setDimmingView:(UIView *)dimmingView {
    if (![self isViewLoaded]) {
        _dimmingView = dimmingView;
    } else {
        [self.view insertSubview:dimmingView belowSubview:_dimmingView];
        [_dimmingView removeFromSuperview];
        _dimmingView = dimmingView;
        [self.view setNeedsLayout];
    }
    [self addTapGestureRecognizerToDimmingViewIfNeeded];
}

#pragma mark - getter

- (UIView *)contentContainerView {
    if (!_contentContainerView) {
        _contentContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _contentContainerView.backgroundColor = [UIColor clearColor];
    }
    return _contentContainerView;
}

- (UIView *)drawerContainerView {
    if (!_drawerContainerView) {
        _drawerContainerView = [[UIView alloc] initWithFrame:self.view.bounds];
        _drawerContainerView.backgroundColor = [UIColor clearColor];
    }
    return _drawerContainerView;
}

- (JYPulleyScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[JYPulleyScrollView alloc] initWithFrame:self.drawerContainerView.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.touchDelegate = self;
        [_scrollView addGestureRecognizer:self.scrollViewPanGestureRecognizer];
    }
    return _scrollView;
}

- (UIPanGestureRecognizer *)scrollViewPanGestureRecognizer {
    if (!_scrollViewPanGestureRecognizer) {
        _scrollViewPanGestureRecognizer =
            [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizedScrollViewPanGestureRecognizer:)];
        _scrollViewPanGestureRecognizer.delegate = self;
    }
    return _scrollViewPanGestureRecognizer;
}

- (CGFloat)drawerClosedHeight {
    if ([self.drawerDataSource respondsToSelector:@selector(closedHeightInPulleyViewController:)]) {
        return [self.drawerDataSource closedHeightInPulleyViewController:self];
    }
    return _drawerClosedHeight;
}

- (CGFloat)drawerPartiallyExpandHeight {
    if ([self.drawerDataSource
            respondsToSelector:@selector(partiallyExpandHeightInPulleyViewController:)]) {
        return [self.drawerDataSource partiallyExpandHeightInPulleyViewController:self];
    }
    return _drawerPartiallyExpandHeight;
}

- (CGFloat)drawerExpandHeight {
    if ([self.drawerDataSource respondsToSelector:@selector(expandHeightInPulleyViewController:)]) {
        return [self.drawerDataSource expandHeightInPulleyViewController:self];
    }
    return _drawerExpandHeight;
}

@end
