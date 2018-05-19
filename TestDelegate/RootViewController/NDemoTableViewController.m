//
//  NDemoTableViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/19.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NDemoTableViewController.h"
#import "UrlCacheViewController.h"
#import "NMatlabViewController.h"
#import "NCacheViewController.h"

static NSString * const ReuseIdentifier = @"ReuseIdentifier";

@interface NDemoTableViewController ()
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation NDemoTableViewController

- (NSArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [[NSArray  alloc] init];
    }return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"练习";
    [self.tableView  registerClass:[UITableViewCell  class] forCellReuseIdentifier:ReuseIdentifier];
    self.dataSource = @[@"算法", @"缓存/磁盘缓存", @"tableView流畅度"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView   selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    if (indexPath.row == 0) {//算法
        NMatlabViewController *nMatlabView = [[NMatlabViewController  alloc] init];
        [self.navigationController  pushViewController:nMatlabView animated:YES];
    }else if (indexPath.row == 1){//缓存/磁盘缓存
        NCacheViewController *nCacheVC = [[NCacheViewController  alloc] init];
        [self.navigationController  pushViewController:nCacheVC animated:YES];
    }else if (indexPath.row == 2){//tableview流畅度
        UrlCacheViewController *urlCacheVc = [[UrlCacheViewController alloc] init];
        [self.navigationController  pushViewController:urlCacheVc animated:YES];
    }
    
}



@end
