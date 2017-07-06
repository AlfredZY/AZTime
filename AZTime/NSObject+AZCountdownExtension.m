//
//  NSObject+AZCountdownExtension.m
//  AZTime
//
//  Created by Alfred Zhang on 2017/6/30.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import "NSObject+AZCountdownExtension.h"
#import <objc/runtime.h>

@implementation NSObject (AZCountdownExtension)

- (NSDate *)az_deadLineDate {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setAz_deadLineDate:(NSDate *)az_deadLineDate {
    objc_setAssociatedObject(self, @selector(az_deadLineDate), az_deadLineDate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setDeadlineDateWithDuration:(NSTimeInterval)duration {
    self.az_deadLineDate = [NSDate dateWithTimeInterval:duration sinceDate:[NSDate date]];;
}



@end
