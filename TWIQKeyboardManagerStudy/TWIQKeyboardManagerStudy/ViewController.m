//
//  ViewController.m
//  TWIQKeyboardManagerStudy
//
//  Created by HaKim on 16/2/23.
//  Copyright © 2016年 haKim. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardManager.h"

@interface ViewController ()
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
