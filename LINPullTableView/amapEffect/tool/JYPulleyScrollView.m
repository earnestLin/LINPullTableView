//
//  JYPulleyScrollView.m
//  JYPulleyController
//
//  Created by JunpuChen on 2018/7/30.
//  Copyright © 2018年 earnestLin. All rights reserved.
//

#import "JYPulleyScrollView.h"

@implementation JYPulleyScrollView

#pragma mark - Override

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self.touchDelegate respondsToSelector:@selector(shouldTouchPulleyScrollView:point:)]) {
        if ([self.touchDelegate shouldTouchPulleyScrollView:self point:point]) {
            UIView *view = [self.touchDelegate viewToReceiveTouch:self point:point];
            CGPoint p = [view convertPoint:point fromView:self];
            return [view hitTest:p withEvent:event];
        }
    }
    return [super hitTest:point withEvent:event];
}

/// 如果 scrollView 上有 button，优先滚动
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
