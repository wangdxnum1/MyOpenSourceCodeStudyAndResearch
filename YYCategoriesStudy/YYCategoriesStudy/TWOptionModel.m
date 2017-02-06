//
//  TWOptionModel.m
//  YYCategoriesStudy
//
//  Created by HaKim on 16/12/28.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import "TWOptionModel.h"

@implementation TWOptionModel

- (void)setClassName:(NSString *)className{
    _className = [className copy];
    
    if(_className == nil || _className.length == 0) return;
    
    _targetClass = NSClassFromString(_className);
}

- (void)setTargetClass:(Class)targetClass{
    _targetClass = targetClass;
    
    if(_targetClass == nil) return;
    
    _className = NSStringFromClass(_targetClass);
}

@end
