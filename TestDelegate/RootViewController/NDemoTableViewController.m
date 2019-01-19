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
#import "NURLSessionViewController.h"
#import "NResponderViewController.h"
#import "NSingle.h"
#import "NEqualViewController.h"
#import "NOperationViewController.h"
#import "NRunloopViewController.h"

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

    
//    NSingle *single = [NSingle share];
//    [single creatTimerWithBlock:^{
//        NSLog(@"single");
//    }];

    self.dataSource = @[@"算法", @"缓存/磁盘缓存", @"tableView流畅度", @"组件化", @"观察者", @"大图解码", @"UIView和CALayer的联系和区别", @"NSURLSession/AFNetworking 3.1.0", @"响应者", @"对象等同性", @"NSOperationQueue", @"Runloop"];
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
    }else if (indexPath.row == 7){//网络请求、AFNetworking 3.1.0
        NURLSessionViewController *urlSessionVC = [[NURLSessionViewController alloc] init];
        [self.navigationController pushViewController:urlSessionVC animated:YES];
    }else if (indexPath.row == 8){//响应者
        NResponderViewController *responderVC = [[NResponderViewController alloc] init];
        [self.navigationController pushViewController:responderVC animated:YES];
    }else if (indexPath.row == 9){//对象等同性
        NEqualViewController *equalVC = [[NEqualViewController alloc] init];
        [self.navigationController pushViewController:equalVC animated:YES];
    }else if (indexPath.row == 10){//NSOperationQueue
        NOperationViewController *queueVC = [[NOperationViewController alloc] init];
        [self.navigationController pushViewController:queueVC animated:YES];
    }else if (indexPath.row == 11){//NSRunloop
        NRunloopViewController *queueVC = [[NRunloopViewController alloc] init];
        [self.navigationController pushViewController:queueVC animated:YES];
    }
    
}



@end
