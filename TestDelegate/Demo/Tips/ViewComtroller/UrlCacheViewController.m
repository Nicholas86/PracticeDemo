//
//  UrlCacheViewController.m
//  TestDelegate
//
//  Created by a on 2018/3/21.
//  Copyright © 2018年 a. All rights reserved.
//


/*
 控制器代码规范:
 
 https://casatwy.com/iosying-yong-jia-gou-tan-viewceng-de-zu-zhi-he-diao-yong-fang-an.html
 */

#import "UrlCacheViewController.h"
#import "NTipsViewModel.h"
#import "NTipsModel.h"
#import "NTipsTableViewCell.h"
#import <SafariServices/SafariServices.h>

@interface UrlCacheViewController ()<UITableViewDelegate, UITableViewDataSource, UIViewControllerPreviewingDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIView *tableFooterView;//页脚
@property (nonatomic, strong) UIActivityIndicatorView *loadingMoreIndicatorView;//滑动指示器
@property (nonatomic, strong) NSMutableArray <NTipsModel *>*dataSource;//数据源
@property (nonatomic, strong) UIButton *confirmButton;//确认按钮
@property (nonatomic, assign) NSInteger page;//页数
@property (nonatomic, strong) NTipsViewModel *tipsViewModel;
@property (nonatomic, assign) BOOL isLoadingData;//是否正在加载数据
@property (nonatomic, assign) BOOL hasMoreData;//是否有更多数据
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end

@implementation UrlCacheViewController

#pragma mark life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"代码规范 && iOS知识小集";
    
    //加载控件
    [self  configureSubViews];
    [self  requestUrlCacheData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//加载控件
- (void)configureSubViews
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView  registerNib:[UINib  nibWithNibName:@"NTipsTableViewCell" bundle:nil] forCellReuseIdentifier:@"NTipsTableViewCell"];
    [self  cleanTableViewFooter];//清除页脚
    
    //配置tableView刷新控件
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = self.refreshControl;
    } else {
        // Fallback on earlier versions
    }
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem  alloc] initWithCustomView:self.confirmButton];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

#pragma mark 请求数据
//请求数据
- (void)requestUrlCacheData
{
    if (self.isLoadingData) {
        NSLog(@"正在加载数据。。。");
        return;
    }
    self.isLoadingData = YES;
    __weak typeof(self) weakSelf = self;
    if (self.page == 1) {
        [self.dataSource  removeAllObjects];
    }

    [self.tipsViewModel  requestTipsDataWithPage:self.page
                                           cache:^(NSMutableArray *responseObject) {
    if ([responseObject isKindOfClass:[NSArray class]] && [responseObject count] > 0) {
        weakSelf.dataSource = (NSMutableArray *)responseObject;
        [weakSelf.tableView  reloadData];
    }
    }successBlock:^(NSMutableArray <NTipsModel *>*responseObject, BOOL hasMoreData) {
        if (hasMoreData) {
            //还有更多数据
            weakSelf.dataSource = responseObject;
            weakSelf.hasMoreData = YES;
            [weakSelf showTableViewFooter];
        }else{
            //无更多数据
            weakSelf.hasMoreData = NO;
            [weakSelf cleanTableViewFooter];
        }
        [weakSelf tipsDidEndRefresh];
        [weakSelf.tableView  reloadData];
    } failureBlock:^(NSError *error) {
        [weakSelf  tipsDidEndRefresh];
        NSLog(@"网络请求失败: %@", error);
    }];
    
}

#pragma mark - Private Methods
//结束刷新
- (void)tipsDidEndRefresh
{
    self.isLoadingData = NO;
    // 延迟 1 秒结束刷新
    // 时间越短, 上拉加载越卡顿, 50FPS, 45FPS
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.refreshControl endRefreshing];
        if (self.loadingMoreIndicatorView.isAnimating) {
            [self.loadingMoreIndicatorView stopAnimating];
        }
    });
    
}

//去除tableView页脚
- (void)cleanTableViewFooter
{
    [self.tableView setTableFooterView:[UIView new]];
}

