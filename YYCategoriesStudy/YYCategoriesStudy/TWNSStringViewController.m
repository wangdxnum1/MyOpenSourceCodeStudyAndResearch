//
//  TWNSStringViewController.m
//  YYCategoriesStudy
//
//  Created by HaKim on 17/1/17.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "TWNSStringViewController.h"

@interface TWNSStringViewController ()

@end

@implementation TWNSStringViewController

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
    
    [self testCase2];
}

- (void)testCase1{
    NSString *url = @"https://www.baidu.com/s?ie=utf-8&f=8&rsv_bp=1&tn=99819353_hao_pg&wd=iso 8601 时间格式意思&oq=iso 8601 时间格式";
    NSString *encodeUrl = [url stringByURLEncode];
    
    NSString *decodeUrl = [encodeUrl stringByURLDecode];
    
    NSLog(@"encodeUrl = %@,\n decodeUrl = %@",encodeUrl,decodeUrl);
}

- (void)testCase2{
    NSString *url = @"                 https://www.baidu.com  式   \r\n       ";
    NSLog(@"url = %@",url);
    
    NSString *test1 = [url stringByTrim];
    NSLog(@"url = %@",test1);
}


@end
