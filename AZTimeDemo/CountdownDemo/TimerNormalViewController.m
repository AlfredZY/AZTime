//
//  TimerNormalViewController.m
//  AZTimeDemo
//
//  Created by Alfred Zhang on 2017/7/20.
//  Copyright © 2017年 Alfred Zhang. All rights reserved.
//

#import "TimerNormalViewController.h"
#import "AZTime.h"

@interface TimerNormalViewController ()

@property (nonatomic, strong) UILabel *countdownLabel;
@property (nonatomic, strong) NSObject *model;
@end

@implementation TimerNormalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customSetup];
}

- (void)customSetup {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customLayout];
    [self subscribe];
}

- (void)customLayout {
    [self.view addSubview:self.countdownLabel];
    
    self.countdownLabel.frame = CGRectMake(0, 65, [UIScreen mainScreen].bounds.size.width, 44);
}

- (void)subscribe {
    self.model = [NSObject new];
    [self updateTimer];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateTimer];
    });
    
   
}

- (void)updateTimer {
    __weak typeof(self) weakSelf = self;
    [[AZCountdownManager sharedInstance] updateCountdownWithView:self.countdownLabel
                                                    deadlineDate:[NSDate dateWithTimeIntervalSinceNow:random() % 60]
                                                           model:self.model
                                                        interval:0.3
                                                        autoStop:YES
                                            leftTimeChangedBlock:^(NSTimeInterval leftTime, NSObject *model) {
                                                __strong typeof(self) strongSelf = weakSelf;
                                                strongSelf.countdownLabel.text = [NSString stringWithFormat:@"%0.0f",leftTime];
                                            }];
}

#pragma mark- Getter

- (UILabel *)countdownLabel {
    if (_countdownLabel == nil) {
        UILabel *view = [[UILabel alloc] init];
        view.textAlignment = NSTextAlignmentCenter;
        _countdownLabel = view;
    }
    return _countdownLabel;
}

@end
