//
//  TWUIImageViewController.m
//  YYCategoriesStudy
//
//  Created by HaKim on 17/1/17.
//  Copyright © 2017年 Tim. All rights reserved.
//

#import "TWUIImageViewController.h"

@interface TWUIImageViewController ()

@end

@implementation TWUIImageViewController

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
    
    [self testCase3];
    
    [self testCase4];
    
    [self testCase5];
    
    [self testCase6];
    
    [self testCase7];
}

- (void)testCase1{
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImage *test1 = [image imageByCropToRect:CGRectMake(0, 0, 1000, 1000)];
    NSLog(@"test1 = %@",test1);
}


- (void)testCase2{
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImage *test1 = [image imageByInsetEdge:UIEdgeInsetsMake(10, 10, 10, 10) withColor:[UIColor redColor]];
    NSLog(@"test1 = %@",test1);
}

- (void)testCase3{
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImage *test1 = [image imageByRoundCornerRadius:10];
    NSLog(@"test1 = %@",test1);
}

- (void)testCase4{
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImage *test1 = [image imageByRoundCornerRadius:10 borderWidth:10 borderColor:[UIColor redColor]];
    NSLog(@"test1 = %@",test1);
}

- (void)testCase5{
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImage *test1 = [image imageByRotate:45 fitSize:YES];
    
    UIImage *test2 = [image imageByRotate:45 fitSize:NO];
    
    NSLog(@"test1 = %@, test2  %@",test1,test2);
}

- (void)testCase6{
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImage *test1 = [image imageByFlipVertical];
    
    UIImage *test2 = [image imageByFlipHorizontal];
    
    NSLog(@"test1 = %@, test2 = %@",test1,test2);
}

- (void)testCase7{
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImage *test1 = [image imageByTintColor:[UIColor colorWithHexString:@"#66CCFF09"]];
    
    UIImage *test2 = [image imageByGrayscale];
    
    UIImage *test3 = [image imageByBlurSoft];
    
    UIImage *test4 = [image imageByBlurLight];
    
    UIImage *test5 = [image imageByBlurExtraLight];
    
    UIImage *test6 = [image imageByBlurDark];
    
    UIImage *test7 = [image imageByBlurWithTint:[UIColor redColor]];
    
    NSLog(@"test1 = %@, test2 = %@ ,%@,%@,%@,%@,%@",test1,test2,test3,test4,test5,test6,test7);
}

@end
