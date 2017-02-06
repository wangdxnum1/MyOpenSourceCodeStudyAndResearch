//
//  User.m
//  YYModelTest
//
//  Created by HaKim on 16/9/27.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "User.h"
#import <YYModel/YYModel.h>

@implementation User

- (void)doWork:(NSString*)content{
    NSLog(@"%s content = %@",__func__,content);
}

- (NSString *)description { return [self yy_modelDescription]; }

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"name"  : @"n",
             @"bookName" : @"n"};
}

//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{@"name"  : @"n",
//             @"page"  : @"p",
//             @"desc"  : @"ext.desc",
//             @"bookID": @[@"id", @"ID", @"book_id"],
//             @"hehename":@"n"};
//}

//- (BOOL)modelCustomTransformToDictionary:(NSMutableDictionary *)dic{
//    return YES;
//}

+ (NSDictionary*)modelContainerPropertyGenericClass{
    return @{@"shadows" : @"NSNumber"};
}

@end
