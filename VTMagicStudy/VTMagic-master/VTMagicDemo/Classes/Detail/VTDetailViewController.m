//
//  VTDetailViewController.m
//  VTMagic
//
//  Created by tianzhuo on 7/7/16.
//  Copyright © 2016 tianzhuo. All rights reserved.
//

#import "VTDetailViewController.h"
#import "VTRelateViewController.h"
#import "VTChatViewController.h"
#import <VTMagic/VTMagic.h>
#import "VTMenuItem.h"

@interface VTDetailViewController()<VTMagicViewDataSource, VTMagicViewDelegate, VTChatViewControllerDelegate>

// 这次不是继承，是包含的适应magicController
@property (nonatomic, strong) VTMagicController *magicController;

@property (nonatomic, strong) VTChatViewController *chatViewController;

@property (nonatomic, strong)  NSArray *menuList;

@property (nonatomic, assign)  BOOL dotHidden;

@end

@implementation VTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置vc
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor blackColor];
    
    // 主代码，加入_magicController和他的view
    [self addChildViewController:self.magicController];
    [self.view addSubview:_magicController.view];
    
    [self.view setNeedsUpdateConstraints];
    
    // menus名称
    _menuList = @[@"详情", @"热门", @"相关", @"聊天"];
    
    // 加载数据
    [_magicController.magicView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_chatViewController invalidateTimer];
}

// 更新约束
- (void)updateViewConstraints {
    UIView *magicView = _magicController.view;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-200-[magicView]-0-|"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:NSDictionaryOfVariableBindings(magicView)]];
    
    [super updateViewConstraints];
}

#pragma mark - VTMagicViewDataSource
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    return _menuList;
}

- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    // 带有小红点的UIButton，即menus
    static NSString *itemIdentifier = @"itemIdentifier";
    VTMenuItem *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        menuItem = [VTMenuItem buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    menuItem.dotHidden = (_menuList.count - 1 == itemIndex) ? _dotHidden : YES;
    return menuItem;
}

- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    // 聊天控制器
    if (_menuList.count - 1 == pageIndex) {
        return self.chatViewController;
    }
    
    // 其它控制器
    static NSString *gridId = @"relate.identifier";
    VTRelateViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[VTRelateViewController alloc] init];
    }
    viewController.menuInfo = _menuList[pageIndex];
    return viewController;
}

- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    // 聊天控制器被选中的时候，去掉红点
    if ([viewController isEqual:_chatViewController]) {
        _dotHidden = YES;
        [magicView reloadMenuTitles];
    }
}

#pragma mark - VTChatViewControllerDelegate
- (void)chatViewControllerDidReciveNewMessages:(VTChatViewController *)chatViewController {
    _dotHidden = NO;
    [_magicController.magicView reloadMenuTitles];
}

#pragma mark - accessor methods
- (VTMagicController *)magicController {
    // 懒加载
    if (!_magicController) {
        _magicController = [[VTMagicController alloc] init];
        // 关闭自动转换的布局
        _magicController.view.translatesAutoresizingMaskIntoConstraints = NO;
        
        // 放菜单menus的容器的背景色
        _magicController.magicView.navigationColor = [UIColor whiteColor];
        
        // 底下指示菜单的滑块的颜色
        _magicController.magicView.sliderColor = RGBCOLOR(169, 37, 37);
        
        // 当滑动页面是，上面的导航栏的滑块是否实时运动，还是等切换好之后，才去选中新的选中的menu，现在是延迟相应
        _magicController.magicView.switchStyle = VTSwitchStyleStiff;
        
        // 导航栏的menu的大小，平分宽度的模式
        _magicController.magicView.layoutStyle = VTLayoutStyleDivide;
        
        // 导航栏的高度
        _magicController.magicView.navigationHeight = 40.f;
        
        // 导航栏上menu滑块的宽度，延长宽度，0表示与文本一样长，设置这个值是，在0基础上增加长度
        _magicController.magicView.sliderExtension = 10.f;
        
        // 设置代理和数据源
        _magicController.magicView.dataSource = self;
        _magicController.magicView.delegate = self;
    }
    return _magicController;
}

- (VTChatViewController *)chatViewController {
    if (!_chatViewController) {
        _chatViewController = [[VTChatViewController alloc] init];
        _chatViewController.delegate = self;
    }
    return _chatViewController;
}

@end
