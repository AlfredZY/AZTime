//
//  TimerTableViewController.m
//  RACDemo
//
//  Created by Alfred Zhang on 2017/4/24.
//  Copyright © 2017年 com.alfred.demo. All rights reserved.
//

#import "TimerTableViewController.h"
#import "TimerCell.h"
#import "NSObject+AZCountDownExtension.h"


@interface TimerTableViewController ()

@property (nonatomic, copy) NSArray *data;

@end

@implementation TimerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.data = [self fetchData];
    [self.tableView reloadData];
}


- (void)reload {
    self.data = [self fetchData];
    [self.tableView reloadData];
}

- (NSArray *)fetchData {
    NSMutableArray *arrM = [NSMutableArray array];
    for (NSInteger i = 0; i < 3000; i++) {
        TimeModel *model = [[TimeModel alloc] init];
        model.duration = random() % 300;
        model.index = i;
        //对于服务器传回来的是duration的需要在model获取时就设置deadlineDate
        //否则会导致未加载到tableView上的cell时间错误
        //在添加倒计时时 deadlineDate传nil
        //如果服务器返回的就是date则不需要设置 在添加倒计时时 deadlineDate传date
        [model setDeadlineDateWithDuration:model.duration];
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
    [btn setTitle:@"ReloadDate" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor orangeColor];
    return btn;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [TimerCell cellWithTableView:tableView model:self.data[indexPath.row]];
}


@end
