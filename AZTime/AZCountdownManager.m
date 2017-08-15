//
//  AZCountdownManager.m
//  AZTime
//
//  Created by Alfred Zhang on 2017/4/10.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import "AZCountdownManager.h"
#import <objc/runtime.h>
#import "AZCountdownModel.h"

static const NSTimeInterval kDefaultInterval = 0.5;
static NSString *const kKeyPath = @"leftTime";


#define AZViewKey(view) [NSString stringWithFormat:@"AZCountdownKey:%p",view]

@interface AZCountdownManager ()

@property (nonatomic, strong) NSTimer *timer;
@property (strong, nonatomic, readwrite) NSMutableDictionary<NSString *, AZCountdownModel *> *countdownModelDictM;
@property (weak, nonatomic) NSRunLoop *runloop;
@property (nonatomic, strong, readwrite) NSDate *serverDate;

@end

@implementation AZCountdownManager

static AZCountdownManager *_instance;

+ (instancetype)sharedInstance {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        _instance.serverOffset = 0;
        dispatch_queue_t timerQueue = dispatch_queue_create("com.alfred.countdown-manager", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(timerQueue, ^{
            [[NSThread currentThread] setName:@"AZCountdownManager"];
            [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
            _instance.runloop = [NSRunLoop currentRunLoop];
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        });

    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}


#pragma mark- Public

- (NSDate *)serverDeadlieDateWithDuration:(NSTimeInterval)duration {
    return [NSDate dateWithTimeInterval:duration - self.serverOffset sinceDate:[NSDate date]];
}

- (BOOL)isExistKey:(NSString *)key {
    if (key.length > 0) {
        return self.countdownModelDictM[key] == nil ? NO : YES;
    }
    return NO;
}

- (BOOL)isExistView:(UIView *)view {
    if (view != nil) {
        return self.countdownModelDictM[AZViewKey(view)] == nil ? NO : YES;
    }
    return NO;
}

- (NSString *)keyFromView:(UIView *)view {
    if (view == nil) {
        return nil;
    }
    return AZViewKey(view);
}

- (void)addCountdownWithView:(UIView *)view
                deadlineDate:(NSDate *)deadline
                    interval:(NSTimeInterval)interval
                    autoStop:(BOOL)autoStop
        leftTimeChangedBlock:(AZLeftTimeChangedBlock)leftTimeChangedBlock {
    [self addCountdownWithKey:nil view:view deadlineDate:deadline interval:interval autoStop:autoStop leftTimeChangedBlock:leftTimeChangedBlock];
}

- (void)addCountdownWithKey:(NSString *)key
               deadlineDate:(NSDate *)deadline
                   interval:(NSTimeInterval)interval
                   autoStop:(BOOL)autoStop
       leftTimeChangedBlock:(AZLeftTimeChangedBlock)leftTimeChangedBlock {
    [self addCountdownWithKey:key view:nil deadlineDate:deadline interval:interval autoStop:autoStop leftTimeChangedBlock:leftTimeChangedBlock];
}

- (void)addCountdownWithKey:(NSString *)key
                       view:(UIView *)view
               deadlineDate:(NSDate *)deadline
                   interval:(NSTimeInterval)interval
                   autoStop:(BOOL)autoStop
       leftTimeChangedBlock:(AZLeftTimeChangedBlock)leftTimeChangedBlock {
    
    NSString *countdownKey = @"";
    
    if (key.length > 0) {
        countdownKey = key;
    }else if(view != nil) {
        countdownKey = AZViewKey(view);
    }
    
    if (!(countdownKey.length > 0) || deadline == nil) {
        return;
    }
    
    AZCountdownModel *countdown = self.countdownModelDictM[countdownKey];
    if (countdown == nil) {
        countdown = [[AZCountdownModel alloc] init];
    }
    
    countdown.deadline = deadline;
    countdown.view = view;
    countdown.key = countdownKey;
    countdown.canAutoRelease = view == nil ? NO : YES;
    countdown.interval = interval > 0 ? interval : kDefaultInterval;
    countdown.leftTimeChangedBlock = leftTimeChangedBlock;
    countdown.autoStop = autoStop;
    
    [self.countdownModelDictM setValue:countdown forKey:countdownKey];

    if ([self isAddObserver:countdown keyPath:kKeyPath]) {
        [countdown removeObserver:self forKeyPath:kKeyPath];
    }
    [countdown addObserver:self forKeyPath:kKeyPath options:NSKeyValueObservingOptionNew context:(__bridge void * _Nonnull)(countdownKey)];
    countdown.leftTime = [countdown.deadline timeIntervalSinceDate:self.serverDate];
    [self runTimer];
}

/**
 停止监听倒计时
 */

- (void)stopCountdownWithKey:(NSString *)key {
    [self removeObserverWithKey:key];
}

- (void)stopCountdownWithView:(UIView *)view {
    [self removeObserverWithKey:AZViewKey(view) ];
}

#pragma mark- Private

- (void)runTimer {
    if (self.timer != nil) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:0.1 target:_instance selector:@selector(timerAction) userInfo:nil repeats:true];
    [self.runloop addTimer:_instance.timer forMode:NSDefaultRunLoopMode];
}


- (void)checkShouldStop {
    if (self.countdownModelDictM.count == 0 ) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (BOOL)shouldUpdateLeftTimeWithModel:(AZCountdownModel *)model {
    if (model.preUpdateDate == nil) {
        model.preUpdateDate = [NSDate date];
        return YES;
    }else{
        if ([[NSDate date] timeIntervalSinceDate:model.preUpdateDate] < model.interval && [[NSDate date] timeIntervalSinceDate:model.preUpdateDate] > 0) { //>0判断为了防止用户调整时间导致出现判断出错的情况
            return NO;
        }else{
            model.preUpdateDate = [NSDate date];
            return YES;
        }
    }
}

- (void)removeObserverWithKey:(NSString *)key {
    if (!(key.length > 0)) {
        return;
    }
    AZCountdownModel *model = self.countdownModelDictM[key];
    if (model) {
        if ([self isAddObserver:model keyPath:key]) {
            [model removeObserver:self forKeyPath:kKeyPath];
        }
        [self.countdownModelDictM setValue:nil forKey:key];
    }
    
    [self checkShouldStop];
}

#pragma mark- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:kKeyPath]) {
        if (![(__bridge NSString * _Nonnull)(context) isKindOfClass:[NSString class]]) {
            return;
        }
        NSString *key = (__bridge NSString * _Nonnull)(context);
        AZCountdownModel *countdownModel = self.countdownModelDictM[key];
        if (countdownModel.leftTimeChangedBlock != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSTimeInterval leftTime = [change[NSKeyValueChangeNewKey] doubleValue];
                if (countdownModel.autoStop) {
                    if (leftTime <= 0) {
                        countdownModel.leftTimeChangedBlock(0, countdownModel.view, countdownModel.key);
                        if (!countdownModel.isDelayCheck) {
                            countdownModel.delayCheck = YES;
                            [self performSelector:@selector(checkShouldIgnoreCountdownWithKey:) withObject:key afterDelay:60];
                        }
                    }else{
                        countdownModel.leftTimeChangedBlock(leftTime, countdownModel.view, countdownModel.key);
                    }
                }else{
                    countdownModel.leftTimeChangedBlock(leftTime, countdownModel.view, countdownModel.key);
                }
            });
        }
    }
}

