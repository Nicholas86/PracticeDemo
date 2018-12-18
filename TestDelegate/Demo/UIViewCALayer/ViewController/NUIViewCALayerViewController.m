//
//  NUIViewCALayerViewController.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/10/14.
//  Copyright © 2018年 a. All rights reserved.
//

/*
 今天在做项目的时候需要去除数组中的重复元素使用到了NSSet,对它并不熟悉,所以记录下来方便以后查找
 */

#import "NUIViewCALayerViewController.h"
#import "NDog.h"
#import "NBaseSingle.h"
#import "NSingle.h"
#import "NAPPSingle.h"

@interface NUIViewCALayerViewController (){
    NSTimer *timer;
}
@property (nonatomic, strong) NSMutableArray *temp_array;
@property (nonatomic, strong) NSMutableSet *temp_set;
@property (nonatomic, strong) NSMutableDictionary *temp_dic;
@end

@implementation NUIViewCALayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UIView和CALayer的联系和区别";
    
    self.view.backgroundColor = [UIColor  whiteColor];
    
    [self  uiview_calayer];
    
    [self setObject];
    if (@available(iOS 10.0, *)) {
        timer = [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [self object];
        }];
    } else {
        // Fallback on earlier versions
    }
    [timer fire];
    
    // [self set];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)uiview_calayer
{
    CGRect frame = CGRectMake(100, 150, 200, 200);
    UIView  *backView = [[UIView  alloc] initWithFrame:frame];
    backView.backgroundColor = [UIColor lightGrayColor];
    backView.layer.masksToBounds = YES;
    [self.view  addSubview:backView];
}

- (void)set
{
    NSArray *array = @[@"哈", @"哼", @"呀"];
    // 通过数组创建集合. 集合是无序的
    NSSet *set = [NSSet setWithArray:array];
    NSLog(@"set: %@", set);
    //以数组的形式返回集合中所有的对象
    NSArray *temp_array = [set allObjects];
    NSLog(@"temp_array: %@", temp_array);
}

- (void)setObject
{
    NDog *dog1 = [[NDog alloc] init];
    dog1.name = @"哈";
    
    NDog *dog2 = [[NDog alloc] init];
    dog2.name = @"哼";
    
    NDog *dog3 = [[NDog alloc] init];
    dog3.name = @"啊";
    
    self.temp_dic[dog1.name] = dog1;
    self.temp_dic[dog2.name] = dog2;
    self.temp_dic[dog3.name] = dog2;
    
    [self.temp_set addObject:dog1];
    [self.temp_set addObject:dog2];
    [self.temp_set addObject:dog3];
    
    NSLog(@"---- temp_set: %@", _temp_set);
    
    self.temp_array = (NSMutableArray *)[self.temp_set allObjects];
}


- (void)object
{
    NDog *dog = self.temp_dic[@"哈"];
    dog.name = @"呀";
    [self.temp_set addObject:dog];
    
    NSLog(@"****** temp_set: %@", _temp_set);
    [self.temp_set enumerateObjectsUsingBlock:^(NDog *obj, BOOL * _Nonnull stop) {
        NSLog(@"temp_set, name: %@", obj.name);
    }];
    
    self.temp_array = (NSMutableArray *)[self.temp_set allObjects];
    [self.temp_array enumerateObjectsUsingBlock:^(NDog *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"temp_array, name: %@, idx: %lu", obj.name, (unsigned long)idx);
    }];
}


- (NSMutableArray *)temp_array
{
    if (!_temp_array) {
        self.temp_array = [NSMutableArray array];
    }return _temp_array;
}

- (NSMutableSet *)temp_set
{
    if (!_temp_set) {
        self.temp_set = [NSMutableSet set];
    }return _temp_set;
}

- (NSMutableDictionary *)temp_dic
{
    if (!_temp_dic) {
        self.temp_dic = [NSMutableDictionary  dictionary];
    }return _temp_dic;
}

@end




