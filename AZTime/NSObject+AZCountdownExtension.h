//
//  NSObject+AZCountdownExtension.h
//  RACDemo
//
//  Created by Alfred Zhang on 2017/6/30.
//  Copyright © 2017年 com.alfred.demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (AZCountdownExtension)

@property (nonatomic, strong) NSDate *az_deadLineDate;

- (void)setDeadlineDateWithDuration:(NSTimeInterval)duration;


@end
