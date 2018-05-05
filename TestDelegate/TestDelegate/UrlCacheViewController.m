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

@interface UrlCacheViewController ()<UITableViewDelegate, UITableViewDataSource>
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
    
    self.title = @"控制器代码规范";
    
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
    
    [self.view  addSubview:self.confirmButton];
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
    
    [self.tipsViewModel  requestTipsDataWithPage:self.page successBlock:^(NSDictionary *responseObject) {
        
        NSArray *array = responseObject[@"feeds"];
        
        //快速便利数组
        if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
            [array enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NTipsModel *model = [NTipsModel tipsModelWithDictionary:obj];
                if (model) {
                    [self.dataSource addObject:model];
                }
            }];
            
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
        
    } failureBlock:^(NSError *error) {
        
        //结束刷新
        [self  tipsDidEndRefresh];
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
    
    return cell;
}

//单元格选中事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"单元格选中事件");
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat contentHeight = scrollView.contentSize.height;
    CGFloat delta = contentOffsetY + self.view.frame.size.height;
    if (self.view.frame.size.height == 812.0f) {
        // iPhone X 减去底部安全区域 34.0f
        delta -= 34.0f;
    }
    if (delta + 10.0f >= contentHeight && contentHeight > 0) {
        // 触发上拉加载更多
        if (self.isLoadingData || !self.hasMoreData) {
            return;
        }
        NSLog(@"滑动。contentOffset.y: %.2f, contentSize.height: %.2f", scrollView.contentOffset.y, scrollView.contentSize.height);
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
        _confirmButton.frame = CGRectMake(100, 300, 200, 60);
        [_confirmButton  setTitle:@"确认" forState:UIControlStateNormal];
        [_confirmButton  addTarget:self action:@selector(hanleTapEventForConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
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

@end
