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
#import "NSObject+AZCountdownExtension.h"


static const NSTimeInterval kDefaultInterval = 0.5;

#define AZViewKey(view) [NSString stringWithFormat:@"key:%p",view]

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

- (void)addCountdownWithView:(UIView *)view
                deadlineDate:(NSDate *)deadline
                       model:(NSObject *)model
                    interval:(NSTimeInterval)interval
                    autoStop:(BOOL)autoStop
        leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock {
    [self addCountdownWithKey:AZViewKey(view) deadlineDate:deadline model:model interval:interval autoStop:autoStop leftTimeChangedBlock:leftTimeChangedBlock];
}

- (void)addCountdownWithKey:(NSString *)key
               deadlineDate:(NSDate *)deadline
                      model:(NSObject *)model
                   interval:(NSTimeInterval)interval
                   autoStop:(BOOL)autoStop
       leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock {
    if (!(key.length > 0)) {
        return;
    }
    
    AZCountdownModel *countdown = self.countdownModelDictM[key];
    if (countdown == nil) {
        countdown = [[AZCountdownModel alloc] init];
    }
    if (model != nil) {
        if (model.az_deadLineDate == nil) {
            model.az_deadLineDate = deadline;
        }
        countdown.model = model;
    }else{
        countdown.deadline = deadline;
    }

    countdown.interval = interval > 0 ? interval : kDefaultInterval;
    countdown.leftTimeChangedBlock = leftTimeChangedBlock;
    countdown.autoStop = autoStop;
    [self.countdownModelDictM setValue:countdown forKey:key];
    
    if (countdown.isAddObserver == NO) {
        [countdown addObserver:self forKeyPath:@"leftTime" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nonnull)(key)];
        countdown.addObserver = YES;
    }
    countdown.leftTime = [countdown.model.az_deadLineDate timeIntervalSinceDate:self.serverDate];
    
    [self runTimer];
}

- (void)updateCountdownWithKey:(NSString *)key
               deadlineDate:(NSDate *)deadline
                      model:(NSObject *)model
                   interval:(NSTimeInterval)interval
                   autoStop:(BOOL)autoStop
       leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock {
    [self stopCountdownWithKey:key];
    [self addCountdownWithKey:key deadlineDate:deadline model:model interval:interval autoStop:autoStop leftTimeChangedBlock:leftTimeChangedBlock];
}

- (void)updateCountdownWithView:(UIView *)view
                deadlineDate:(NSDate *)deadline
                       model:(NSObject *)model
                    interval:(NSTimeInterval)interval
                    autoStop:(BOOL)autoStop
        leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock {
    [self updateCountdownWithKey:AZViewKey(view) deadlineDate:deadline model:model interval:interval autoStop:autoStop leftTimeChangedBlock:leftTimeChangedBlock];
}

- (void)ignoreCountdownWithKey:(NSString *)key {
    [self removeObserverWithKey:key clearDeadLineDate:NO];
}

- (void)ignoreCountdownWithView:(UIView *)view {
    [self removeObserverWithKey:AZViewKey(view) clearDeadLineDate:NO];
}

- (void)stopCountdownWithKey:(NSString *)key {
    [self removeObserverWithKey:key clearDeadLineDate:YES];
}

- (void)stopCountdownWithView:(UIView *)view {
    [self removeObserverWithKey:AZViewKey(view) clearDeadLineDate:YES];
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

- (void)removeObserverWithKey:(NSString *)key clearDeadLineDate:(BOOL)clear {
    if (!(key.length > 0)) {
        return;
    }
    AZCountdownModel *model = self.countdownModelDictM[key];
    if (model) {
        if (model.isAddObserver) {
            [model removeObserver:self forKeyPath:@"leftTime" context:(__bridge void * _Nonnull)(key)];
        }
        model.addObserver = NO;
        if (clear) {
            model.model.az_deadLineDate = nil;
        }
        [self.countdownModelDictM setValue:nil forKey:key];
    }
    
    [self checkShouldStop];
}

#pragma mark- KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"leftTime"]) {
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
                        countdownModel.leftTimeChangedBlock(0, countdownModel.model);
                        if (!countdownModel.isDelayCheck) {
                            countdownModel.delayCheck = YES;
                            [self performSelector:@selector(checkShouldIgnoreCountdownWithKey:) withObject:key afterDelay:60];

                        }
//                        [self ignoreCountdownWithKey:key];
                    }else{
                        countdownModel.leftTimeChangedBlock(leftTime, countdownModel.model);
                    }
                }else{
                    countdownModel.leftTimeChangedBlock(leftTime, countdownModel.model);
                }
            });
        }
    }
}

- (void)checkShouldIgnoreCountdownWithKey:(NSString *)key {
    AZCountdownModel *countdownModel = self.countdownModelDictM[key];
    if (countdownModel.leftTime <= 0) {
        [self ignoreCountdownWithKey:key];
    }
    countdownModel.delayCheck = NO;
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
    if (self.countdownModelDictM.count <= 0) {
        *finish = YES;
        index = 0;
        return;
    }
    __weak typeof(self)weakSelf = self;
    [self.countdownModelDictM enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, AZCountdownModel * _Nonnull obj, BOOL * _Nonnull stop) {
        __strong typeof(self) strongSelf = weakSelf;
        if ([strongSelf shouldUpdateLeftTimeWithModel:obj]) {
            if (obj.model != nil) {
                NSTimeInterval leftTime = [obj.model.az_deadLineDate timeIntervalSinceDate:self.serverDate];
                obj.leftTime = leftTime;
            }else{
                NSTimeInterval leftTime = [obj.deadline timeIntervalSinceDate:self.serverDate];
                obj.leftTime = leftTime;
            }
        }
        
        index++;
        if (index >= strongSelf.countdownModelDictM.count) {
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

