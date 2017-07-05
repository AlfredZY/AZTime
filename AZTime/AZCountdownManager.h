//
//  AZCountdownManager.h
//  AZCountdownManager
//
//  Created by Alfred Zhang on 2017/4/10.
//  Copyright © 2017年 Alfred. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AZCountdownModel;

@interface AZCountdownManager : NSObject

@property (strong, nonatomic,readonly) NSMutableDictionary<NSString *, AZCountdownModel *> *countdownModelDictM;

/**
 本地时间和服务器时间的偏差量 default 0
 */
@property (nonatomic, assign) NSTimeInterval serverOffset;

+ (instancetype)sharedInstance;


+ (NSDate *)deadlieDateWithDuration:(NSTimeInterval)duration;

/**
 新增倒计时（重复添加无效 适用于cell这类复用时会重复设置数据的情况）
 
 @param view 对于cell这类会复用view的倒计时可以直接将cell或者倒计时的view作为key
 @param deadline 倒计时结束的时间（相对于本机时间）
 @param model 对于cell这类复用的传对应的数据模型 其他传nil
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
 新增倒计时（重复添加无效 适用于cell这类复用时会重复设置数据的情况）
 
 @param key 倒计时key 需保证唯一
 @param deadline 倒计时结束的时间（相对于本机时间）
 @param model 对于cell这类复用的传对应的数据模型 其他传nil
 @param interval 倒计时间隔 最小0.1s
 @param autoStop 倒计时到0时是否自动停止 NO会出现倒计时为负数的情况
 @param leftTimeChangedBlock 每间隔interval会调用一次block leftTime为剩余时间 model为传入的model
 */
- (void)addCountdownWithKey:(NSString *)key
               deadlineDate:(NSDate *)deadline
                      model:(NSObject *)model
                   interval:(NSTimeInterval)interval
                   autoStop:(BOOL)autoStop
       leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock;

///**
// 新增倒计时（重复添加无效 适用于cell这类复用时会重复设置数据的情况）
// 
// @param view 对于cell这类会复用view的倒计时可以直接将cell或者倒计时的view作为key
// @param duration 倒计时时间
// @param model 对于cell这类复用的传对应的数据模型 其他传nil
// @param interval 倒计时间隔 最小0.1s default0.5s
// @param autoStop 倒计时到0时是否自动停止 NO会出现倒计时为负数的情况
// @param leftTimeChangedBlock 每间隔interval会调用一次block leftTime为剩余时间 model为传入的model
// */
//- (void)addCountdownWithView:(UIView *)view
//                    duration:(NSTimeInterval)duration
//                       model:(NSObject *)model
//                    interval:(NSTimeInterval)interval
//                    autoStop:(BOOL)autoStop
//        leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock;
//
//
///**
// 新增倒计时（重复添加无效 适用于cell这类复用时会重复设置数据的情况）
//
// @param key 倒计时key 需保证唯一
// @param duration 倒计时时间
// @param model 对于cell这类复用的传对应的数据模型 其他传nil
// @param interval 倒计时间隔 最小0.1s
// @param autoStop 倒计时到0时是否自动停止 NO会出现倒计时为负数的情况
// @param leftTimeChangedBlock 每间隔interval会调用一次block leftTime为剩余时间 model为传入的model
// */
//- (void)addCountdownWithKey:(NSString *)key
//                   duration:(NSTimeInterval)duration
//                      model:(NSObject *)model
//                   interval:(NSTimeInterval)interval
//                   autoStop:(BOOL)autoStop
//       leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock;
//
///**
// 新增自动停止的倒计时（重复添加无效 适用于cell这类复用时会重复设置数据的情况）
// 
// @param key 倒计时key 需保证唯一
// @param duration 倒计时时间
// @param model 对于cell这类复用的传对应的数据模型 其他传nil
// @param interval 倒计时间隔
// @param leftTimeChangedBlock 每间隔interval会调用一次block leftTime为剩余时间 model为传入的model
// */
//- (void)addCountdownWithKey:(NSString *)key
//                   duration:(NSTimeInterval)duration
//                      model:(NSObject *)model
//                   interval:(NSTimeInterval)interval
//       leftTimeChangedBlock:(void (^)(NSTimeInterval leftTime, NSObject *model))leftTimeChangedBlock;
//

/**
 暂停倒计时

 @param key 倒计时的key
 */
- (void)pauseCountdownWithTimerKey:(NSString *)key;


/**
 停止倒计时

 @param key 倒计时的key
 */
- (void)stopCountdownWithKey:(NSString *)key;

@end



