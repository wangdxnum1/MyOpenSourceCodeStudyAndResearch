//
//  UIScrollView+YYAdd.h
//  YYCategories <https://github.com/ibireme/YYCategories>
//
//  Created by ibireme on 13/4/5.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIScrollView`.
 UIScrollView 的扩展分类
 */
@interface UIScrollView (YYAdd)

/**
 Scroll content to top with animation.
 移到顶部，有动画
 */
- (void)scrollToTop;

/**
 Scroll content to bottom with animation.
 移到地步，有动画
 */
- (void)scrollToBottom;

/**
 Scroll content to left with animation.
 移到左部，有动画
 */
- (void)scrollToLeft;

/**
 Scroll content to right with animation.
 移到右边，有动画
 */
- (void)scrollToRight;

/**
 Scroll content to top.
 
 @param animated  Use animation.
 */
- (void)scrollToTopAnimated:(BOOL)animated;

/**
 Scroll content to bottom.
 
 @param animated  Use animation.
 */
- (void)scrollToBottomAnimated:(BOOL)animated;

/**
 Scroll content to left.
 
 @param animated  Use animation.
 */
- (void)scrollToLeftAnimated:(BOOL)animated;

/**
 Scroll content to right.
 
 @param animated  Use animation.
 */
- (void)scrollToRightAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
