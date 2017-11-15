//
//  LKAutoMessageDialog.h
//  AutoMessageDialog
//
//  Created by Liangk on 2017/11/15.
//  Copyright © 2017年 liang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LKAutoMessageDialogDismissBlock)(void);

/**
 *  自动消失消息对话框
 */
@interface LKAutoMessageDialog : UIView

@property (nonatomic) CGFloat padding; //内距
@property (nonatomic) CGFloat fontSize;  //字体大小
@property (nonatomic,strong)LKAutoMessageDialogDismissBlock dismissBlock;

/**
 *  初始化
 *
 *  @param msg             消息
 */
- initWithMessage:(NSString *)msg time:(float)time;

/**
 *  弹出视图
 */
- (void)show;

/**
 *  移除视图
 */
- (void)dismiss;

/**
 移除视图
 
 @param animated 是否启用动画
 */
- (void)dismiss:(BOOL)animated;

/**
 *  弹出视图
 *
 *  @param msg 消息
 *
 *  @return 视图实例
 */
+ (id)showWithMessage:(NSString* __nonnull)msg time:(float)time;

/**
 *  注册消失回调block
 *
 *  @param block 消失回调block
 */
- (void)registerDismissBlock:(LKAutoMessageDialogDismissBlock)block;

@end
