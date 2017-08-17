# [AZTime](https://github.com/AlfredZY/AZTime)

### 全局倒计时管理 + 计算本地时间与服务器时间差

- 直接复制`AZTime`文件夹到项目或者使用cocoapods
`pod 'AZTime', '~> 0.1.0'`

- `AZTime`主要提供了一个用于防止本地时间与服务器时间有偏差以及用户手动修改系统时间导致倒计时不准确的解决方案。

- 使用起来分两步：

1. 设置自动更新的URL

 ``` objc
 // 自动更新服务器时间偏移量
 // 一般在AppDelegate里设置一次就可以了
 [[AZCountdownManager sharedInstance] autoUpdateServerOffsetWithVerifyUrl:@"https://www.baidu.com"];
 ```
 
2. 在需要使用倒计时的地方使用`AZCountdownManager`里合适的方法就行了

    例如一个有着倒计时功能列表里的一个cell，我们可以这样使用：


```objc
#import "TimerCell.h"

- (void)setModel:(TimeModel *)model {
    _model = model;
    __weak typeof(self) weakSelf = self;
    [[AZCountdownManager sharedInstance] addCountdownWithView:self // 该定时的生命跟随self（TimerCell）的生命周期
                                                 deadlineDate:model.date
                                                     interval:0.3
                                                     autoStop:YES
                                         leftTimeChangedBlock:^(NSTimeInterval leftTime, UIView *view, NSString *key) {
            __strong typeof(self) strongSelf = weakSelf;
            // update timer UI                   
    }];
}

```








