//
//  ViewController.m
//  KVOResearch
//
//  Created by HaKim on 16/1/29.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "TWPersion.h"
#import "NSObject+DLIntrospection.h"
#import "TTTAttributedLabel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self ttt];
//    [self test1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)test1
{
    TWPersion *p = [[TWPersion alloc] init];
    // breakpoint 1
    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    // breakpoint 2
    p.name = @"萨萨萨";
    
    [p removeObserver:self forKeyPath:@"name"];
    // breakpoint 3
}


- (void)ttt
{
    TTTAttributedLabel *label = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(100, 120, 120, 120)];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.numberOfLines = 0;
    label.lineSpacing = 6;
    [self.view addSubview:label];
    
    label.backgroundColor = [UIColor orangeColor];
    label.text = @"IOS端邀请好友榜单规则描述不准确，排行榜是实时更新的，具体文案可请产品经理提供";
    label.verticalAlignment = TTTAttributedLabelVerticalAlignmentTop;
}
@end
