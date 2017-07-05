//
//  TimeModel.h
//  RACDemo
//
//  Created by Alfred Zhang on 2017/4/24.
//  Copyright © 2017年 com.alfred.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,TimeModelType) {
    TimeModelTypeDuration = 0,
    TimeModelTypeDeadlineDate,
};

@interface TimeModel : NSObject

@property (nonatomic, assign) TimeModelType type;
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) NSInteger index;

@end
