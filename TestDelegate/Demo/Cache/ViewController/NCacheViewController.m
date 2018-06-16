//
//  NCacheViewController.m
//  TestDelegate
//
//  Created by a on 2018/5/9.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NCacheViewController.h"
#import "XYObjectCache.h"
#import "NCacheManager.h"//文件缓存管理类

@interface NCacheViewController ()
@property (nonatomic, assign) int count;
@end

@implementation NCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"内存/磁盘缓存";
    
    self.count = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleCacheButton:(UIButton *)sender
{
    NCacheManager *cacheManager = [NCacheManager  share];
#warning 线程安全 copy https://blog.csdn.net/u013883974/article/details/77645212
    //模拟并发执行, 写操作, 处理线程安全
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 10; i++) {
            NSLog(@"第一个");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *key_dic = [NSString stringWithFormat:@"dic_%d", i];
                NSDictionary *value_dic = @{
                                            @"name": [NSString  stringWithFormat:@"线程安全是大问题-%d", i],
                                            @"age": @(i)
                                            };
                [cacheManager  setObject:value_dic forKey:key_dic];
                //主线程刷新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    [sender  setTitle:[[cacheManager  objectForKey:@"dic_2"] objectForKey:@"name"] forState:UIControlStateNormal];
                });
            });
        }
    });
    
    /*
    //模拟并发执行, 删除操作, 处理线程安全
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 20; i++) {
            NSLog(@"第二个");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *key_dic = [NSString stringWithFormat:@"dic_%d", i + 1];
                if ([cacheManager  hasObjectForKey:key_dic]) {
                    NSDictionary *dic = [cacheManager objectForKey:key_dic];
                    [cacheManager  removeObjectForKey:key_dic];
                    NSLog(@"第二个, name: %@", dic[@"name"]);
                }
            });
        }
    });
    
    //模拟并发执行, 读操作, 处理线程安全
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < 100; i++) {
            NSLog(@"第仨个");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *key_dic = [NSString stringWithFormat:@"dic_%d", i + 1];
                if ([cacheManager  hasObjectForKey:key_dic]) {
                    NSDictionary *dic = [cacheManager objectForKey:key_dic];
                    //主线程刷新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSLog(@"第三个, name: %@", dic[@"name"]);
                     [sender  setTitle:[NSString stringWithFormat:@"测试缓存/%@",dic[@"name"]] forState:UIControlStateNormal];
                    });
                }else{
                    //主线程刷新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [sender  setTitle:[NSString stringWithFormat:@"测试缓存/没有缓存了"] forState:UIControlStateNormal];
                    });
                }
            });
        }
    });
    
    */
}

@end


