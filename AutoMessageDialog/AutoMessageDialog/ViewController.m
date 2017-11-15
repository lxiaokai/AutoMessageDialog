//
//  ViewController.m
//  AutoMessageDialog
//
//  Created by Liangk on 2017/11/15.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "ViewController.h"
#import "LKAutoMessageDialog.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LKAutoMessageDialog *dialog = [[LKAutoMessageDialog alloc] initWithMessage:@"1.回调消失后再弹窗" time:2];
    [dialog show];
    
    [dialog registerDismissBlock:^{
        [LKAutoMessageDialog showWithMessage:@"2.我是第二次弹窗" time:2];
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
