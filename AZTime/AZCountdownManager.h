//
//  AZCountdownManager.h
//  AZTime
//
//  Created by Alfred Zhang on 2017/4/10.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZCountdownModel;

typedef void(^AZLeftTimeChangedBlock)(NSTimeInterval leftTime, UIView * _Nullable view, NSString * _Nonnull key);

@interface AZCountdownManager : NSObject

/**
 已经添加的倒计时key
 */
@property (strong, nonatomic, readonly) NSArray<NSString *> * _Nullable keys;

/**
 本地时间和服务器时间的偏差量 default 0
 
 ex: 服务器时间 2017-08-15 12:00:00 , 本地时间 2017-08-15 12:00:10 则 serverOffset = 10
 */
@property (nonatomic, assign) NSTimeInterval serverOffset;

/**
 基于serverOffset计算得到的服务器时间
 */
@property (nonatomic, strong, readonly) NSDate * _Nonnull serverDate;

+ (instancetype _Nonnull )sharedInstance;

- (BOOL)isExistKey:(nonnull NSString *)key;
- (BOOL)isExistView:(nonnull UIView *)view;
- (NSString *_Nullable)keyFromView:(nonnull UIView *)view;

/**
获取相对服务器的deadline

 @param duration 倒计时持续时间
 @return 相对服务器的deadlin
 */
- (NSDate *_Nonnull)serverDeadlieDateWithDuration:(NSTimeInterval)duration;

/**
 添加一个根据view自动生成key的倒计时，倒计时生命周期和view一样

 */
- (void)addCountdownWithView:(UIView *_Nonnull)view
                deadlineDate:(NSDate *_Nonnull)deadline
                    interval:(NSTimeInterval)interval
                    autoStop:(BOOL)autoStop
        leftTimeChangedBlock:(AZLeftTimeChangedBlock _Nullable )leftTimeChangedBlock;

/**
 添加一个自定义key的倒计时
 
 当autoStop = YES 时，倒计时到 0 后会自动停止
 当autoStop = NO 需要手动停止 ，否则倒计时会一直运行
 */
- (void)addCountdownWithKey:(NSString *_Nonnull)key
                deadlineDate:(NSDate *_Nonnull)deadline
                    interval:(NSTimeInterval)interval
                    autoStop:(BOOL)autoStop
        leftTimeChangedBlock:(AZLeftTimeChangedBlock _Nullable )leftTimeChangedBlock;

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

/**
 停止倒计时
 */
- (void)stopCountdownWithKey:(NSString *_Nonnull)key;
- (void)stopCountdownWithView:(UIView *_Nonnull)view;

@end



