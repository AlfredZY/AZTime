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
//    self.model = [NSObject new];
    [self updateTimer];

}

- (void)dealloc {
    NSLog(@"dealloc:%s",__func__);
    [[AZCountdownManager sharedInstance] stopCountdownWithKey:@"key"];
}

- (void)updateTimer {
    __weak typeof(self) weakSelf = self;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceNow:rand()%60];
    
    [[AZCountdownManager sharedInstance] addCountdownWithKey:@"key"
                                                deadlineDate:newDate
                                                    interval:0.3
                                                    autoStop:YES
                                        leftTimeChangedBlock:^(NSTimeInterval leftTime, UIView *view, NSString *key) {
                                            __strong typeof(self) strongSelf = weakSelf;
                                            strongSelf.countdownLabel.text = [NSString stringWithFormat:@"%0.0f",leftTime];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self updateTimer];
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
