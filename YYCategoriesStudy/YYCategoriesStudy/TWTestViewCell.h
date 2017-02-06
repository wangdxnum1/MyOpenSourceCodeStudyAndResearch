//
//  TWTestViewCell.h
//  YYCategoriesStudy
//
//  Created by HaKim on 16/12/28.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TWOptionModel;
@interface TWTestViewCell : UITableViewCell

+ (instancetype)testViewCellWithTableView:(UITableView*)tableView;

@property (nonatomic, strong) TWOptionModel *optionModel;

@end
