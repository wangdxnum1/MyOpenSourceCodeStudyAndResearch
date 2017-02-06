//
//  TWNSDateViewController.m
//  YYCategoriesStudy
//
//  Created by HaKim on 17/1/17.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "TWNSDateViewController.h"

@interface TWNSDateViewController ()

@end

@implementation TWNSDateViewController

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
    NSDate *currentDate = [NSDate date];
    
    NSDate *test1 = [currentDate dateByAddingYears:1];
    NSLog(@"test1 = %@",test1);
    
    NSDate *test2 = [currentDate dateByAddingMonths:-1];
    NSLog(@"test2 = %@",test2);
    
    NSDate *test3 = [currentDate dateByAddingWeeks:-1];
    NSLog(@"test3 = %@",test3);
    
    NSDate *test4 = [currentDate dateByAddingDays:-1];
    NSLog(@"test4 = %@",test4);
}

- (void)testCase2{
    NSDate *currentDate = [NSDate date];
    
    NSString *dateStr = [currentDate stringWithFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSLog(@"dateStr = %@",dateStr);
    
    //stringWithISOFormat
    NSString *test1 = [currentDate stringWithISOFormat];
    NSLog(@"test1 = %@",test1);
}

@end