//设置tableView页脚
- (void)showTableViewFooter
{
    if (self.tableView.tableFooterView != self.tableFooterView) {
        self.tableView.tableFooterView = self.tableFooterView;
    }
}

//加载详情数据
- (SFSafariViewController *)getDetailViewControllerAtIndexPath:(NSIndexPath *)indexPath  API_AVAILABLE(ios(9.0)){
    if (indexPath.row < self.dataSource.count) {
        NTipsModel *model = self.dataSource[indexPath.row];
        if (model.url) {
            NSURL *url = [NSURL URLWithString:model.url];
            if (@available(iOS 9.0, *)) {
                SFSafariViewController *sfViewController = [[SFSafariViewController alloc] initWithURL:url];
                if (@available(iOS 11.0, *)) {
                    sfViewController.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
                } else {
                    // Fallback on earlier versions
                }
                if (@available(iOS 11.0, *)) {
                    sfViewController.dismissButtonStyle = SFSafariViewControllerDismissButtonStyleClose;
                } else {
                    // Fallback on earlier versions
                }
                return sfViewController;
            } else {
                // Fallback on earlier versions
            }
        }
    }
    return nil;
}


#pragma mark - UIViewControllerPreviewingDelegate

// 3D Touch 预览模式
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location {
    if (@available(iOS 9.0, *)) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[previewingContext sourceView]];
        return [self getDetailViewControllerAtIndexPath:indexPath];
    } else {
        // Fallback on earlier versions
    }
    return nil;
}

// 3D Touch 继续按压进入
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self presentViewController:viewControllerToCommit animated:YES completion:nil];
}

#pragma mark custom delegate 控制器遵守自定义代理



#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

//单元格赋值
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NTipsTableViewCell *cell = [tableView  dequeueReusableCellWithIdentifier:@"NTipsTableViewCell" forIndexPath:indexPath];
    
    if (self.dataSource.count == 0) {
        return cell;
    }
    
    [cell cellForRowWithTipsModel:self.dataSource[indexPath.row]];
    
    // 为 Cell 添加 3D Touch 支持
    if (@available(iOS 9.0, *)) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        }
    } else {
        // Fallback on earlier versions
    }
    
    return cell;
}

//单元格选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count == 0) {
        NSLog(@"数据源为空。。。");
        return;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (@available(iOS 9.0, *)) {
        SFSafariViewController *sfViewController = [self getDetailViewControllerAtIndexPath:indexPath];
        if (sfViewController) {
            [self presentViewController:sfViewController animated:YES completion:nil];
        }
    } else {
        // Fallback on earlier versions
    }
}

#pragma mark UIScrollViewDelegate
/*
 使用 Threshold 进行预加载是一种最为常见的预加载方式，知乎客户端就使用了这种方式预加载条目，而其原理也非常简单，根据当前 UITableView 的所在位置，除以目前整个 UITableView.contentView 的高度，来判断当前是否需要发起网络请求：
 */
