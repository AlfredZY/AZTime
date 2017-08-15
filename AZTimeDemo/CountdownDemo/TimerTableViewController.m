//
//  TimerTableViewController.m
//  AZTime
//
//  Created by Alfred Zhang on 2017/4/24.
//  Copyright © 2017年 com.alfred.AZTime. All rights reserved.
//

#import "TimerTableViewController.h"
#import "TimerCell.h"
#import "AZTime.h"

@interface TimerTableViewController ()

@property (nonatomic, copy) NSArray *data;

@end

@implementation TimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reload];
}

- (void)reload {
    self.data = [self fetchData];
    [self.tableView reloadData];
}

- (NSArray *)fetchData {
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i = 0; i < 200; i++) {
        TimeModel *model = [[TimeModel alloc] init];
        model.index = i;
        model.date = [NSDate dateWithTimeIntervalSinceNow:random() % 60];
        [arrM addObject:model];
    }
    return [arrM copy];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44)];
    [btn addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"ReloadData" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    return btn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TimerCell cellWithTableView:tableView model:self.data[indexPath.row]];
}


@end
