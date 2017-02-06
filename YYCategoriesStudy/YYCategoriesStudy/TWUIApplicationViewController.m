//
//  TWUIApplicationViewController.m
//  YYCategoriesStudy
//
//  Created by HaKim on 17/1/17.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "TWUIApplicationViewController.h"

@interface TWUIApplicationViewController ()

@end

@implementation TWUIApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self runCase];
}

- (void)runCase{
    [self testCase1];
}

- (void)testCase1{
    [[UIApplication sharedApplication] incrementNetworkActivityCount];
}


@end