/*
 下面的代码在当前页面已经划过了 70% 的时候，就请求新的资源，加载数据；但是，仅仅使用这种方法会有另一个问题，尤其是当列表变得很长时，十分明显，比如说：用户从上向下滑动，总共加载了 5 页数据：
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    //当前所在位置
    //self.view.frame.size.height: 667.00
    CGFloat current = contentOffsetY + self.view.frame.size.height;

    //整个 UITableView.contentView 的高度
    CGFloat contentHeight = scrollView.contentSize.height;
    
//    NSLog(@"contentOffsetY: %.2f, self.view.frame.size.height: %.2f, contentSize.height: %.2f, ", scrollView.contentOffset.y, self.view.frame.size.height, scrollView.contentSize.height);

    if (self.view.frame.size.height == 812.0f) {
        // iPhone X 减去底部安全区域 34.0f
        current -= 34.0f;
    }
    
    float ratio = current / contentHeight;
    
#define threshold 0.7f    //阅读70%
#define itemPerPage 10.0f //每页10条数据

//https://zhuanlan.zhihu.com/p/23418800
    
    float needRead = itemPerPage * threshold + itemPerPage * (self.page - 1);
    
    float totalItem = itemPerPage * self.page;
    
    float newThreshold = needRead / totalItem;
    
    //NSLog(@"needRead: %.2f, totalItem: %.2f", needRead, totalItem);

    NSLog(@"ratio: %.2f, newThreshold: %.2f", ratio, newThreshold);

    if (ratio >= newThreshold && contentHeight > 0) {
        // 触发上拉加载更多
        if (self.isLoadingData || !self.hasMoreData) {
            return;
        }
        self.page += 1;
        [self.loadingMoreIndicatorView startAnimating];
        //加载数据
        [self requestUrlCacheData];
    }
}

#pragma mark event response 事件响应
//确认按钮触发事件
- (void)hanleTapEventForConfirmButton:(UIButton *)confirmButton
{
    NSLog(@"确认按钮触发事件");
}

//刷新控件触发事件
- (void)handleRefreshControl:(UIRefreshControl *)refreshControl
{
    if (self.isLoadingData) {
        //如果正在刷新, 结束刷新
        [self.refreshControl  endRefreshing];
        return;
    }
    
    NSLog(@"刷新控件响应事件");
    //恢复初始数据
    self.page = 1;
    self.hasMoreData = NO;
    
    //请求数据
    [self  requestUrlCacheData];
}


#pragma mark getter && setter
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray  arrayWithCapacity:0];
    }return _dataSource;
}

//确认按钮
- (UIButton *)confirmButton
{
    if (!_confirmButton) {
        self.confirmButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        _confirmButton.frame = CGRectMake(0, 0, 60, 26);
        [_confirmButton  setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton  addTarget:self action:@selector(hanleTapEventForConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
        _confirmButton.backgroundColor = [UIColor  darkGrayColor];
    }return _confirmButton;
}

//tipsViewModel
- (NTipsViewModel *)tipsViewModel
{
    if (!_tipsViewModel) {
        self.tipsViewModel = [[NTipsViewModel  alloc] init];
    }return _tipsViewModel;
}


//页数
- (NSInteger)page
{
    if (!_page) {
        self.page = 1;
    }return _page;
}

//是否正在加载数据
- (BOOL)isLoadingData
{
    if (!_isLoadingData) {
        self.isLoadingData = NO;
    }return _isLoadingData;
}

//是否有更多数据
- (BOOL)hasMoreData
{
    if (!_hasMoreData) {
        self.hasMoreData = NO;
    }return _hasMoreData;
}

//刷新控件
- (UIRefreshControl *)refreshControl
{
    if (!_refreshControl) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        //_refreshControl.attributedTitle = [[NSAttributedString  alloc] initWithString:@"正在刷新。。。"];
        //刷新控件
        [_refreshControl  addTarget:self action:@selector(handleRefreshControl:) forControlEvents:UIControlEventValueChanged];
    }return _refreshControl;
}

//tableView页脚
- (UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49.0f)];
        _tableFooterView.backgroundColor = [UIColor clearColor];
        [_tableFooterView addSubview:self.loadingMoreIndicatorView];
        self.loadingMoreIndicatorView.center = _tableFooterView.center;
    }
    return _tableFooterView;
}

//滑动指示器
- (UIActivityIndicatorView *)loadingMoreIndicatorView {
    if (!_loadingMoreIndicatorView) {
        _loadingMoreIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _loadingMoreIndicatorView;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


/*
 
 
 NSArray *array = responseObject[@"feeds"];
 //快速便利数组
 if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
 [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
 NTipsModel *model = [NTipsModel tipsModelWithDictionary:obj];
 if (model) {
 [self.dataSource addObject:model];
 }
 }];
 NSLog(@"请求数据了: %ld", array.count);
 //标识还有更多数据
 self.hasMoreData = YES;
 //添加页脚
 [self showTableViewFooter];
 }else{
 //没有更多数据了
 self.hasMoreData = NO;
 //清除页脚
 [self cleanTableViewFooter];
 }
 //结束刷新
 [self tipsDidEndRefresh];
 // 默认在主线程 刷新数据
 [weakSelf.tableView  reloadData];
 
 */

@end




