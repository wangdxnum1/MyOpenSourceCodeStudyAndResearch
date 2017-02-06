//
//  TWNSDataViewController.m
//  YYCategoriesStudy
//
//  Created by HaKim on 16/12/29.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import "TWNSDataViewController.h"
#import "TWOptionModel.h"
#import "YYCategories.h"

@interface TWNSDataViewController ()

@property (nonatomic, strong) NSData *key;

@end

@implementation TWNSDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self commonInit];
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
    NSString *originStr = @"王大虾";
    NSData *originData = [originStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *aesEnData = [originData aes256EncryptWithKey:self.key iv:nil];
    // 不符合utf-8，所以转换失败
    NSString *aesEnStr = [[NSString alloc]initWithData:aesEnData encoding:NSUTF8StringEncoding];
    
    NSData *aesDeData = [aesEnData aes256DecryptWithkey:self.key iv:nil];
    NSString *aesDeStr = [[NSString alloc] initWithData:aesDeData encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"originStr = %@",originStr);
    NSLog(@"aesEnStr = %@",aesEnStr);
    NSLog(@"aesDeStr = %@",aesDeStr);
    
}

#pragma mark - UI
- (void)commonInit{
    self.navigationItem.title = self.optionModel.title;
    
    NSString *keyStr = @"0123456789abcdef";
    self.key = [keyStr dataUsingEncoding:NSUTF8StringEncoding];
}

@end
