//
//  ServerTimeViewController.m
//  AZTimeDemo
//
//  Created by Alfred Zhang on 2017/7/4.
//  Copyright © 2017年 Alfred Zhang. All rights reserved.
//

#import "ServerTimeViewController.h"
#import "AZTime.h"

static NSString *const kDefaultUrl = @"https://www.baidu.com";

@interface ServerTimeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
- (IBAction)verifyBtn:(UIButton *)sender;
- (IBAction)clearBtn:(UIButton *)sender;

@property (copy, nonatomic) NSString *history;

@end

@implementation ServerTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textField.text = kDefaultUrl;
    self.history = @"";
}

- (IBAction)verifyBtn:(UIButton *)sender {
    NSString *url = self.textField.text;
    [AZServerTimeManager sharedInstance].verifyUrl = url;
    [[AZServerTimeManager sharedInstance] updateServerTimeOffset:^(BOOL success,NSTimeInterval offset) {
        if (success) {
            NSString * history = [NSString stringWithFormat:@"%@\nUrl:%@ -->offset:%lld",self.history,url,(long long)offset];
            self.history = history;
        }else{
            NSString * history = [NSString stringWithFormat:@"%@\nUrl:%@ -->failed",self.history,url];
            self.history = history;
        }
    }];
}

- (IBAction)clearBtn:(UIButton *)sender {
    self.textView.text = @"";
    self.history = @"";
}

- (void)setHistory:(NSString *)history {
    _history = [history copy];
    self.textView.text = _history;
}

@end
