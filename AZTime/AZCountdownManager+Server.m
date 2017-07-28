//
//  AZCountdownManager+Server.m
//  AZTime
//
//  Created by Alfred Zhang on 2017/7/5.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import "AZCountdownManager+Server.h"
#import "AZServerTimeManager.h"
#import <objc/runtime.h>

static NSString *const kKVOContent = @"AZCountdownManager_AutoUpdate";

@implementation AZCountdownManager (Server)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(observeValueForKeyPath:ofObject:change:context:);
        SEL swizzledSelector = @selector(az_countdown_server_observeValueForKeyPath:ofObject:change:context:);
        swizzleMethod([self class], originalSelector, swizzledSelector);
    });
}

static void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (void)autoUpdateServerOffsetWithVerifyUrl:(NSString *)verifyUrl {
    [self observeServerOffsetChange];
    [self updateServerTimeOffsetWithVerifyUrl:verifyUrl];
}

//获取本地时间和服务器之间的时间差
- (void)updateServerTimeOffsetWithVerifyUrl:(NSString *)verifyUrl {
    [AZServerTimeManager sharedInstance].verifyUrl = verifyUrl;
    __weak typeof(self) weakSelf = self;
    [[AZServerTimeManager sharedInstance] updateServerTimeOffset:^(BOOL success, NSTimeInterval offset) {
        __strong typeof(self) strongSelf = weakSelf;
        if (success) {
            strongSelf.serverOffset = offset;
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf updateServerTimeOffsetWithVerifyUrl:verifyUrl];
            });
        }
    }];
}

//监听offset的变化
- (void)observeServerOffsetChange {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[AZServerTimeManager sharedInstance] addObserver:self forKeyPath:@"offset" options:NSKeyValueObservingOptionNew context:(__bridge void * _Nullable)(kKVOContent)];
    });
}

#pragma mark- KVO

- (void)az_countdown_server_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"offset"] && [(__bridge NSString * _Nonnull)(context) isEqualToString:kKVOContent]) {
        NSTimeInterval offset = [change[NSKeyValueChangeNewKey] doubleValue];
        self.serverOffset = offset;
    }
    [self az_countdown_server_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


@end
