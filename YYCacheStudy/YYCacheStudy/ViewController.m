//
//  ViewController.m
//  YYCacheStudy
//
//  Created by HaKim on 16/9/13.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "YYCache.h"

@interface ViewController ()

@property (nonatomic, strong) YYCache *cache;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    YYCache *cache = [[YYCache alloc] initWithName:@"DycCache"];
//    NSArray *array = @[@"1",@"2",@"3",@"4"];
//    [cache setObject:array forKey:@"array"];
    self.cache = cache;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSArray *array = (NSArray*)[self.cache objectForKey:@"array"];
    NSLog(@"%@",array);
}

@end
