//
//  LinPullTableView.m
//  LINPullTableView
//
//  Created by earnestLin on 2019/1/11.
//  Copyright © 2019年 earnestLin. All rights reserved.
//

#import "LinPullTableView.h"

@implementation LinPullTableView

//设置内边距外区域的点击不响应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (point.y < 0)
    {
        return nil;
    }
    return [super hitTest:point withEvent:event];;
}

@end
