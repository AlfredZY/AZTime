//
//  TimerCell.m
//  RACDemo
//
//  Created by Alfred Zhang on 2017/4/24.
//  Copyright © 2017年 com.alfred.demo. All rights reserved.
//

#import "TimerCell.h"
#import "AZCountDownManager.h"

static NSString *const kID = @"TimerCellID";

@interface TimerCell()

@end


@implementation TimerCell

+ (instancetype)cellWithTableView:(UITableView *)tableView model:(TimeModel *)model {
    
    TimerCell *cell = [tableView dequeueReusableCellWithIdentifier:kID];
    if (cell == nil) {
        cell = [[TimerCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:kID];
    }
    cell.model = model;
    return cell;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
    }
    return self;
}

- (void)setModel:(TimeModel *)model {
    _model = model;
    __weak typeof(self) weakSelf = self;
    
    [[AZCountdownManager sharedInstance] addCountdownWithView:self deadlineDate:nil model:model interval:0.3 autoStop:YES leftTimeChangedBlock:^(NSTimeInterval leftTime, NSObject *model) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.textLabel.text = [NSString stringWithFormat:@"No:%ld",((TimeModel *)model).index];
        strongSelf.detailTextLabel.text = [NSString stringWithFormat:@"Countdown:%.0f",leftTime];
    }];
    
}


@end