- (void)checkShouldIgnoreCountdownWithKey:(NSString *)key {
    AZCountdownModel *countdownModel = self.countdownModelDictM[key];
    if (countdownModel.leftTime <= 0) {
        [self stopCountdownWithKey:key];
    }
    countdownModel.delayCheck = NO;
}

// 判断是否已添加监听
- (BOOL)isAddObserver:(NSObject *)obj keyPath:(NSString *)keyPath
{
    id info = obj.observationInfo;
    NSArray *array = [info valueForKey:@"_observances"];
    for (id objc in array) {
        id Properties = [objc valueForKeyPath:@"_property"];
        NSString *keyPath = [Properties valueForKeyPath:@"_keyPath"];
        if ([keyPath isEqualToString:keyPath]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark- Action

- (void)timerAction
{
    static BOOL finish = YES;
    if (finish) {
        [self handleLeftTimeWithFinishedFlag:&finish];
    }
}

- (void)handleLeftTimeWithFinishedFlag:(BOOL * _Nonnull)finish {
    static NSUInteger index = 0;
    *finish = NO;
    NSInteger count = self.countdownModelDictM.count;
    
    if (count <= 0) {
        *finish = YES;
        index = 0;
        return;
    }
    __weak typeof(self)weakSelf = self;
    [self.countdownModelDictM enumerateKeysAndObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSString * _Nonnull key, AZCountdownModel * _Nonnull obj, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([strongSelf shouldUpdateLeftTimeWithModel:obj]) {
            if(!obj.isCanAutoRelease || (obj.isCanAutoRelease && obj.view != nil)){
                NSTimeInterval leftTime = [obj.deadline timeIntervalSinceDate:self.serverDate];
                obj.leftTime = leftTime;
            }else {
                [weakSelf stopCountdownWithKey:key];
            }
        }
        
        index++;
        if (index >= count) {
            *finish = YES;
            index = 0;
        }
    }];
 
}

#pragma mark- Getter

- (NSDate *)serverDate {
    return [NSDate dateWithTimeIntervalSinceNow:-_serverOffset];
}

- (NSArray<NSString *> *)keys {
    return self.countdownModelDictM.allKeys;
}

- (NSTimer *)timer {
    if (_timer == nil) {
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(timerAction)
                                               userInfo:nil
                                                repeats:YES];
        [self.runloop addTimer:timer forMode:NSDefaultRunLoopMode];
        _timer = timer;
    }
    return _timer;
}

- (NSMutableDictionary<NSString *,AZCountdownModel *> *)countdownModelDictM {
    if (_countdownModelDictM == nil) {
        _countdownModelDictM = [NSMutableDictionary dictionary];
    }
    return _countdownModelDictM;
}

@end

