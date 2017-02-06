//
//  TWTestViewCell.m
//  YYCategoriesStudy
//
//  Created by HaKim on 16/12/28.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import "TWTestViewCell.h"
#import "TWOptionModel.h"

@interface TWTestViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation TWTestViewCell

+ (instancetype)testViewCellWithTableView:(UITableView*)tableView{
    static NSString *cellID = @"TWTestViewCell";
    TWTestViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([TWTestViewCell class]) owner:self options:nil] lastObject];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self commonInit];
    }
    return self;
}

- (void)setOptionModel:(TWOptionModel *)optionModel{
    _optionModel = optionModel;
    
    self.titleLabel.text = optionModel.title;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self commonInit];
}

#pragma mark - UI

- (void)commonInit{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


@end
