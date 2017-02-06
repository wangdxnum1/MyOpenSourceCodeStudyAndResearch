//
//  TWCALayerViewController.m
//  YYCategoriesStudy
//
//  Created by HaKim on 16/12/28.
//  Copyright © 2016年 Tim. All rights reserved.
//

#import "TWCALayerViewController.h"
#import "TWOptionModel.h"
#import "YYCategories.h"

@interface TWCALayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *shadowLayer;

@end

@implementation TWCALayerViewController

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
    
    [self testCase2];
    
    [self testCase3];
    
    [self testCase4];
}

- (void)testCase1{
    UIImage *image = [self.view.layer snapshotImage];
    NSLog(@"image = %@",image);
    
    NSData *imagedata=UIImagePNGRepresentation(image);
    [imagedata writeToFile:@"/Users/hikim/Desktop/testCase1.png" atomically:YES];
}

- (void)testCase2{
    NSData *pdf = [self.view.layer snapshotPDF];
    NSLog(@"image = %@",pdf);
    [pdf writeToFile:@"/Users/hikim/Desktop/testCase2.pdf" atomically:YES];
}

- (void)testCase3{
    [self.shadowLayer setLayerShadow:[UIColor blackColor] offset:CGSizeZero radius:2];
}

- (void)testCase4{
    self.shadowLayer.backgroundColor = [UIColor redColor];
    [self.shadowLayer.layer addFadeAnimationWithDuration:2 curve:UIViewAnimationCurveEaseInOut];
}


#pragma mark - UI

- (void)commonInit{
    self.navigationItem.title = self.optionModel.title;
    
}

@end
