//
//  AZServerTimeManager.h
//  AZTime
//
//  Created by Alfred Zhang on 2017/7/3.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AZServerTimeManagerBlock)(BOOL success,NSTimeInterval offset);

@interface AZServerTimeManager : NSObject

/**
 本地时间和服务器时间的偏差量(>0表示比服务器时间快)
 */
@property (assign, nonatomic, readonly) NSTimeInterval offset;

/**
 校验时间的URL
 */
@property (copy, nonatomic) NSString *verifyUrl;

+ (instancetype)sharedInstance;

/**
 更新与服务器时间的差值 需要先设置verifyUrl 更新完成后offset为最新的偏移量

 @param completion 是否更新完成、偏移量
 */
- (void)updateServerTimeOffset:(AZServerTimeManagerBlock)completion;

@end
