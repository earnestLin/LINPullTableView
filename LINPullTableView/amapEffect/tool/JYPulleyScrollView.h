//
//  JYPulleyScrollView.h
//  JYPulleyController
//
//  Created by JunpuChen on 2018/7/30.
//  Copyright © 2018年 earnestLin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JYPulleyScrollView;

@protocol JYPulleyScrollViewDelegate <NSObject>

- (BOOL)shouldTouchPulleyScrollView:(JYPulleyScrollView *)scrollView point:(CGPoint)point;

- (UIView *)viewToReceiveTouch:(JYPulleyScrollView *)scrollView point:(CGPoint)point;

@end

@interface JYPulleyScrollView : UIScrollView

@property (nullable, nonatomic, weak) id<JYPulleyScrollViewDelegate> touchDelegate;

@end
