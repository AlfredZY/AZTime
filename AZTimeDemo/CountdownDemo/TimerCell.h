//
//  TimerCell.h
//  RACDemo
//
//  Created by Alfred Zhang on 2017/4/24.
//  Copyright © 2017年 com.alfred.demo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimeModel.h"

@interface TimerCell : UITableViewCell

@property (nonatomic, strong) TimeModel *model;

+ (instancetype)cellWithTableView:(UITableView *)tableView model:(TimeModel *)model;

@end
