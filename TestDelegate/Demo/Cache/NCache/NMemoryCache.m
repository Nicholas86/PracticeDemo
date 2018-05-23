//
//  NMemoryCache.m
//  TestDelegate
//
//  Created by 泽娄 on 2018/5/22.
//  Copyright © 2018年 a. All rights reserved.
//

#define XYMemoryCache_DEFAULT_MAX_COUNT  (48)

#import "NMemoryCache.h"

@interface NMemoryCache ()
    
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
        _clearWhenMemoryLow = YES;
        _maxCacheCount = XYMemoryCache_DEFAULT_MAX_COUNT;//最大缓存个数
        _cachedCount = 0; //缓存个数, 默认为0
    }return self;
}


#pragma mark - Private Methods
//是否含有某个key对应的值
- (BOOL)hasObjectForKey:(NSString *)key
{
    return [self.cacheObjDic  objectForKey:key] ? YES : NO;
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
    
    //缓存个数 +1
    _cachedCount += 1;
    
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
    
    //保存key到数组
    [self.cacheKeyArray  addObject:key];
    //保存key-value到字典
    [self.cacheObjDic  setObject:object forKey:key];
}

//取对应key的value
- (id)objectForKey:(NSString *)key
{
    return [self.cacheObjDic  objectForKey:key];
}

//删除对应key的值
- (void)removeObjectForKey:(NSString *)key
{
    if ([self  hasObjectForKey:key]) {
        [self.cacheObjDic  removeObjectForKey:key];
        [self.cacheKeyArray  removeObjectIdenticalTo:key];
        _cachedCount -= 1;//缓存个数-1
    }
}

//删除全部数据
- (void)removeAllObjects
{
    [self.cacheObjDic  removeAllObjects];
    [self.cacheKeyArray  removeAllObjects];
    _cachedCount = 0;
}


#pragma mark setter & getter
//缓存的所有key
- (NSMutableArray *)cacheKeyArray
{
    if (!_cacheKeyArray) {
        self.cacheKeyArray = [NSMutableArray  arrayWithCapacity:0];
    }return _cacheKeyArray;
}

//缓存字典 key-value形式
- (NSMutableDictionary *)cacheObjDic
{
    if (!_cacheObjDic) {
        self.cacheObjDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }return _cacheObjDic;
}

//最大缓存个数-外部设置后, 在这里处理, 重写setter方法
- (void)setMaxCacheCount:(NSUInteger)maxCacheCount
{
    while (_cachedCount > maxCacheCount) {
        //当 本地已经缓存的个数 > 外部设置的最大缓存个数, 就循环删除开始的数据
        NSLog(@"循环删除本地数据");
        @autoreleasepool{
            //用数组、字典结合, 就是为了循环处理这种情况。
            NSString *tempKey = [self.cacheKeyArray  objectAtIndex:0];
            [self.cacheKeyArray  removeObjectAtIndex:0];
            [self.cacheObjDic  removeObjectForKey:tempKey];
            _cachedCount -= 1;//个数-1
        }
    }
    
    //设置最大缓存数据
    _maxCacheCount = maxCacheCount;
}

@end








