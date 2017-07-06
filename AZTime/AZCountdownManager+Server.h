//
//  AZCountdownManager+Server.h
//  AZTime
//
//  Created by Alfred Zhang on 2017/7/5.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import "AZCountdownManager.h"

@interface AZCountdownManager (Server)


/**
 自动更新本地和服务器时间的偏移量和AZCountdownManager的serverOffset
 
 @param verifyUrl 校对的URL
 */
- (void)autoUpdateServerOffsetWithVerifyUrl:(NSString *)verifyUrl;

@end
