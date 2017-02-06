//
//  ViewController.m
//  YYModelTest
//
//  Created by HaKim on 16/9/27.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import <YYModel/YYModel.h>
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self run];
}

- (void)run{
    [self test1];
}

- (void)test1{
//    NSDictionary *dict = @{
//                           @"uid":@123456,
//                           @"name":@"Harry",
//                           @"created":@"1965-07-31T00:00:00+0000"
//                           };
    
//    NSDictionary *dict = @{
//                            @"n":@"Harry Pottery",
//                            @"p": @256,
//                            @"ext" : @{
//                                @"desc" : @"A book written by J.K.Rowling."
//                            },
//                            @"ID" : @100010
//                            };
    
    NSDictionary *dict = @{
                           @"n":@"Harry Pottery",
                           @"p": @256,
                           @"author":@{
                               @"name":@"J.K.Rowling",
                               @"birthday":@"1965-07-31T00:00:00+0000"
                           }
                           };
    
    // Convert json to model:
    User *user = [User yy_modelWithJSON:dict];
    
    // Convert model to json:
    NSDictionary *json = [user yy_modelToJSONObject];
    
    NSLog(@"%@",user);
    NSLog(@"json = %@",json);
    
    NSArray *keyPath = @[@"1",@"2",@"",@"3",@"",@"4",@"2"];
    
    for (NSString *onePath in keyPath) {
        if (onePath.length == 0) {
            NSMutableArray *tmp = keyPath.mutableCopy;
            [tmp removeObject:@""];
            keyPath = tmp;
            break;
        }
    }
    NSLog(@"%@",keyPath);
    
    
    NSDictionary *jsonDict = [user yy_modelToJSONObject];
    NSLog(@"jsonDict = %@",jsonDict);
    
    
    ((void (*)(id, SEL, NSString*))(void *)objc_msgSend)(user,@selector(doWork:),@"赚钱");
    
}

@end
