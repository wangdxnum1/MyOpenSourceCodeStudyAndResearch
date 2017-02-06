//
//  TWNSDictionaryViewController.m
//  YYCategoriesStudy
//
//  Created by HaKim on 17/1/17.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "TWNSDictionaryViewController.h"

@interface TWNSDictionaryViewController ()

@end

@implementation TWNSDictionaryViewController

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
    NSDictionary *dict = @{@"anme":@"wang",
                           @"age" : @18,
                           @"job" :@"IT"};
    
    NSString *test1 = [dict jsonStringEncoded];
    
    NSString *test2 = [dict jsonPrettyStringEncoded];
    
    NSLog(@"test1 = %@,\n test2 = %@",test1,test2);
}


@end
