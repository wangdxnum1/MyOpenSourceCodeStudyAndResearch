//
//  TWBaseViewController.h
//  YYCategoriesStudy
//
//  Created by HaKim on 16/12/29.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YYCategories.h"
#import "TWOptionModel.h"

@class TWOptionModel;
@interface TWBaseViewController : UIViewController

@property (nonatomic, strong) TWOptionModel *optionModel;

@end
