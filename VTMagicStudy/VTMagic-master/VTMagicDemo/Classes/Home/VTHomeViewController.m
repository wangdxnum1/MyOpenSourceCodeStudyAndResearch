//
//  ViewController.m
//  VTMagicView
//
//  Created by tianzhuo on 14-11-11.
//  Copyright (c) 2014年 tianzhuo. All rights reserved.
//

#import "VTHomeViewController.h"
#import "VTRecomViewController.h"
#import "VTGridViewController.h"

@interface VTHomeViewController ()

// 导航栏上的菜单menus数组
@property (nonatomic, strong)  NSArray *menuList;

// 表示是否自自动切换到第一个选项，“推荐页面”
@property (nonatomic, assign)  BOOL autoSwitch;

@end

@implementation VTHomeViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.magicView.bounces = YES;
//    self.magicView.headerHidden = NO;
//    self.magicView.itemSpacing = 20.f;
//    self.magicView.switchEnabled = YES;
//    self.magicView.separatorHidden = NO;
    // 选中是menu放大的倍数
    self.magicView.itemScale = 1.2;
    
    // 这个不知道是什么东西啊，改了看不出什么效果
    self.magicView.headerHeight = 10;
    
    //VTMenuBar,应该是放menus的父控件容器高度
    self.magicView.navigationHeight = 44;
    
    // 导航栏是否需要空出20个点状态栏的位置，
    self.magicView.againstStatusBar = YES;
//    self.magicView.sliderExtension = 5.0;
//    self.magicView.switchStyle = VTSwitchStyleStiff;
//    self.magicView.navigationInset = UIEdgeInsetsMake(0, 50, 0, 0);
    
    self.magicView.headerView.backgroundColor = RGBCOLOR(243, 40, 47);
    
    // 改了颜色，红色，没看到效果
    self.magicView.headerView.backgroundColor = RGBCOLOR(00, 255, 00);
    
    // 导航栏颜色，即放menus 的容器的背景颜色
    self.magicView.navigationColor = [UIColor whiteColor];
//    self.magicView.navigationColor = [UIColor greenColor];
    
    // 导航菜单的布局样式,默认样式，item自适应文本宽度，间距由itemSpacing决定
    self.magicView.layoutStyle = VTLayoutStyleDefault;
    
    self.view.backgroundColor = RGBCOLOR(243, 40, 47);
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    // 顶部导航栏右侧视图项,即这个页面的 “+”按钮
    [self integrateComponents];
    
    // 配置导航栏横的分割线高度和颜色
    [self configSeparatorView];
    
    // 添加屏幕旋转的一些通知
    [self addNotification];
    
    // 生成测试数据，即menus
    [self generateTestData];
    
    // 加载数据
    [self.magicView reloadData];
    
    VTPRINT_METHOD
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    // 看是否要自动切换到“推荐”
    _autoSwitch = 0 != self.tabBarController.selectedIndex;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 看是否要自动切换到“推荐”
    if (_autoSwitch) {
        [self.magicView switchToPage:0 animated:YES];
        _autoSwitch = NO;
    }
}

- (void)dealloc {
    // 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSNotification
- (void)addNotification {
    // 先移除对屏幕旋转的通知
    [self removeNotification];
    // 添加对屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarOrientationChange:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
}

- (void)removeNotification {
    // 移除对屏幕旋转的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification {
    // 相应屏幕旋转的操作
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

#pragma mark - VTMagicViewDataSource
// 数据源协议
- (NSArray<NSString *> *)menuTitlesForMagicView:(VTMagicView *)magicView {
    // menus title 数组
    NSMutableArray *titleList = [NSMutableArray array];
    for (MenuInfo *menu in _menuList) {
        [titleList addObject:menu.title];
    }
    return titleList;
}

// 返回menus 的button
- (UIButton *)magicView:(VTMagicView *)magicView menuItemAtIndex:(NSUInteger)itemIndex {
    static NSString *itemIdentifier = @"itemIdentifier";
    UIButton *menuItem = [magicView dequeueReusableItemWithIdentifier:itemIdentifier];
    if (!menuItem) {
        // 设置选中，平时的颜色，字体啊之类的
        menuItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuItem setTitleColor:RGBCOLOR(50, 50, 50) forState:UIControlStateNormal];
        [menuItem setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateSelected];
        menuItem.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15.f];
    }
    // 默认会自动完成赋值
//    MenuInfo *menuInfo = _menuList[itemIndex];
//    [menuItem setTitle:menuInfo.title forState:UIControlStateNormal];
    return menuItem;
}

