//
//  AZCountdownManager+Server.h
//  AZTime
//
//  Created by Alfred Zhang on 2017/7/5.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import "AZCountdownManager.h"

@interface AZCountdownManager (Server)

- (void)autoUpdateServerOffsetWithVerifyUrl:(NSString *)verifyUrl;

@end
