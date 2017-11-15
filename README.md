# AutoMessageDialog
自定义toast提示封装
使用方法
```
    LKAutoMessageDialog *dialog = [[LKAutoMessageDialog alloc] initWithMessage:@"1.回调消失后再弹窗" time:2];
    [dialog show];
    [dialog registerDismissBlock:^{
        [LKAutoMessageDialog showWithMessage:@"2.我是第二次弹窗" time:2];
    }];
```



![](https://ws4.sinaimg.cn/large/006tKfTcgy1flirpzmfr3g309b0gn1l2.gif)
AutoMessageDialog