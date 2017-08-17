# AZTime
### 全局倒计时管理 + 计算本地时间与服务器时间差

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


#### 主要API


```objc
#pragma mark - AZCountdownManager

/**
 添加一个自定义key且倒计时生命周期和view一样的倒计时

 @param key 自定义倒计时key
 @param view 倒计时绑定的view
 @param deadline 倒计时终点时间
 @param interval 倒计时刷新间隔
 @param autoStop 倒计时到0后是否自动停止倒计时
 @param leftTimeChangedBlock 倒计时刷新回调block
 */
- (void)addCountdownWithKey:(NSString *_Nullable)key
                       view:(UIView *_Nullable)view
               deadlineDate:(NSDate *_Nonnull)deadline
                   interval:(NSTimeInterval)interval
                   autoStop:(BOOL)autoStop
       leftTimeChangedBlock:(AZLeftTimeChangedBlock _Nullable )leftTimeChangedBlock;

#pragma mark - AZServerTimeManager

/**
 更新与服务器时间的差值 需要先设置verifyUrl 更新完成后offset为最新的偏移量

 @param completion 是否更新完成、偏移量
 */
- (void)updateServerTimeOffset:(AZServerTimeManagerBlock)completion;

#pragma mark -  AZCountdownManager (Server)

/**
 自动更新本地和服务器时间的偏移量和AZCountdownManager的serverOffset
 
 @param verifyUrl 校对的URL
 */
- (void)autoUpdateServerOffsetWithVerifyUrl:(NSString *)verifyUrl;

```





