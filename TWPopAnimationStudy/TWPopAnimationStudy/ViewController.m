//
//  ViewController.m
//  TWPopAnimationStudy
//
//  Created by HaKim on 16/2/23.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "ViewController.h"
#import <pop/POP.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UIView *testView1;
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
    [self Decay];
}
- (IBAction)btnClicked:(UIButton *)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [self shakeButton];
        //[self showLabel];
    });
}

- (void)shakeButton
{
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @2000;
    positionAnimation.springBounciness = 20;
    
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.button.userInteractionEnabled = YES;
    }];
    [self.button.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

- (void)test1{
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerBounds];
    anim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 200, 200)];
    [self.testView1.layer pop_addAnimation:anim forKey:@"size"];
}

- (void)test2{
    POPDecayAnimation *anim = [POPDecayAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    anim.velocity = @(300.);
    [self.testView1.layer pop_addAnimation:anim forKey:@"slide"];
}

- (void)test3{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.fromValue = @(0.0);
    anim.toValue = @(1.0);
    [self.testView1 pop_addAnimation:anim forKey:@"fade"];
}

- (void)spring{
    
    POPSpringAnimation* framePOP = [POPSpringAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    
    framePOP.springSpeed = 10.f;
    
    framePOP.springBounciness = 4.f;
    
    framePOP.toValue = [UIColor greenColor];
    
    [framePOP setCompletionBlock:^(POPAnimation * anim , BOOL finsih) {
        
        if (finsih) {
            
            NSLog(@"view.frame = %@",NSStringFromCGRect(self.testView1.frame));
            
        }
        
    }];
    
    [self.testView1 pop_addAnimation:framePOP forKey:@"go"];
    
}

- (void)Decay{
    
    POPDecayAnimation* decay = [POPDecayAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    // decay.toValue = [NSValue valueWithCGRect:CGRectMake(200, 400, 100, 100)];
    
    decay.velocity = [NSValue valueWithCGRect:CGRectMake(200, 300, 100, 100)];
    
    [self.testView1 pop_addAnimation:decay forKey:@"go"];
}
@end