// 返回某一页的控制器
- (UIViewController *)magicView:(VTMagicView *)magicView viewControllerAtPage:(NSUInteger)pageIndex {
    MenuInfo *menuInfo = _menuList[pageIndex];
    if (0 == pageIndex) {
        static NSString *recomId = @"recom.identifier";
        VTRecomViewController *recomViewController = [magicView dequeueReusablePageWithIdentifier:recomId];
        if (!recomViewController) {
            recomViewController = [[VTRecomViewController alloc] init];
        }
        recomViewController.menuInfo = menuInfo;
        return recomViewController;
    }
    
    static NSString *gridId = @"grid.identifier";
    VTGridViewController *viewController = [magicView dequeueReusablePageWithIdentifier:gridId];
    if (!viewController) {
        viewController = [[VTGridViewController alloc] init];
    }
    viewController.menuInfo = menuInfo;
    return viewController;
}

#pragma mark - VTMagicViewDelegate
- (void)magicView:(VTMagicView *)magicView viewDidAppear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    // index 位置的控制器显示了
//    NSLog(@"index:%ld viewDidAppear:%@-%@", (long)pageIndex, viewController,viewController.view);
}

- (void)magicView:(VTMagicView *)magicView viewDidDisappear:(__kindof UIViewController *)viewController atPage:(NSUInteger)pageIndex {
    // index 位置的控制器消失了
//    NSLog(@"index:%ld viewDidDisappear:%@-%@", (long)pageIndex, viewController,viewController.view);
}

- (void)magicView:(VTMagicView *)magicView didSelectItemAtIndex:(NSUInteger)itemIndex {
    // 导航栏上的 menu 被选中了
//    NSLog(@"didSelectItemAtIndex:%ld", (long)itemIndex);
}

#pragma mark - actions
- (void)subscribeAction {
    // 订阅按钮点击相应事件
    NSLog(@"subscribeAction");
    // against status bar or not
//    self.magicView.againstStatusBar = !self.magicView.againstStatusBar;
    [self.magicView setHeaderHidden:!self.magicView.isHeaderHidden duration:0.35];
}

#pragma mark - functional methods
- (void)generateTestData {
    // 制造menus 数据
    NSString *title = @"推荐";
    NSMutableArray *menuList = [[NSMutableArray alloc] initWithCapacity:24];
    [menuList addObject:[MenuInfo menuInfoWithTitl:title]];
    for (int index = 0; index < 20; index++) {
        title = [NSString stringWithFormat:@"省份%d", index];
        MenuInfo *menu = [MenuInfo menuInfoWithTitl:title];
        [menuList addObject:menu];
    }
    _menuList = menuList;
}

- (void)integrateComponents {
    // 订阅按钮，+ 号按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton addTarget:self action:@selector(subscribeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitleColor:RGBACOLOR(169, 37, 37, 0.6) forState:UIControlStateSelected];
    [rightButton setTitleColor:RGBCOLOR(169, 37, 37) forState:UIControlStateNormal];
    [rightButton setTitle:@"+" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:28];
    rightButton.center = self.view.center;
    self.magicView.rightNavigatoinItem = rightButton;
}

- (void)configSeparatorView {
//    UIImageView *separatorView = [[UIImageView alloc] init];
//    [self.magicView setSeparatorView:separatorView];
    
    // 导航栏与其他视图的横的分割线高度和颜色
    self.magicView.separatorHeight = 2.f;
    self.magicView.separatorColor = RGBCOLOR(22, 146, 211);
    
    // 配置导航栏视图的阴影颜色和位置效果
    self.magicView.navigationView.layer.shadowColor = RGBCOLOR(22, 146, 211).CGColor;
//    self.magicView.navigationView.layer.shadowColor = RGBCOLOR(255, 00, 00).CGColor;
    self.magicView.navigationView.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.magicView.navigationView.layer.shadowOpacity = 0.8;
    self.magicView.navigationView.clipsToBounds = NO;
}

@end
