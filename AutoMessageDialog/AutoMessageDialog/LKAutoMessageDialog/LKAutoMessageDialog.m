//
//  LKAutoMessageDialog.m
//  AutoMessageDialog
//
//  Created by Liangk on 2017/11/15.
//  Copyright © 2017年 liang. All rights reserved.
//

#import "LKAutoMessageDialog.h"

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width  //  设备的宽度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height //   设备的高度

@interface LKAutoMessageDialog ()

@property (copy,nonatomic) NSString* msg;
@property (strong,nonatomic) UIView* mainView;
@property (strong,nonatomic) UILabel* msgLabel;
@property (assign,nonatomic) float time;
@end

@implementation LKAutoMessageDialog

/**
 *  初始化
 *
 *  @param msg             消息
 */
- initWithMessage:(NSString *)msg time:(float)time{
    self = [super init];
    if (self) {
        self.padding = 10;
        self.fontSize = 15;
        self.msg = msg;
        self.time = time;
    }
    return self;
}

/**
 *  获取对话框的显示位置大小
 *
 *  @param msg 消息
 *
 *  @return 对话框的显示位置大小
 */
- (CGRect)getDialogFrameWithMessage:(NSString*)msg {
    CGRect frame;
    
    CGSize size = [self getDialogSizeWithMessage:msg];
    frame = CGRectMake(ScreenWidth / 2 - size.width / 2, ScreenHeight / 2 - size.height / 2, size.width, size.height);
    
    return frame;
}

/**
 *  获取对话框的显示大小
 *
 *  @param msg 消息
 *
 *  @return 对话框的显示大小
 */
- (CGSize)getDialogSizeWithMessage:(NSString*)msg {
    CGSize size;
    if (msg) {
        size = [self getContentSizeWithMessage:msg];
    }
    else {
        size = CGSizeMake(60, 20);
    }
    
    if (size.width < 60) {
        size.width = 60;
    }
    if (size.width > ScreenWidth / 2) {
        size.width = ScreenWidth / 2;
    }
    if (size.height > ScreenHeight / 2) {
        size.height = ScreenHeight / 2;
    }
    
    //增加边距
    size.width = size.width + self.padding * 2;
    size.height = size.height + self.padding * 2;
    
    return size;
}

/**
 *  获取消息内容区域大小
 *
 *  @param msg 消息
 *
 *  @return 消息内容区域大小
 */
- (CGSize)getContentSizeWithMessage:(NSString*)msg {
    CGSize size;
    CGSize maxBoundingSize = CGSizeMake(ScreenWidth / 2 - self.padding * 2, ScreenHeight / 2 - self.padding * 2);
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:self.fontSize]};
    
    size = [msg boundingRectWithSize:maxBoundingSize
                             options:NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading
                          attributes:attribute
                             context:nil].size;
    return size;
}

/**
 *  弹出视图
 */
- (void)show {
    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
    for (id view in keyWindow.subviews) {
        if ([view isKindOfClass:[LKAutoMessageDialog class]]) {
            LKAutoMessageDialog *dialog = (LKAutoMessageDialog *)view;
            [dialog dismiss:NO];
        }
    }
    CGRect dialogFrame = [self getDialogFrameWithMessage:self.msg];
    self.frame = dialogFrame;
    [self.layer setCornerRadius:5];
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    
    self.mainView = [[UIView alloc] initWithFrame:self.frame];
    self.mainView.backgroundColor = [UIColor blackColor];
    self.mainView.alpha = 0;
    [self.mainView.layer setCornerRadius:5];
    self.mainView.layer.masksToBounds = YES;
    
    self.msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.padding, self.padding, self.mainView.frame.size.width - self.padding * 2, self.mainView.frame.size.height - self.padding * 2)];
    self.msgLabel.backgroundColor = [UIColor clearColor];
    self.msgLabel.text = self.msg;
    self.msgLabel.font = [UIFont systemFontOfSize:self.fontSize];
    self.msgLabel.textColor = [UIColor whiteColor];
    self.msgLabel.textAlignment = NSTextAlignmentCenter;
    self.msgLabel.numberOfLines = 0;
    self.msgLabel.lineBreakMode = NSLineBreakByCharWrapping;
    self.msgLabel.center = CGPointMake(ScreenWidth / 2, ScreenHeight / 2);
    
    [keyWindow addSubview:self];
    [keyWindow addSubview:self.mainView];
    [keyWindow addSubview:self.msgLabel];
    
    dispatch_queue_t queue = dispatch_queue_create([@"SQAutoMessageDialog_show" cStringUsingEncoding:NSASCIIStringEncoding], NULL);
    dispatch_async(queue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5 animations:^{
                self.mainView.alpha = 0.7;
                self.msgLabel.alpha = 1.0;
            }];
            
        });
        
        //等待一定的时间后开始自动消失
        sleep(self.time);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self dismiss];
            
        });
    });
}

/**
 *  移除视图
 */
- (void)dismiss {
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.alpha = 0;
        self.msgLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self.msgLabel removeFromSuperview];
        [self.mainView removeFromSuperview];
        [self removeFromSuperview];
        if (_dismissBlock) {
            _dismissBlock();
            _dismissBlock = nil;
        }
    }];
}

/**
 移除视图
 
 @param animated 是否启用动画
 */
- (void)dismiss:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            self.mainView.alpha = 0;
            self.msgLabel.alpha = 0;
        } completion:^(BOOL finished) {
            [self.msgLabel removeFromSuperview];
            [self.mainView removeFromSuperview];
            [self removeFromSuperview];
            if (_dismissBlock) {
                _dismissBlock();
                _dismissBlock = nil;
            }
        }];
    }
    else {
        [self.msgLabel removeFromSuperview];
        [self.mainView removeFromSuperview];
        [self removeFromSuperview];
        if (_dismissBlock) {
            _dismissBlock();
            _dismissBlock = nil;
        }
    }
}

/**
 *  弹出视图
 *
 *  @param msg 消息
 *
 *  @return 视图实例
 */
+ (id)showWithMessage:(NSString*)msg time:(float)time{
    LKAutoMessageDialog* dialog = [[LKAutoMessageDialog alloc] initWithMessage:msg time:time];
    [dialog show];
    return dialog;
}

/**
 *  注册消失回调block
 *
 *  @param block 消失回调block
 */
- (void)registerDismissBlock:(LKAutoMessageDialogDismissBlock)block {
    _dismissBlock = block;
}


@end
