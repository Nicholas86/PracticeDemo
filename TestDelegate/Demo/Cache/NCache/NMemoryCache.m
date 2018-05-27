//
//  NMemoryCache.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//


#define XYMemoryCache_DEFAULT_MAX_COUNT  (48)
#import <UIKit/UIKit.h>//导入UIkit框架
#import "NMemoryCache.h"

@interface NMemoryCache (){
    dispatch_queue_t _serial_queue; //串行队列
    NSLock *_lock;//锁🔐
}

@property (nonatomic, strong) NSMutableArray *cacheKeyArray; //保存所有key
@property (nonatomic, strong) NSMutableDictionary *cacheObjDic;//保存key-value
@end

@implementation NMemoryCache
//单例
+ (instancetype)share
{
    static NMemoryCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NMemoryCache  alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _clearWhenMemoryLow = YES;//是否清除内存,默认YES
        _maxCacheCount = XYMemoryCache_DEFAULT_MAX_COUNT;//最大缓存个数
        _cachedCount = 0; //缓存个数, 默认为0
        //创建串行队列:再创建异步子线程,具备开启子线程能力, 队列里的任务按顺序执行
        _serial_queue = dispatch_queue_create("com.nicholas.memory.cache", DISPATCH_QUEUE_SERIAL);
        //创建并初始化锁🔐
        _lock = [[NSLock alloc] init];
        _lock.name = @"memory.cache.lock";
        [self  registerMemoryCacheNotification];
    }return self;
}

/*
 NSLock 不能当做 循环锁
 (也有称作递归锁或嵌套锁的，主要特点是允许相同线程 多次上锁，并通过多次 unlock来解锁）来使用
 同一线程在 lock之后 未unlock 之前 再次 lock 会造成 永久性死锁。
 */

- (void)registerMemoryCacheNotification
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    //内存警告
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    //终止
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationWillTerminateNotification object:nil];
    //进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
#endif    // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

#pragma mark - Private Methods
//是否含有某个key对应的值
- (BOOL)hasObjectForKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return NO;
    }
    //加锁
    [_lock  lock];
    BOOL isHave = [self.cacheObjDic  objectForKey:key] ? YES : NO;
    //解锁
    [_lock  unlock];
    return isHave;
}

//添加key-value
- (void)setObject:(id)object forKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return;
    }
    
    if (object == nil) {
        NSLog(@"object is null");
        return;
    }
    
    /*
    self.cacheKeyArray: (
         470dcd7b646bfcf16d7f0e85bd145ac4,
         470dcd7b646bfcf16d7f0e85bd145ac4,
         470dcd7b646bfcf16d7f0e85bd145ac4,
         470dcd7b646bfcf16d7f0e85bd145ac4
     )
     */
    
    
    //加锁🔐
    [_lock  lock];
    
    //本地内存数组已经有key, 先删除key, 保存内存数组元素唯一, 一个key对应一个value
    if ([self.cacheObjDic  objectForKey:key]) {
        [self.cacheKeyArray  removeObject:key];
    }else{
        //缓存个数 +1
        _cachedCount += 1;
    }
    
    @autoreleasepool{
        while (_cachedCount >= _maxCacheCount) {
            // 本地已经缓存个数 >= 最大缓存个数
            //从第一个开始清除, 知道 本地已经缓存个数 < 最大缓存个数
            @autoreleasepool{
                NSString *tempKey = [self.cacheKeyArray  objectAtIndex:0];
                [self.cacheKeyArray  removeObjectAtIndex:0];
                [self.cacheObjDic  removeObjectForKey:tempKey];
                _cachedCount -= 1; //本地缓存个数-1
            }
        }
    }
    
    [self.cacheKeyArray  addObject:key];
    [self.cacheObjDic  setObject:object forKey:key];
    //NSLog(@"self.cacheObjDic: %@", self.cacheObjDic);
    //解锁🔐
    [_lock  unlock];
}

//取对应key的value
- (id)objectForKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return nil;
    }
    
    [_lock lock];
    id object = [self.cacheObjDic  objectForKey:key];
    [_lock unlock];
    return object;
}

//删除对应key的值
- (void)removeObjectForKey:(NSString *)key
{
    if ([key length] == 0) {
        NSLog(@"key is null");
        return ;
    }
    [_lock  lock];
    if ([self.cacheObjDic  objectForKey:key]) {
        [self.cacheObjDic  removeObjectForKey:key];
        [self.cacheKeyArray  removeObjectIdenticalTo:key];
        _cachedCount -= 1;//缓存个数-1
    }
    [_lock  unlock];
}

//删除全部数据
- (void)removeAllObjects
{
    [_lock  lock];
    [self.cacheObjDic  removeAllObjects];
    [self.cacheKeyArray  removeAllObjects];
    _cachedCount = 0;
    [_lock  unlock];
}

#pragma mark event response 事件响应
//接收内存警告通知
- (void)handleMemoryCacheNotification:(NSNotification *)notification
{
#if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
    if ([notification.name isEqualToString:UIApplicationDidReceiveMemoryWarningNotification]){
        //只有内存警告才清空缓存, 进入后台不清空缓存
        if ( _clearWhenMemoryLow ){
            NSLog(@"收到内存警告通知");
            [self removeAllObjects];
        }
    }
#endif    // #if (TARGET_OS_IPHONE || TARGET_IPHONE_SIMULATOR)
}

#pragma mark setter & getter
//缓存的所有key
- (NSMutableArray *)cacheKeyArray
{
    if (!_cacheKeyArray) {
        self.cacheKeyArray = [NSMutableArray  arrayWithCapacity:0];
    }
    return _cacheKeyArray;
}

//缓存字典 key-value形式
- (NSMutableDictionary *)cacheObjDic
{
    if (!_cacheObjDic) {
        self.cacheObjDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _cacheObjDic;
}

//是否清空内存
- (void)setClearWhenMemoryLow:(BOOL)clearWhenMemoryLow
{
    [_lock  lock];
    if (clearWhenMemoryLow == YES){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryCacheNotification:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    _clearWhenMemoryLow = clearWhenMemoryLow;
    [_lock  unlock];
}


//最大缓存个数-外部设置后, 在这里处理, 重写setter方法
- (void)setMaxCacheCount:(NSUInteger)maxCacheCount
{
    [_lock  lock];
    while (_cachedCount > maxCacheCount) {
        //当 本地已经缓存的个数 > 外部设置的最大缓存个数, 就循环删除开始的数据
        NSLog(@"循环删除本地数据");
        //用数组、字典结合, 就是为了循环处理这种情况。
        NSString *tempKey = [self.cacheKeyArray  objectAtIndex:0];
        [self.cacheKeyArray  removeObjectAtIndex:0];
        [self.cacheObjDic  removeObjectForKey:tempKey];
        _cachedCount -= 1;//个数-1
    }
    
    //设置最大缓存数据
    _maxCacheCount = maxCacheCount;
    [_lock  unlock];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end




