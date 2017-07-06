//
//  AZCountdownManager.h
//  AZTime
//
//  Created by Alfred Zhang on 2017/4/10.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZCountdownModel;

@interface AZCountdownManager : NSObject

/**
 本地时间和服务器时间的偏差量 default 0
 */
@property (nonatomic, assign) NSTimeInterval serverOffset;


/**
 基于serverOffset计算得到的服务器时间
 */
@property (nonatomic, strong, readonly) NSDate *serverDate;


+ (instancetype)sharedInstance;


/**
获取相对服务器的deadline

 @param duration 倒计时持续时间
 @return 相对服务器的deadlin
 */
- (NSDate *)serverDeadlieDateWithDuration:(NSTimeInterval)duration;

/**
 新增倒计时
 
 @param view 对于cell这类会复用view的倒计时可以直接将cell或者倒计时的view作为key
 @param deadline 倒计时结束的时间
 @param model 对于cell这类会复用的传对应的model其他传nil
 @param interval 倒计时间隔 最小0.1s default0.5s
 @param autoStop 倒计时到0时是否自动停止 NO会出现倒计时为负数的情况
 @param leftTimeChangedBlock 每间隔interval会调用一次block leftTime为剩余时间 model为传入的model
 */
- (void)addCountdownWithView:(UIView *)view
                deadlineDate:(NSDate *)deadline
                       model:(NSObject *)model
                    interval:(NSTimeInterval)interval
                    autoStop:(BOOL)autoStop
        leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock;


/**
 新增倒计时 
 
 @param key 倒计时key
 */
- (void)addCountdownWithKey:(NSString *)key
               deadlineDate:(NSDate *)deadline
                      model:(NSObject *)model
                   interval:(NSTimeInterval)interval
                   autoStop:(BOOL)autoStop
       leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock;


/**
 更新倒计时设置
 */
- (void)updateCountdownWithKey:(NSString *)key
                  deadlineDate:(NSDate *)deadline
                         model:(NSObject *)model
                      interval:(NSTimeInterval)interval
                      autoStop:(BOOL)autoStop
          leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock;


- (void)updateCountdownWithView:(UIView *)view
                   deadlineDate:(NSDate *)deadline
                          model:(NSObject *)model
                       interval:(NSTimeInterval)interval
                       autoStop:(BOOL)autoStop
           leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock;

/**
 停止监听倒计时
 */
- (void)ignoreCountdownWithKey:(NSString *)key;

- (void)ignoreCountdownWithView:(UIView *)view;

/**
 停止倒计时
 */
- (void)stopCountdownWithKey:(NSString *)key;

- (void)stopCountdownWithView:(UIView *)view;

@end



