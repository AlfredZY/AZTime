//
//  AZCountdownModel.h
//  AZTime
//
//  Created by Alfred Zhang on 2017/6/30.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AZCountdownModel : NSObject

@property (copy, nonatomic) NSString *key;
@property (weak, nonatomic) NSObject *model;
@property (assign, nonatomic) NSTimeInterval interval; //倒计时间隔
@property (assign, nonatomic) BOOL autoStop; //倒计时到0时是否自动停止
@property (assign, nonatomic) NSTimeInterval leftTime;
@property (strong, nonatomic) NSDate *deadLine;
@property (assign, nonatomic,getter = isAddObserver) BOOL addObserver;
@property (strong, nonatomic) NSDate *preUpdateDate;

@property (copy, nonatomic) void (^leftTimeChangedBlock)(NSTimeInterval,NSObject *);

@end
