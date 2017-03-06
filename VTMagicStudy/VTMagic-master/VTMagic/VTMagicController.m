//
//  VTMagicController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTMagicController.h"

@interface VTMagicController ()


@end

@implementation VTMagicController

#pragma mark - Lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        } else if ([self respondsToSelector:@selector(setWantsFullScreenLayout:)]) {
            [self setValue:@YES forKey:@"wantsFullScreenLayout"];
        }
    }
    return self;
}

// 加载magicView
- (void)loadView {
    [super loadView];
    
    // 重载loadView，加载自己的view
    self.view = self.magicView;
}

// 管理视图的出现，消失等状态
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.appearanceState = VTAppearanceStateWillAppear;
    if (!_magicView.isSwitching) {
        // 自己实现容器类的控制器，调用这个方法告诉子控制器view发生变化
        [_currentViewController beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.appearanceState = VTAppearanceStateDidAppear;
    if (!_magicView.isSwitching) {
        [_currentViewController endAppearanceTransition];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.appearanceState = VTAppearanceStateWillDisappear;
    if (!_magicView.isSwitching) {
        [_currentViewController beginAppearanceTransition:NO animated:animated];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.appearanceState = VTAppearanceStateDidDisappear;
    if (!_magicView.isSwitching) {
        [_currentViewController endAppearanceTransition];
    }
}

#pragma mark - forward appearance methods
// 是否自动调用appearance 方法，来告诉子控制器
- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

#pragma mark - functional methods
// public 方法
- (UIViewController *)viewControllerAtPage:(NSUInteger)pageIndex {
    // 返回指定索引的控制器
    return [self.magicView viewControllerAtPage:pageIndex];
}

- (void)switchToPage:(NSUInteger)pageIndex animated:(BOOL)animated {
    // 切换到指定索引的页面
    [self.magicView switchToPage:pageIndex animated:animated];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return @[];
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageInde {
    static NSString *pageId = @"page.identifier";
    UIViewController *viewController = [magicView dequeueReusablePageWithIdentifier:pageId];
    if (!viewController) {
        viewController = [[UIViewController alloc] init];
    }
    return viewController;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    VTLog(@"index:%ld viewControllerDidAppear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    VTLog(@"index:%ld viewControllerDidDisappear:%@", (long)pageIndex, viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    VTLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

#pragma mark - accessor methods
// get && set method
- (VTMagicView *)magicView {
    if (!_magicView) {
        _magicView = [[VTMagicView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _magicView.autoresizesSubviews = YES;
        _magicView.magicController = self;
        _magicView.delegate = self;
        _magicView.dataSource = self;
        [self.view setNeedsLayout];
    }
    return _magicView;
}

// 屏幕上可见的控制器
- (NSArray<UIViewController *> *)viewControllers {
    return self.magicView.viewControllers;
}

@end
