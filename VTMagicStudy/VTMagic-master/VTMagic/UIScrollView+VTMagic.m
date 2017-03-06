//
//  UIScrollView+VTMagic.m
//  VTMagic
//
//  Created by tianzhuo on 15/7/9.
//  Copyright (c) 2015年 tianzhuo. All rights reserved.
//

#import "UIScrollView+VTMagic.h"

@implementation UIScrollView (VTMagic)

- (BOOL)vtm_isNeedDisplayWithFrame:(CGRect)frame preloading:(BOOL)preloading {
    // UIScrollView 的可见范围，只是针对横向滚动的情况
    CGRect visibleRect = (CGRect){CGPointMake(self.contentOffset.x, 0), self.frame.size};
    // 需要判断的区域跟可视区域有没有交叉的地方
    CGRect intersectRegion = CGRectIntersection(frame, visibleRect);
    // 是否在屏幕上可见
    BOOL isOnScreen =  !CGRectIsNull(intersectRegion) || !CGRectIsEmpty(intersectRegion);
    if (!preloading) {
        BOOL isNotBorder = 0 != (int)self.contentOffset.x%(int)self.frame.size.width;
        return isOnScreen && (isNotBorder ?: 0 != intersectRegion.size.width);
    }
    return isOnScreen;
}

- (BOOL)vtm_isItemNeedDisplayWithFrame:(CGRect)frame {
    frame.size.width *= 2;
    // 菜单是否在屏幕上,是的话，就要显示
    BOOL isOnScreen = [self vtm_isNeedDisplayWithFrame:frame preloading:YES];
    if (isOnScreen) {
        return YES;
    }
    
    frame.size.width *= 0.5;
    frame.origin.x -= frame.size.width;
    isOnScreen = [self vtm_isNeedDisplayWithFrame:frame preloading:YES];
    return isOnScreen;
}

@end
