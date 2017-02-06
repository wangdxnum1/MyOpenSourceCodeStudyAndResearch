//
//  ViewController.m
//  CAAnimationTest1
//
//  Created by HaKim on 16/2/23.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "ViewController.h"

#define kStringMenuItemAppearKey         @"kStringMenuItemAppearKey"
#define JK_SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)
#define kFloatMenuItemAppearDuration     (0.5f)
@interface ViewController ()

@property (nonatomic, weak) CALayer *testLayer;

@property (weak, nonatomic) IBOutlet UIView *testView1;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    CALayer *layer = [CALayer layer];
    layer.position = CGPointMake(100, 100);
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor orangeColor].CGColor;
    [self.view.layer addSublayer:layer];
    self.testLayer = layer;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self test1];
    [self test2];
}

- (void)test1{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 1.0;
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(200,200)];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = self;
    [self.testLayer addAnimation:animation forKey:@"position"];
}

// 模拟微博菜单选项网上弹出，有个减速，回来的弹簧效果
- (void)test2{
    CGPoint point0 = CGPointMake(self.testView1.center.x, self.testView1.center.y);
    CGPoint point1 = CGPointMake(point0.x, self.testView1.center.y - (JK_SCREEN_HEIGHT - 300) - 20);
    CGPoint point2 = CGPointMake(point1.x, point1.y + 20);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.values = @[[NSValue valueWithCGPoint:point0], [NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2]];
    animation.keyTimes = @[@(0), @(0.6), @(1)];
    animation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.10 :0.87 :0.68 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.66 :0.37 :0.70 :0.95]];
    animation.duration = kFloatMenuItemAppearDuration;
    [self.testView1.layer addAnimation:animation forKey:kStringMenuItemAppearKey];
    
    self.testView1.layer.position = point2;
}


- (void)animationDidStart:(CAAnimation *)anim{
    NSString *info = NSStringFromCGPoint(self.testLayer.position);
    NSLog(@"%@",info);
    NSLog(@"%@",info);
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSString *info = NSStringFromCGPoint(self.testLayer.position);
    [self.testLayer removeAnimationForKey:@"position"];
    NSLog(@"%@",info);
}

@end
