//
//  ViewController.m
//  YYCategoriesStudy
//
//  Created by 胡金丽 on 2016/12/27.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import "ViewController.h"
#import "TWOptionModel.h"
#import "TWTestViewCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *options;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self commonInit];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)commonInit{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    self.navigationItem.title =[infoDictionary objectForKey:@"CFBundleDisplayName"];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableView 的 UITableViewDelegate 和 UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.options.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TWTestViewCell *cell = [TWTestViewCell testViewCellWithTableView:tableView];
    
    TWOptionModel *model = [self.options objectAtIndex:indexPath.row];
    cell.optionModel = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TWOptionModel *model = [self.options objectAtIndex:indexPath.row];
    
    UIViewController *vc = (UIViewController*)[[model.targetClass alloc] init];
    [vc setValue:model forKey:@"optionModel"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - set & get method

- (NSArray*)options{
    if(_options == nil){
        TWOptionModel *model1 = [[TWOptionModel alloc] init];
        model1.title = @"CALayer 测试";
        model1.className = @"TWCALayerViewController";
        
        TWOptionModel *model2 = [[TWOptionModel alloc] init];
        model2.title = @"NSData 测试 - hash，加解密，编码";
        model2.className = @"TWNSDataViewController";
        
        TWOptionModel *model3 = [[TWOptionModel alloc] init];
        model3.title = @"NSDate 测试 - 日期元素，操作";
        model3.className = @"TWNSDateViewController";
        
        TWOptionModel *model4 = [[TWOptionModel alloc] init];
        model4.title = @"NSDictionary 测试 - 转换，key，value";
        model4.className = @"TWNSDictionaryViewController";
        
        TWOptionModel *model5 = [[TWOptionModel alloc] init];
        model5.title = @"NSString 测试 - hash，加解密，编码";
        model5.className = @"TWNSStringViewController";
        
        TWOptionModel *model6 = [[TWOptionModel alloc] init];
        model6.title = @"UIApplication 测试 - 跟进程，程序本身相关的";
        model6.className = @"TWUIApplicationViewController";
        
        //TWUIImageViewController
        TWOptionModel *model7 = [[TWOptionModel alloc] init];
        model7.title = @"TWUIImageViewController 测试 - 图片变换";
        model7.className = @"TWUIImageViewController";
        
        _options = @[model1,model2,model3,model4,model5,model6,model7];
    }
    return _options;
}

@end
