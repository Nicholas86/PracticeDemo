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

@end

@implementation NCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"内存/磁盘缓存";
    
    
    //文件缓存
    [self  cacheObjcForFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleCacheButton:(UIButton *)sender
{
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
    
    //更新按钮标题
    [sender  setTitle:[NSString stringWithFormat:@"测试缓存/%@", [cache objectForKey:key]] forState:UIControlStateNormal];
    NSLog(@"获取本地缓存:%@", [cache objectForKey:key]);
}

//文件缓存
- (void)cacheObjcForFile
{
    NCacheManager *cacheManager = [NCacheManager  share];
    [cacheManager  registerClass:[NSString class]];
    
    NSString *key = @"name";
    NSString *value = nil;
    
    if ([cacheManager  hasObjectForKey:key]) {
        value = [cacheManager  objectForKey:key];
        NSLog(@"本地有缓存: %@", value);
    }else{
        /*
            value = @"李克强";
            [cacheManager  setObject:value forKey:key];
            NSLog(@"本地无缓存: %@", value);
         */
    }
    /*
        NSString *object = [cacheManager  objectForKey:key];
        NSLog(@"object: %@", object);
     */
}


@end



