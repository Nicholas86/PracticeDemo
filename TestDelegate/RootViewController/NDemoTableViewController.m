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
#import "NComposeViewController.h"
#import "NObserverViewController.h"
#import "NImageDecodeViewController.h"
#import "NUIViewCALayerViewController.h"

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
    
    self.title = @"练习";
    [self.tableView  registerClass:[UITableViewCell  class] forCellReuseIdentifier:ReuseIdentifier];

    self.dataSource = @[@"算法", @"缓存/磁盘缓存", @"tableView流畅度", @"组件化", @"观察者", @"大图解码", @"UIView和CALayer的联系和区别"];
    self.tableView.tableFooterView = [UIView new];
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

//单元格赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

//单元格选中事件
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
    }else if (indexPath.row == 3){//组件化
        NComposeViewController  *nComposeVC = [[NComposeViewController  alloc] init];
        [self.navigationController  pushViewController:nComposeVC animated:YES];
    }else if (indexPath.row == 4){//观察者
        NObserverViewController *nObserverVC = [[NObserverViewController alloc] init];
        [self.navigationController pushViewController:nObserverVC animated:YES];
    }else if (indexPath.row == 5){//大图解码
        NImageDecodeViewController *nImageVC = [[NImageDecodeViewController  alloc] init];
        [self.navigationController pushViewController:nImageVC animated:YES];
    }else if (indexPath.row == 6){//UIView和CALayer的联系和区别
        NUIViewCALayerViewController *calayerVC = [[NUIViewCALayerViewController alloc] init];
        [self.navigationController pushViewController:calayerVC animated:YES];
    }
    
}



@end
