//
//  NCacheViewController.m
//  TestDelegate
//
//  Created by a on 2018/5/9.
//  Copyright © 2018年 a. All rights reserved.
//

#import "NCacheViewController.h"
#import "XYObjectCache.h"

#import "NFileCache.h"//文件缓存
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
    
    /*
    XYObjectCache *cache = [XYObjectCache shareInstance];
    [cache registerObjectClass:[NSString class]];
    
    NSString *key = @"key";
    
    NSString *str = nil;
    
    if ([cache hasCachedForKey:key] == NO) {
        NSLog(@"本地没有缓存");
        
        str = @"hello world";
        
    }else{
        
        NSLog(@"本地有缓存");
        
        // str = [cache objectForKey:key];
        
        str = @"这是本地缓存值";
    }
    
    //[cache  saveObject:str forKey:key];//异步保存
    
    [cache  saveObject:str forKey:key async:NO];//同步保存
    */
    
    
    NCacheManager *cacheManager = [NCacheManager  share];
    //[cacheManager  registerClass:[NSData class]];
    //[cacheManager  registerClass:[NSDictionary  class]];
    
//    NSString *key = @"name";
//    NSString *value = nil;
//
//    if ([cacheManager  hasObjectForKey:key]) {
//        value = [cacheManager  objectForKey:key];
//        NSLog(@"本地有缓存: %@", value);
//    }else{
//         value = @"李克强";
//         [cacheManager  setObject:value forKey:key];
//         NSLog(@"本地无缓存: %@", value);
//    }

    //NSString *key_dic = [NSString stringWithFormat:@"dic_%d", self.count++];
    
    /*
    if ([cacheManager  hasObjectForKey:key_dic]) {
        value_dic = [cacheManager  objectForKey:key_dic];
        //NSLog(@"本地有缓存: %@", value_dic);
    }else{
        value_dic = @{
                      @"name": @"李克强",
                      @"age": @12
                  };
        [cacheManager  setObject:value_dic forKey:key_dic];
        //NSLog(@"本地无缓存");
    }
    */
    
    __block NSString *key_dic = nil;
    __block NSDictionary *value_dic = nil;
    for (int i = 0; i < 100; i++) {
        key_dic = [NSString stringWithFormat:@"dic_%d", i + 1];
        value_dic = @{
                      @"name": [NSString  stringWithFormat:@"李克强-%d", i + 1],
                      @"age": @12
                      };
        [cacheManager  setObject:value_dic forKey:key_dic isAsync:NO];
    }
    
    
    //NSLog(@"value_dic: %@", [cacheManager   objectForKey:key_dic]);
    /*
     NSString *object = [cacheManager  objectForKey:key];
     NSLog(@"object: %@", object);
     */
    
//    NSDictionary *dic = (NSDictionary *)[cacheManager   objectForKey:key_dic];
//
//    [sender  setTitle:[NSString stringWithFormat:@"测试缓存/%@",dic[@"name"]] forState:UIControlStateNormal];
    //更新按钮标题
    /*
    [sender  setTitle:[NSString stringWithFormat:@"测试缓存/%@", [cacheManager objectForKey:key]] forState:UIControlStateNormal];
     */
}



@end



