//
//  TWBaseViewController.m
//  YYCategoriesStudy
//
//  Created by HaKim on 16/12/29.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import "TWBaseViewController.h"

@interface TWBaseViewController ()

@end

@implementation TWBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self p_commonInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)p_commonInit{
    self.navigationItem.title = self.optionModel.title;
    
}

@end
