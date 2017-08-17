//
//  AZSurverTimeManager.m
//  AZTime
//
//  Created by Alfred Zhang on 2017/7/3.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import "AZServerTimeManager.h"
#import "NSDate+InternetDateTime.h"

@interface AZServerTimeManager ()

@property (assign, nonatomic, readwrite) NSTimeInterval offset;

@end

@implementation AZServerTimeManager

#pragma mark- Singleton

static AZServerTimeManager *_instance;

+ (instancetype)sharedInstance {
    if (!_instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _instance = [[self alloc] init];
        });
    }
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
        [_instance addSysTimeChangeNotification];
        
    });
    return _instance;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- Public Method

- (void)updateServerTimeOffset:(AZServerTimeManagerBlock)completion {
    
    if (!(self.verifyUrl.length > 0)) {
        if (completion) {
            completion(NO,0);
        }
        return;
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:self.verifyUrl];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"HEAD"];
    NSDate *requestDate = [NSDate date];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        __strong typeof(self) strongSelf = weakSelf;
        NSDate *now = [NSDate date];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
        NSDate *responseDate = [NSDate dateFromRFC822String:httpResponse.allHeaderFields[@"Date"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseDate != nil ) {
                CGFloat delta = ([now timeIntervalSince1970] - [requestDate timeIntervalSince1970]) / 2.f;
                strongSelf.offset = ( [requestDate timeIntervalSince1970] + delta - [responseDate timeIntervalSince1970]);
                if (completion) {
                    completion(YES,strongSelf.offset);
                }
            }else{
                if (completion) {
                    completion(NO,0);
                }
            }
        });

    }];
    
    [task resume];
}

#pragma mark- Private Method
//监听系统时间更改
- (void)addSysTimeChangeNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(privateUpdateServerTimeOffset) name:UIApplicationSignificantTimeChangeNotification object:nil];
}

- (void)privateUpdateServerTimeOffset {
    __weak typeof(self) weakSelf = self;
    [self updateServerTimeOffset:^(BOOL success,NSTimeInterval offset) {
        __strong typeof(self) strongSelf = weakSelf;
        if (!success) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [strongSelf privateUpdateServerTimeOffset];
            });
        }
    }];
}

@end
