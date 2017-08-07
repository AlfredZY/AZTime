//
//  AZCountdownModel.h
//  AZTime
//
//  Created by Alfred Zhang on 2017/6/30.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface AZCountdownModel : NSObject

@property (copy, nonatomic) NSString *key;
@property (nonatomic, weak) UIView *view;
@property (assign, nonatomic) NSTimeInterval interval; //倒计时间隔
@property (assign, nonatomic) BOOL autoStop; //倒计时到0时是否自动停止
@property (assign, nonatomic) NSTimeInterval leftTime;
@property (strong, nonatomic) NSDate *deadline;
@property (assign, nonatomic,getter = isDelayCheck) BOOL delayCheck;
@property (assign, nonatomic,getter = isCanAutoRelease) BOOL canAutoRelease; // 是否能自释放
@property (strong, nonatomic) NSDate *preUpdateDate;

@property (copy, nonatomic) void (^leftTimeChangedBlock)(NSTimeInterval leftTime, UIView *view, NSString *key);

@end
